#!/bin/sh

#
# Step 1: Detect the operating system
#
MAC="Mac OS X"
WIN="Windows"
LIN="Linux"

if [ `uname` = "Darwin" ]; then
    OS=$MAC
elif [ `uname` = "Linux" ]; then
    OS=$LIN
else
    OS=$WIN
fi

# Move to src dir
APP_PATH=`echo $0 | awk '{split($0,patharr,"/"); idx=1; while(patharr[idx+1] != "") { if (patharr[idx] != "/") {printf("%s/", patharr[idx]); idx++ }} }'`
APP_PATH=`cd "$APP_PATH"; pwd` 
cd "$APP_PATH"

GAME_NAME=${APP_PATH##*/}
ICON=SwinGame
FULL_APP_PATH=$APP_PATH
APP_PATH="."

GAME_MAIN=""

#Set the basic paths
OUT_DIR="${APP_PATH}/bin"
FULL_OUT_DIR="${FULL_APP_PATH}/bin"
TMP_DIR="${APP_PATH}/tmp"
SRC_DIR="${APP_PATH}/src"



LOG_FILE="${APP_PATH}/out.log"

PAS_FLAGS="-O3 -vw"
SG_INC="-Fu${APP_PATH}/lib/"

FPC_BIN=`which fpc`

CLEAN="N"

#
# Library versions
#
OPENGL=false
SDL_13=false


Usage()
{
    echo "Usage: [-c] [-h] [name]"
    echo 
    echo "Compiles your game into an executable application."
    echo "Output is located in $OUT_DIR."
    echo
    echo "Options:"
    echo " -c   Perform a clean rather than a build"
    echo " -h   Show this help message "
    echo " -i [icon] Change the icon file"
    echo " -r   Create a release version that does not include debug information"
    exit 0
}

RELEASE=""

while getopts chdi:g:b: o
do
    case "$o" in
    c)  CLEAN="Y" ;;
    b)  if [ "${OPTARG}" = "adass" ]; then
            SDL_13=true
        fi 
        ;;
    h)  Usage ;;
    g)  if [ "${OPTARG}" = "odly" ]; then
            OPENGL=true
        fi 
        ;;
    r)  RELEASE="Y" ;;
    i)  ICON="$OPTARG";;
    esac
done

shift $((${OPTIND}-1))

if [ "$OS" = "$MAC" ]; then
    if [ ${SDL_13} = true ]; then
      TMP_DIR="${TMP_DIR}/badass"
      LIB_DIR="${APP_PATH}/lib/sdl13/mac"
    elif [ ${OPENGL} = true ]; then
        TMP_DIR="${TMP_DIR}/godly"
      LIB_DIR="${APP_PATH}/lib/godly/mac"
    else
      TMP_DIR="${TMP_DIR}/sdl12"
      LIB_DIR="${APP_PATH}/lib/mac"
    fi
elif [ "$OS" = "$WIN" ]; then
    #
    # This needs 1.3 versions of SDL for Windows...
    # along with function sdl_gfx, sdl_ttf, sdl_image, sdl_mixer
    #
    
    # if [ ${SDL_13} = true ]; then
    #   LIB_DIR="${APP_PATH}/lib/sdl13/win"
    # elif [ ${OPENGL} = true ]; then
    #   LIB_DIR="${APP_PATH}/lib/sdl13/win"
    # else
    LIB_DIR="${APP_PATH}/lib/win"
    OPENGL=false
    SDL_13=false
    # fi
fi

#
# Change directories based on release or debug builds
#
if [ -n "${RELEASE}" ]; then
    OUT_DIR="${OUT_DIR}/Release"
    FULL_OUT_DIR="${FULL_OUT_DIR}/Release"
    TMP_DIR="${TMP_DIR}/Release"
else
  #its a debug build
  if [ "$OS" = "$MAC" ]; then
      PAS_FLAGS="-gw -vw"
  else
      PAS_FLAGS="-g -vw"
  fi
  OUT_DIR="${OUT_DIR}/Debug"
  FULL_OUT_DIR="${FULL_OUT_DIR}/Debug"
  TMP_DIR="${TMP_DIR}/Debug"
fi

if [ ! -d ${TMP_DIR} ]; then
    mkdir -p ${TMP_DIR}
fi

if [ -f "${LOG_FILE}" ]; then
    rm -f "${LOG_FILE}"
fi


if [ ${SDL_13} = true ]; then
  PAS_FLAGS="${PAS_FLAGS} -dSWINGAME_SDL13"
