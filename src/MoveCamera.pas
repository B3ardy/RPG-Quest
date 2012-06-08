unit MoveCamera;

interface

uses SwinGame, sgTypes, TypeDec;//, PlayerControl;

procedure MoveCam(var topX, topY : Integer; map0X, map0Y: integer; var player : playerData; const mapCells : mapCellArray);

implementation

procedure MoveCam(var topX, topY : Integer; map0X, map0Y: integer; var player : playerData; const mapCells : mapCellArray);
begin
	{*******************************************
	 ************MOVE CAMERA CODE***************
	 *******************************************}
	 //USING WASD
	if (KeyDown(vk_a) and KeyDown(vk_w)) //<^
	and ((CameraX() > map0X) and (CameraY() > map0Y)) then
	begin
		//MoveCameraBy(-SQUARE_SIZE ,-SQUARE_SIZE );
		MoveCameraBy(-1 ,-1 );
		
		topX -= 1;
		topY -= 1;
		
		//Delay(25);
		
	end else if (KeyDown(vk_d) and KeyDown(vk_w))  //>^
	and ((CameraX() < (map0X + (SQUARE_SIZE * (MAP_SIZE div 2 + 8) - ScreenWidth()))) 
	and (CameraY() > map0Y)) 
	and (CameraX() < (MAP_SIZE * SQUARE_SIZE - ScreenWidth())) then
	begin
		//MoveCameraBy(+SQUARE_SIZE ,-SQUARE_SIZE );
		MoveCameraBy(+1 ,-1);
		
		topX += 1;
		topY -= 1;
		
		//Delay(25);
		
	end else if (KeyDown(vk_d) and KeyDown(vk_s))  // >V
	and ((CameraX()  < (map0X + (SQUARE_SIZE * (MAP_SIZE div 2 + 8) - ScreenWidth()))) 
	and (CameraY() < (map0Y + (SQUARE_SIZE * (MAP_SIZE div 2 + 2) - ScreenHeight())))) 
	and (CameraY() < (MAP_SIZE * SQUARE_SIZE - ScreenHeight())) 
	and (CameraX() < (MAP_SIZE * SQUARE_SIZE - ScreenWidth())) then
	begin
		//MoveCameraBy(+SQUARE_SIZE ,+SQUARE_SIZE );
		MoveCameraBy(+1 ,+1);
		
		topX += 1;
		topY += 1;
		
		//Delay(25);
		
	end else if (KeyDown(vk_a) and KeyDown(vk_s))  //<V
	and ((CameraX() > map0X) 
	and (CameraY() < (map0Y + (SQUARE_SIZE * (MAP_SIZE div 2 + 2) - ScreenHeight())))) 
	and (CameraY() < (MAP_SIZE * SQUARE_SIZE - ScreenHeight())) then
	begin
		//MoveCameraBy(-SQUARE_SIZE ,+SQUARE_SIZE );
		MoveCameraBy(-1 ,+1);
		
		topX -= 1;
		topY += 1;
		
		//Delay(25);
		
	end else if KeyDown(vk_w) and (CameraY() > map0Y) then //^
	begin
		//MoveCameraBy(0 ,-SQUARE_SIZE );
		MoveCameraBy(0 ,-1);
		
		topY -= 1;
		
		//Delay(25);
		
	end else if KeyDown(vk_s) //V
	and (CameraY() < (map0Y + (SQUARE_SIZE * (MAP_SIZE div 2 + 2) - ScreenHeight()))) 
	and (CameraY() < (MAP_SIZE * SQUARE_SIZE - ScreenHeight())) then 
	begin
		//MoveCameraBy(0 ,+SQUARE_SIZE );
		MoveCameraBy(0 ,+1);
		
		topY += 1;
		
		//Delay(25);
		
	end else if KeyDown(vk_a) and (CameraX() > map0X) then //<
	begin
		//MoveCameraBy(-SQUARE_SIZE ,0 );
		MoveCameraBy(-1 ,0);
		
		topX -= 1;
		
		//Delay(25);
		
	end else if KeyDown(vk_d) //>
	and (CameraX() < (map0X + (SQUARE_SIZE * (MAP_SIZE div 2 + 8) - ScreenWidth())))
	and (CameraX() < (MAP_SIZE * SQUARE_SIZE - ScreenWidth())) then 
	begin
		//MoveCameraBy(+SQUARE_SIZE ,0 );
		MoveCameraBy(+1 ,0);
		
		topX += 1;
		
		//Delay(25);
	end;
	WriteLn(topX, ', ', topY, '. ', player.xLocation, ', ', player.yLocation);
end;

end.