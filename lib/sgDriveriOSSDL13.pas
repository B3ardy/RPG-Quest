unit sgDriveriOSSDL13;
//=============================================================================
// sgDriveriOSSDL.pas
//=============================================================================
//
// The iOS driver is responsible for controling iOS functions 
// between SDL 1.3 and SwinGame.
// Notes:

//=============================================================================

interface 
	uses SDL13, sgTypes, sgShared, sgGraphics, sgDriverGraphicsOpenGL;
	procedure LoadSDL13iOSDriver();
	
	//iphone max g force.
	const MAX_G  = 32767;	
	
implementation
	uses sgDriveriOS;

  {$IFDEF IOS}
  var
  	accelerometer :PSDL_Joystick;
  {$ENDIF}
  
	procedure InitProcedure();
	begin
		{$IFDEF IOS}
			if (SDL_InitSubSystem(SDL_INIT_JOYSTICK) = -1) then 
			begin
				RaiseWarning('Error Initialising Joystick. '+ SDL_GetError());	exit;
			end;

			if (SDL_NumJoySticks() > 0) then 
			begin
					// assume you are using iOS and as of 2012 it only has 1.
					accelerometer := SDL_JoystickOpen(0);
					if (accelerometer = nil) then 
					begin
						RaiseWarning('Could not open accelerometer'+ SDL_GetError()); exit;
					end;
			end

			else
				RaiseWarning('No accelerometer detected');	
		{$ENDIF}
		exit;	
	end;

	function HandlAxisMotionEventProcedure(): AccelerometerMotion; 
	var
		accel : AccelerometerMotion;
	begin
		accel.xAxis := 0;
		accel.yAxis := 0;
		accel.zAxis := 0;
		{$IFDEF IOS}
			if (accelerometer = nil) then exit;
			accel.xAxis := SDL_JoystickGetAxis(accelerometer,0);
			accel.yAxis := SDL_JoystickGetAxis(accelerometer,1);
			accel.zAxis := SDL_JoystickGetAxis(accelerometer,2);
		{$ENDIF}
		result := accel;
	end;

	function AxisToGProcedure(value : LongInt) : Single; 
	begin
		result := value / MAX_G;
	end;

	function SDLFingerToFinger(sdlFinger : PSDL_Finger; touchState : PSDL_Touch ): Finger;

	begin

		if not assigned(sdlFinger) then exit;
		

			
		result.id               := sdlFinger^.id;
	  result.position.x       := (sdlFinger^.x / touchState^.xres) * ScreenWidth();
	  result.position.y       := (sdlFinger^.y / touchState^.yres) * ScreenHeight();
	  result.positionDelta.x  := (sdlFinger^.xdelta / touchState^.xres) * ScreenWidth();
	  result.positionDelta.y  := (sdlFinger^.ydelta / touchState^.yres) * ScreenHeight();
	  result.lastPosition.x		:= (sdlFinger^.last_x / touchState^.xres) * ScreenWidth();
	  result.lastPosition.y 	:= (sdlFinger^.last_y / touchState^.yres) * ScreenHeight();
	  result.pressure 				:= sdlFinger^.pressure;
	  result.lastPressure 		:= sdlFinger^.last_pressure;
	  result.down 						:= sdlFinger^.down = SDL_TRUE;
	end;

	function ProcessTouchEventProcedure(touchID : int64): FingerArray; 
	var
	  touch : PSDL_Touch;
	  numberOfFingers, count : LongInt;
	  sdlFingerArray : PPSDL_Finger;
	begin
		touch := SDL_GetTouch(touchID);
		if (touch = nil) then exit;
		sdlFingerArray := touch^.fingers;
		numberOfFingers := touch^.num_fingers;

		SetLength(result, numberOfFingers);

		for count := 0 to numberOfFingers - 1 do
		begin
			result[count] := SDLFingerToFinger((sdlFingerArray + count)^, touch);
		end;
	end;

	procedure ShowKeyboardProcedure();
	begin
		{$IFDEF IOS}
		SDL_iPhoneKeyboardShow(POpenGLWindow(_screen)^.window);
		{$ENDIF}
	end;

	procedure HideKeyboardProcedure();
	begin
		{$IFDEF IOS}
		SDL_iPhoneKeyboardHide(POpenGLWindow(_screen)^.window)
		{$ENDIF}
	end;
	
	procedure ToggleKeyboardProcedure();
	begin
		{$IFDEF IOS}
		SDL_iPhoneKeyboardToggle(POpenGLWindow(_screen)^.window)
		{$ENDIF}
	end;
	
	function IsShownKeyboardProcedure():Boolean;
	begin
		result := false;
		{$IFDEF IOS}
		if( SDL_iPhoneKeyboardIsShown(POpenGLWindow(_screen)^.window) = SDL_TRUE) then
		begin
			result := true;
		end;
		{$ENDIF}
	end;
	
	procedure LoadSDL13iOSDriver();
	begin
			iOSDriver.ShowKeyboard						:= @ShowKeyboardProcedure;
			iOSDriver.HideKeyboard						:= @HideKeyboardProcedure;
			iOSDriver.ToggleKeyboard					:= @ToggleKeyboardProcedure;
			iOSDriver.IsShownKeyboard					:= @IsShownKeyboardProcedure;
			iOSDriver.Init										:= @InitProcedure;
			iOSDriver.ProcessAxisMotionEvent	:= @HandlAxisMotionEventProcedure;
			iOSDriver.ProcessTouchEvent				:= @ProcessTouchEventProcedure;
			iOSDriver.AxisToG									:= @AxisToGProcedure;
	end;
end.