fi

if [ ${OPENGL} = true ]; then
  PAS_FLAGS="-dSWINGAME_OPENGL -dSWINGAME_SDL13"
fi


DoExitCompile ()
{ 
    echo "An error occurred while compiling"; 
    cat out.log
    exit 1; 
}

CleanTmp()
{
    if [ -d "${TMP_DIR}" ]
    then
        rm -rf "${TMP_DIR}"
    fi
    mkdir "${TMP_DIR}"
}

doDriverMessage()
{
  if [ ${SDL_13} = true ]; then
    echo "  ... Using SDL 1.3 Driver"
  elif [ ${OPENGL} = true ]; then
    echo "  ... Using OpenGL Driver"
  else
    echo "  ... Using SDL 1.2 Driver"
  fi
}

doBasicMacCompile()
{
    mkdir -p ${TMP_DIR}
    echo "  ... Compiling $GAME_MAIN"
    
    FRAMEWORKS=`ls -d ${LIB_DIR}/*.framework | awk -F . '{split($2,patharr,"/"); idx=1; while(patharr[idx+1] != "") { idx++ } printf("-framework %s ", patharr[idx]) }'`
    
    ${FPC_BIN}  ${PAS_FLAGS} ${SG_INC} -Mobjfpc -Sh -FE"${OUT_DIR}" -FU"${TMP_DIR}" -Fu"${LIB_DIR}" -Fi"${SRC_DIR}" -k"-F'${LIB_DIR}' -framework Cocoa ${FRAMEWORKS}" -o"${GAME_NAME}" -k"-rpath @loader_path/../Frameworks" "${SRC_DIR}/${GAME_MAIN}" > "${LOG_FILE}"
    if [ $? != 0 ]; then DoExitCompile; fi
}

#
# Compile for Mac - manually assembles and links files
# argument 1 is arch
#
doMacCompile()
{
    mkdir -p ${TMP_DIR}/${1}
    echo "  ... Compiling $GAME_MAIN - $1"
    
    FRAMEWORKS=`ls -d "${LIB_DIR}"/*.framework | awk -F . '{split($2,patharr,"/"); idx=1; while(patharr[idx+1] != "") { idx++ } printf("-framework %s ", patharr[idx]) }'`
    
    ${FPC_BIN} ${PAS_FLAGS} ${SG_INC} -Mobjfpc -Sh -FE"${TMP_DIR}/${1}" -FU"${TMP_DIR}/${1}" -Fu"${LIB_DIR}" -Fi"${SRC_DIR}" -k"-F${LIB_DIR} -framework Cocoa ${FRAMEWORKS}" $2 -o"${TMP_DIR}/${1}/${GAME_NAME}" -k"-rpath @loader_path/../Frameworks" "${SRC_DIR}/${GAME_MAIN}" > ${LOG_FILE}
    
    if [ $? != 0 ]; then DoExitCompile; fi
}

# 
# Create fat executable (i386 + ppc)
# 
doLipo()
{
    echo "  ... Combining ${1} and ${2} into Universal Binary"
    lipo -arch ${1} "${TMP_DIR}/${1}/${GAME_NAME}" -arch ${2} "${TMP_DIR}/${2}/${GAME_NAME}" -output "${OUT_DIR}/${GAME_NAME}" -create
}

doMacPackage()
{
    GAMEAPP_PATH="${FULL_OUT_DIR}/${GAME_NAME}.app"
    if [ -d "${GAMEAPP_PATH}" ] 
    then
    	echo "  ... Removing old application"
    	rm -rf "${GAMEAPP_PATH}"
    fi

    echo "  ... Creating Application Bundle"
    
    mkdir "${GAMEAPP_PATH}"
    mkdir "${GAMEAPP_PATH}/Contents"
    mkdir "${GAMEAPP_PATH}/Contents/MacOS"
    mkdir "${GAMEAPP_PATH}/Contents/Resources"
    mkdir "${GAMEAPP_PATH}/Contents/Frameworks"

    echo "  ... Adding Private Frameworks"
    cp -R -p "${LIB_DIR}/"*.framework "${GAMEAPP_PATH}/Contents/Frameworks/"
    
    mv "${FULL_OUT_DIR}/${GAME_NAME}" "${GAMEAPP_PATH}/Contents/MacOS/" 
    ICON="${GAMEAPP_PATH}/Contents/Resources/SwinGame.icns"
    echo "<?xml version='1.0' encoding='UTF-8'?>\
    <!DOCTYPE plist PUBLIC \"-//Apple Computer//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\
    <plist version=\"1.0\">\
    <dict>\
            <key>CFBundleDevelopmentRegion</key>\
            <string>English</string>\
            <key>CFBundleExecutable</key>\
            <string>${GAME_NAME}</string>\
            <key>CFBundleIconFile</key>\
            <string>${ICON}</string>\
            <key>CFBundleIdentifier</key>\
            <string>au.edu.swinburne.${GAME_NAME}</string>\
            <key>CFBundleInfoDictionaryVersion</key>\
            <string>6.0</string>\
            <key>CFBundleName</key>\
            <string>${GAME_NAME}</string>\
            <key>CFBundlePackageType</key>\
            <string>APPL</string>\
            <key>CFBundleSignature</key>\
            <string>SWIN</string>\
            <key>CFBundleVersion</key>\
            <string>1.0</string>\
            <key>CSResourcesFileMapped</key>\
            <true/>\
    </dict>\
    </plist>" >> "${GAMEAPP_PATH}/Contents/Info.plist"

    echo "APPLSWIN" >> "${GAMEAPP_PATH}/Contents/PkgInfo"

    RESOURCE_DIR="${GAMEAPP_PATH}/Contents/Resources"
}

