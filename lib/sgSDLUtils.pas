unit sgSDLUtils;

interface
	uses {$IFDEF SWINGAME_SDL13}sdl13{$ELSE}sdl{$ENDIF}, sgTypes;


procedure PutSurfacePixel(surf : PSDL_Surface; clr: Color; x, y: Longint);

function GetSurfacePixel(surface: PSDL_Surface; x, y: Longint): Color;

procedure SetNonAlphaPixels(bmp : Bitmap; surface: PSDL_Surface); 



implementation
	uses sgShared;

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

	procedure SetNonAlphaPixels(bmp : Bitmap; surface: PSDL_Surface); 
	var
		r, c: Longint;
		hasAlpha: Boolean;
	begin
		if not ( Assigned(bmp) and Assigned(surface) ) then exit;

		SetLength(bmp^.nonTransparentPixels, bmp^.width, bmp^.height);
		hasAlpha := surface^.format^.BytesPerPixel = 4;

		for c := 0 to bmp^.width - 1 do
		begin
		  for r := 0 to bmp^.height - 1 do
		  begin
		    bmp^.nonTransparentPixels[c, r] := (not hasAlpha) or ((GetSurfacePixel(surface, c, r) and SDL_Swap32($000000FF)) > 0);
		  end;
		end;
	end;
end.