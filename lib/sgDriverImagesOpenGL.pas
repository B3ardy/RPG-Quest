unit sgDriverImagesOpenGL;
//=============================================================================
// sgDriverImagesSDL13.pas
//=============================================================================
//
//
//
// 
//
// Notes:
//    - Pascal PChar is equivalent to a C-type string
//    - Pascal Word is equivalent to a Uint16
//    - Pascal LongWord is equivalent to a Uint32
//    - Pascal SmallInt is equivalent to Sint16
//
//=============================================================================
interface
  uses {$IFDEF IOS}gles11;{$ELSE}gl, glext;{$ENDIF}

  type
    PTexture = ^Cardinal;
  
  procedure LoadOpenGLImagesDriver();
    
implementation
  uses sgTypes,
       sgDriverGraphics, sdl13, sgShared, sgDriverImages, sdl13_image, SysUtils, sgSharedUtils, GLDriverUtils; // sdl;
  const
    // PixelFormat
    GL_COLOR_INDEX     = $1900;
    GL_STENCIL_INDEX   = $1901;
    GL_DEPTH_COMPONENT = $1902;
    GL_RED             = $1903;
    GL_GREEN           = $1904;
    GL_BLUE            = $1905;
    GL_ALPHA           = $1906;
    GL_RGB             = $1907;
    GL_RGBA            = $1908;
    GL_LUMINANCE       = $1909;
    GL_LUMINANCE_ALPHA = $190A;
    GL_BGR             = $80E0;
    GL_BGRA            = $80E1;

  procedure InitBitmapColorsProcedure(bmp : Bitmap);
  begin   
    exit;
  end;
      
  function SurfaceExistsProcedure(bmp : Bitmap) : Boolean;
  begin
    result := false;
  end;
  

  procedure CreateBitmapProcedure(bmp : Bitmap; width, height : LongInt);
  begin   
    exit;
  end;

  // Sets the non-transparent pixels in a Bitmap. This is then used for
  // collision detection, allowing the original surface to be optimised.
  //
  // @param bmp  A pointer to the Bitmap being set
  // @param surface The surface with pixel data for this Bitmap
  procedure SetNonTransparentPixels(bmp: Bitmap; transparentColor: Color);
  begin   
    exit;
  end;
  
  procedure SetNonAlphaPixelsProcedure(bmp : Bitmap); 
  begin   
    exit;
  end;

  procedure ToRGBA(var srcImg : PSDL_Surface);
  var
    temp: PSDL_Surface;
    pixelFormat : SDL_PIXELFORMAT;
  begin
    pixelFormat := srcImg^.format^;
    
    pixelFormat.format := SDL_PIXELFORMAT_RGBA8888;
    pixelFormat.Rmask  := $000000FF;
    pixelFormat.Gmask  := $0000FF00;
    pixelFormat.Bmask  := $00FF0000;
    pixelFormat.Amask  := $FF000000;
    pixelFormat.Rloss  := 0;
    pixelFormat.Gloss  := 0;
    pixelFormat.Bloss  := 0;
    pixelFormat.Aloss  := 0; 
    pixelFormat.Rshift := 0;
    pixelFormat.Gshift := 8;
    pixelFormat.Bshift := 16;
    pixelFormat.Ashift := 24;

    temp := SDL_ConvertSurface(srcImg, @pixelFormat, 0);
    if Assigned(temp) then
    begin
      SDL_FreeSurface(srcImg);
      srcImg := temp;
    end;
  end;

  function PowerOfTwo(dimension : LongInt) : LongInt;
  begin
    result := 1;
    while (result <= dimension) do 
    begin
      result *= 2;
    end;
  end;
  


  function CreateGLTextureFromSurface(lLoadedImg : PSDL_Surface) : PTexture;
  // var
  //   lFormat : GLenum;
  //   lNoOfColors : GLint;
  begin
    result := nil;
    if (Assigned(lLoadedImg) ) then
    begin
      
      // check not 0 w/h    
      if ( lLoadedImg^.w  = 0 ) or ( lLoadedImg^.h = 0 ) then
      begin
        WriteLn('BadStuff');
        exit;
      end;
      New(result);


      // // get the number of channels in the SDL surface
      // lNoOfColors := lLoadedImg^.format^.BytesPerPixel;

      // if (lNoOfColors = 4) then    // contains an alpha channel
      // begin
      //   if (lLoadedImg^.format^.Rmask = $000000FF) then
      //     lFormat := GL_RGBA
      //   else
      //     lFormat := GL_BGRA
      // end else if (lNoOfColors = 3) then     // no alpha channel
      // begin
      //   if (lLoadedImg^.format^.Rmask = $0000FF) then
      //     lFormat := GL_RGB
      //   else
      //     lFormat := GL_BGR;
      // end;  
      
      // { $IFDEF IOS}
      //   if(lFormat = GL_BGRA) then
      //   begin    
      //     lLoadedImg := BGRAToRGBA(lLoadedImg);
      //     lFormat := GL_RGBA;
      //   end;
      // { $ENDIF}  
    
      // Have OpenGL generate a texture object handle for us
      glGenTextures( 1, result );
     
      // Bind the texture object
      glBindTexture( GL_TEXTURE_2D, result^ );

      glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
     
      // Set the texture's stretching properties
      glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST );
      glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST );
      glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
      glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
     
     // WriteLn('lFormat ', lFormat, ' BGRA: ', GL_BGRA, ' RGBA: ', GL_RGBA);

      // Edit the texture object's image data using the information SDL_Surface gives us
      {$IFDEF IOS}
        glTexImage2D( GL_TEXTURE_2D, 0, GL_RGBA, lLoadedImg^.w, lLoadedImg^.h, 0,
                          GL_RGBA, GL_UNSIGNED_BYTE, lLoadedImg^.pixels );
      {$ELSE}
        glTexImage2D( GL_TEXTURE_2D, 0, GL_RGBA, lLoadedImg^.w, lLoadedImg^.h, 0,
                          GL_RGBA, GL_UNSIGNED_BYTE, lLoadedImg^.pixels );
      glBindTexture( GL_TEXTURE_2D, 0 );
      {$ENDIF}
    end;
  end; 
  
  procedure PutSurfacePixel(surf : PSDL_Surface; clr: Color; x, y: Longint);
  var
      p:    ^Color;
      bpp:  Longint;
  begin
      if not Assigned(surf) then begin RaiseWarning('OpenGL Images Driver - PutPixelProcedure recieved empty Surface'); exit; end;
        
      bpp := surf^.format^.BytesPerPixel;
      // Here p is the address to the pixel we want to set
      p := surf^.pixels + y * surf^.pitch + x * bpp;
      
      if bpp <> 4 then RaiseException('PutPixel only supported on 32bit images.');
      p^ := clr;
  end; 

  function GetSurfacePixel(surface: PSDL_Surface; x, y: Longint) :Color;
  var
    pixel, pixels: PUint32;
    offset: Longword;
  {$IFDEF FPC}
    pixelAddress: PUint32;
  {$ELSE}
    pixelAddress: Longword;
  {$ENDIF}
  begin    
    //Convert the pixels to 32 bit
    pixels := surface^.pixels;

    //Get the requested pixel
    offset := (( y * surface^.w ) + x) * surface^.format^.BytesPerPixel;
    {$IFDEF FPC}
      pixelAddress := pixels + (offset div 4);
      pixel := PUint32(pixelAddress);
    {$ELSE}
      pixelAddress := Longword(pixels) + offset;
      pixel := Ptr(pixelAddress);
    {$ENDIF}

    {$IF SDL_BYTEORDER = SDL_BIG_ENDIAN }
    case surface^.format^.BytesPerPixel of
      1: result := pixel^ and $000000ff;
      2: result := pixel^ and $0000ffff;
      3: result := pixel^ and $00ffffff;
      4: result := pixel^;
    else
      RaiseException('Unsuported bit format...');
      exit;
    end;
    {$ELSE}
    case surface^.format^.BytesPerPixel of
      1: result := pixel^ and $ff000000;
      2: result := pixel^ and $ffff0000;
      3: result := pixel^ and $ffffff00;
      4: result := pixel^;
    end;
    {$IFEND}
  end;

  procedure ReplaceColors(surf : PSDL_Surface; originalColor, newColor : Color; width, height : LongInt);
  var
    x, y : LongInt;
  begin
    for x := 0 to width - 1  do 
    begin
      for y := 0 to height - 1 do 
      begin
        if GetSurfacePixel(surf, x, y) = originalColor then
          PutSurfacePixel(surf, newColor, x, y);
      end;
    end;
  end;

  procedure CopyOnto(src, dest: PSDL_Surface);
  var
    x, y : LongInt;
  begin
    for x := 0 to src^.w - 1  do 
    begin
      for y := 0 to src^.h - 1 do 
      begin
          PutSurfacePixel(dest, GetSurfacePixel(src, x, y), x, y);
      end;
    end;
  end;

  function DoLoadBitmapProcedure(filename: String; transparent: Boolean; transparentColor: Color): Bitmap;
  var
    loadedImage: PSDL_Surface;
    //offset : Rectangle;
    //lTransparentSurface : PSDL_Surface;
    lColorToSetTo : Color = $00000000;
    optimizeSizedImage : PSDL_Surface;
    dRect: SDL_Rect;
  begin
    result := nil; //start at nil to exit cleanly on error
    
    //Load the image
    loadedImage := IMG_Load(PChar(filename));

    optimizeSizedImage := SDL_CreateRGBSurface(0,PowerOfTwo(loadedImage^.w),
                                          PowerOfTwo(loadedImage^.h),
                                          32,
                                          $000000FF, //loadedImage^.format^.Rmask,
                                          $0000FF00, //loadedImage^.format^.Gmask,
                                          $00FF0000, //loadedImage^.format^.Bmask,
                                          $FF000000 //loadedImage^.format^.Amask
                                           );
    //optimizeSizedImage := IMG_Load(PChar(filename));
    dRect.x := 0;               dRect.y := 0;
    dRect.w := loadedImage^.w;  dRect.h := loadedImage^.h;
    ToRGBA(loadedImage);

    CopyOnto(loadedImage, optimizeSizedImage);

    //SDL_UpperBlit(loadedImage, nil, optimizeSizedImage, @dRect);
    //SDL_BlitSurface(loadedImage, nil, optimizeSizedImage, @dRect);
    SDL_FreeSurface(loadedImage);

    CheckAssigned('OpenGL ImagesDriver - Error loading image: ' + filename + ': ' + SDL_GetError(), loadedImage);

    // Image loaded, so create SwinGame bitmap    
    new(result);
    result^.width              := dRect.w;
    result^.height             := dRect.h;   
    result^.textureWidthRatio  := result^.width / optimizeSizedImage^.w;
    result^.textureHeightRatio := result^.height / optimizeSizedImage^.h;

     
    //Determine pixel level collision data
    if transparent then
    begin
      //offset.x := 0;
      //offset.y := 0;
      //offset.width := result^.width;
      //offset.height := result^.height;
      ReplaceColors(optimizeSizedImage, transparentColor, lColorToSetTo, result^.width, result^.height);

      result^.surface := CreateGLTextureFromSurface(optimizeSizedImage);
    end else begin    
      SetNonAlphaPixelsProcedure(result);
    end;

    // Free the loaded image; if its not the result's surface
    result^.surface := CreateGLTextureFromSurface(optimizeSizedImage);
    SDL_FreeSurface(optimizeSizedImage);
  end; 
    
  procedure FreeSurfaceProcedure(bmp : Bitmap);
  begin
    if bmp = screen then exit;
    if (Assigned(bmp) and Assigned(bmp^.surface)) then
    begin
      Dispose(PTexture(bmp^.surface));
      bmp^.surface := nil;
    end;
  end; 
  
  procedure MakeOpaqueProcedure(bmp : Bitmap);
  begin   
    exit;
  end;

  procedure SetOpacityProcedure(bmp : Bitmap; pct : Single);
  begin   
    exit;
  end;

  procedure MakeTransparentProcedure(bmp : Bitmap);
  begin   
    exit;
  end;

  procedure RotateScaleSurfaceProcedure(resultBmp, src : Bitmap; deg, scale : Single; smooth : LongInt);
  begin   
    exit;
  end;

  function SameBitmapProcedure(const bitmap1,bitmap2 : Bitmap) : Boolean;
  begin
   result := false;
  end;

  function GetCoords(bmpSize : Single; srcRectSize : Single) : Single;
  begin
    result := 0;
    if (bmpSize = 0) or (srcRectSize = 0) then
      exit
    else
      result := srcRectSize / bmpSize;
  end;
  
  procedure BlitSurfaceProcedure(srcBmp, destBmp : Bitmap; srcRect, destRect : RectPtr); 
  var
    //lTexture : GLuint;
    // textureCoord : Array[0..3] of Point2D;
    // vertices : Array[0..3] of Point2D;
    lRatioX, lRatioY, lRatioW, lRatioH, lTexWidth, lTexHeight : Single;
  begin
    
    if ((srcRect = nil) and (srcBmp^.textureWidthRatio <> 0) and ( srcBmp^.textureHeightRatio <> 0)) then //check for /0 s
    begin
      lRatioX := 0;
      lRatioY := 0;
      lRatioW := srcBmp^.textureWidthRatio;
      lRatioH := srcBmp^.textureHeightRatio;
    end else begin
      lTexWidth  := srcBmp^.width / srcBmp^.textureWidthRatio;
      lTexHeight := srcBmp^.height / srcBmp^.textureHeightRatio;
      
      lRatioX := GetCoords(lTexWidth, srcRect^.x);
      lRatioY := GetCoords(lTexHeight, srcRect^.y);
      
      lRatioW := lRatioX + GetCoords(lTexWidth, srcRect^.width);
      lRatioH := lRatioY + GetCoords(lTexHeight, srcRect^.height);
    end;
    
    //reset color
    glColor4f(1,1,1,1);
    //glLoadIdentity();
    RenderTexture(Cardinal(srcBmp^.Surface^), lRatioX, lRatioY, lRatioW, lRatioH, destRect);   
  end;
  
  procedure ClearSurfaceProcedure(dest : Bitmap; toColor : Color); 
  var
    r,g,b,a : Byte;
  begin   
    if dest <> Screen then
    begin
      
    end
    else
    begin
      glBindTexture(GL_TEXTURE_2D, 0);
      GraphicsDriver.ColorComponents(toColor,r,g,b,a);
      glClearColor ( r/255,g/255,b/255,a/255 );
      glClear ( GL_COLOR_BUFFER_BIT );
    end;

  end;
  
  procedure OptimiseBitmapProcedure(surface : Bitmap); 
  begin   
    exit;
  end;
  
  procedure SaveBitmapProcedure(src : Bitmap; filepath : String);
  begin   
    exit;
  end;
    
  procedure LoadOpenGLImagesDriver();
  begin
    ImagesDriver.InitBitmapColors   := @InitBitmapColorsProcedure;
    ImagesDriver.SurfaceExists      := @SurfaceExistsProcedure;
    ImagesDriver.CreateBitmap       := @CreateBitmapProcedure;
    ImagesDriver.DoLoadBitmap       := @DoLoadBitmapProcedure;
    ImagesDriver.FreeSurface        := @FreeSurfaceProcedure;
    ImagesDriver.MakeOpaque         := @MakeOpaqueProcedure;
    ImagesDriver.SetOpacity         := @SetOpacityProcedure;
    ImagesDriver.SameBitmap         := @SameBitmapProcedure;
    ImagesDriver.BlitSurface        := @BlitSurfaceProcedure;
    ImagesDriver.MakeTransparent    := @MakeTransparentProcedure;
    ImagesDriver.RotateScaleSurface := @RotateScaleSurfaceProcedure;
    ImagesDriver.ClearSurface       := @ClearSurfaceProcedure;
    ImagesDriver.OptimiseBitmap     := @OptimiseBitmapProcedure;
    ImagesDriver.SetNonAlphaPixels  := @SetNonAlphaPixelsProcedure;
  end;
end.