doLinuxCompile()
{
    mkdir -p ${TMP_DIR}
    echo "  ... Compiling $GAME_MAIN"
    
    ${FPC_BIN}  ${PAS_FLAGS} ${SG_INC} -Mobjfpc -Sh -FE${OUT_DIR} -FU${TMP_DIR} -Fu${LIB_DIR} -Fi${SRC_DIR} -o"${GAME_NAME}" ${SRC_DIR}/${GAME_MAIN} > ${LOG_FILE}
    if [ $? != 0 ]; then DoExitCompile; fi
}

doLinuxPackage()
{
    RESOURCE_DIR="${FULL_OUT_DIR}/Resources"
}

doWindowsCompile()
{
    mkdir -p ${TMP_DIR}
    
    echo "  ... Compiling $GAME_MAIN"
    
    #
    # If using full path then you need to escape the /c/ used by MSYS
    #
    # LIB_DIR=`echo $LIB_DIR | sed 's/\/\(.\)\//\1:\//'`          #awk '{sub("/c/", "c:/"); print}'`
    # TMP_DIR=`echo $TMP_DIR | sed 's/\/\(.\)\//\1:\//'`          #awk '{sub("/c/", "c:/"); print}'`
    # SRC_DIR=`echo $SRC_DIR | sed 's/\/\(.\)\//\1:\//'`          #awk '{sub("/c/", "c:/"); print}'`
    # OUT_DIR=`echo $OUT_DIR | sed 's/\/\(.\)\//\1:\//'`          #awk '{sub("/c/", "c:/"); print}'`
    # SG_INC=`echo $SG_INC | sed 's/\/\(.\)\//\1:\//'`            #awk '{sub("/c/", "c:/"); print}'`
    # SG_INC=`echo $SG_INC | sed 's/\/\(.\)\//\1:\//'`            #awk '{sub("/c/", "c:/"); print}'`
    # SG_INC=`echo $SG_INC | sed 's/\/\(.\)\//\1:\//'`            #awk '{sub("/c/", "c:/"); print}'`

    echo "  ... Creating Resources"
    windres ${SRC_DIR}/SwinGame.rc ${SRC_DIR}/GameLauncher.res
    if [ $? != 0 ]; then DoExitCompile; fi
    
    ${FPC_BIN}  ${PAS_FLAGS} ${SG_INC} -Mobjfpc -Sh -FE${OUT_DIR} -FU${TMP_DIR} -Fu${LIB_DIR} -Fi${SRC_DIR} -o"${GAME_NAME}.exe" ${SRC_DIR}/${GAME_MAIN} > ${LOG_FILE}
    if [ $? != 0 ]; then DoExitCompile; fi
    
}

doWindowsPackage()
{
    RESOURCE_DIR=${FULL_OUT_DIR}/Resources
    
    echo "  ... Copying libraries"
    cp -p -f "${LIB_DIR}"/*.dll "${FULL_OUT_DIR}"
}


copyWithoutSVN()
{
    FROM_DIR=$1
    TO_DIR=$2
    
    cd "${FROM_DIR}"
    
    # Create directory structure
    find . -mindepth 1 ! -path \*.svn\* ! -path \*/. -type d -exec mkdir -p "${TO_DIR}/{}" \;
    if [ $? != 0 ]; then DoExitCompile; fi
    
    # Copy files and links
    find . ! -path \*.svn\* ! -name \*.DS_Store ! -type d -exec cp -R -p "{}" "${TO_DIR}/{}"  \;
    if [ $? != 0 ]; then DoExitCompile; fi
}

#
# Copy Resources from standard location to $RESOURCE_DIR
#
doCopyResources()
{
    echo "  ... Copying Resources into $GAME_NAME"
    
    copyWithoutSVN "${FULL_APP_PATH}/Resources" "${RESOURCE_DIR}"
}

#
# Locate GameMain.pas
#
locateGameMain()
{
  cd "${SRC_DIR}"
  fileList=$(find "." -maxdepth 1 -type f -name \*.pas)
  FILE_COUNT=$(echo "$fileList" | tr " " "\n" | wc -l)
  
  if [ ${FILE_COUNT} = 1 ]; then
    GAME_MAIN=${fileList[0]}
  else
    echo "Select the file to compile for your game"
    PS3="File number: "
  
    select fileName in $fileList; do
        if [ -n "$fileName" ]; then
            GAME_MAIN=${fileName}
        fi
      
        break
    done
  fi
  
  cd "${FULL_APP_PATH}"
  
  if [ ! -f "${SRC_DIR}/${GAME_MAIN}" ]; then
    echo "Cannot find file to compile, was looking for ${GAME_MAIN}"
    exit -1
  fi
}

locateGameMain

if [ $CLEAN = "N" ]
then
    if [ ! -d "${OUT_DIR}" ]
    then
        mkdir -p "${OUT_DIR}"
    fi
    
    echo "--------------------------------------------------"
    echo "          Creating $GAME_NAME"
    echo "          for $OS"
    echo "--------------------------------------------------"
    echo "  Running script from $FULL_APP_PATH"
    echo "  Saving output to $OUT_DIR"
    echo "  Compiler flags ${SG_INC} ${PAS_FLAGS}"
    echo "--------------------------------------------------"
    doDriverMessage
    echo "  ... Creating ${GAME_NAME}"
    
    if [ "$OS" = "$MAC" ]; then
        HAS_PPC=false
        HAS_i386=false
        HAS_LEOPARD_SDK=false
        HAS_LION=false
        OS_VER=`sw_vers -productVersion | awk -F . '{print $1"."$2}'`
        
        if [ -f /usr/libexec/gcc/darwin/ppc/as ]; then
            HAS_PPC=true
        fi
        
        if [ -f /usr/libexec/gcc/darwin/i386/as ]; then
            HAS_i386=true
        fi
        
        if [ -d /Developer/SDKs/MacOSX10.5.sdk ]; then
            HAS_LEOPARD_SDK=true
        fi
        
        if [ $OS_VER = '10.5' ]; then
            HAS_LEOPARD_SDK=true
        fi
        
        if [ $OS_VER = '10.7' ]; then
            HAS_LION=true
        fi
        
        if [[ $HAS_i386 = true && $HAS_PPC = true && $HAS_LEOPARD_SDK ]]; then
            echo "  ... Building Universal Binary"
            
            if [ $OS_VER = '10.5' ]; then
                FPC_BIN=`which ppc386`
                doMacCompile "i386" ""
                
                FPC_BIN=`which ppcppc`
                doMacCompile "ppc" ""
            else
                FPC_BIN=`which ppc386`
                doMacCompile "i386" "-k-syslibroot -k/Developer/SDKs/MacOSX10.5.sdk -k-macosx_version_min -k10.5"
                
                FPC_BIN=`which ppcppc`
                doMacCompile "ppc" "-k-syslibroot -k/Developer/SDKs/MacOSX10.5.sdk -k-macosx_version_min -k10.5"
            fi
            
            doLipo "i386" "ppc"
        else
            if [[ $HAS_LION = true ]]; then
                PAS_FLAGS="$PAS_FLAGS -k-macosx_version_min -k10.7 -k-no_pie"
            fi
            doBasicMacCompile
        fi
        
        doMacPackage
    elif [ "$OS" = "$LIN" ]; then
        doLinuxCompile
        doLinuxPackage
    else
        doWindowsCompile
        doWindowsPackage
    fi
    
    doCopyResources
else
    CleanTmp
    rm -rf "${OUT_DIR}"
    mkdir "${OUT_DIR}"
    echo    ... Cleaned
fi

#remove temp files on success
rm -f ${LOG_FILE} 2>> /dev/null

echo "  Finished"
echo "--------------------------------------------------"