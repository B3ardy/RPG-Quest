unit MoveCamera;

interface

uses SwinGame, sgTypes, TypeDec;

procedure MoveCam(var topX, topY, map0X, map0Y: integer; player : sprite);

implementation

procedure MoveCam(var topX, topY, map0X, map0Y: integer; player : sprite);
begin
	{*******************************************
	 ************MOVE CAMERA CODE***************
	 *******************************************}
	 //USING WASD
	if (KeyDown(vk_a) and KeyDown(vk_w)) //<^
	and ((CameraX() > map0X) and (CameraY() > map0Y)) then
	begin
		MoveCameraBy(-SQUARE_SIZE ,-SQUARE_SIZE );
		SpriteSetX(player ,SpriteX(player) - SQUARE_SIZE );
		SpriteSetY(player ,Spritey(player) - SQUARE_SIZE );
		topX -= 1;
		topY -= 1;
		//DrawMap(mapCells, player);
		//Delay(50);
		
	end else if (KeyDown(vk_d) and KeyDown(vk_w))  //>^
	and ((CameraX() < (map0X + (SQUARE_SIZE * (MAP_SIZE div 2 + 2) - ScreenWidth()))) and (CameraY() > map0Y)) then
	begin
		MoveCameraBy(+SQUARE_SIZE ,-SQUARE_SIZE );
		SpriteSetX(player ,SpriteX(player) + SQUARE_SIZE );
		SpriteSetY(player ,Spritey(player) - SQUARE_SIZE );
		topX += 1;
		topY -= 1;
		//DrawMap(mapCells, player);
		//Delay(50);
		
	end else if (KeyDown(vk_d) and KeyDown(vk_s))  // >V
	and ((CameraX()  < (map0X + (SQUARE_SIZE * (MAP_SIZE div 2 + 2) - ScreenWidth()))) 
	and (CameraY() < (map0Y + (SQUARE_SIZE * (MAP_SIZE div 2 + 2) - ScreenHeight())))) then
	begin
		MoveCameraBy(+SQUARE_SIZE ,+SQUARE_SIZE );
		SpriteSetX(player ,SpriteX(player) + SQUARE_SIZE );
		SpriteSetY(player ,Spritey(player) + SQUARE_SIZE );
		topX += 1;
		topY += 1;
		//DrawMap(mapCells, player);
		//Delay(50);
		
	end else if (KeyDown(vk_a) and KeyDown(vk_s))  //<V
	and ((CameraX() > map0X) and 
	(CameraY() < (map0Y + (SQUARE_SIZE * (MAP_SIZE div 2 + 2) - ScreenHeight())))) then
	begin
		MoveCameraBy(-SQUARE_SIZE ,+SQUARE_SIZE );
		SpriteSetX(player ,SpriteX(player) - SQUARE_SIZE );
		SpriteSetY(player ,Spritey(player) + SQUARE_SIZE );
		topX -= 1;
		topY += 1;
		//DrawMap(mapCells, player);
		//Delay(50);
		
	end else if KeyDown(vk_w) and (CameraY() > map0Y) then //^
	begin
		MoveCameraBy(0 ,-SQUARE_SIZE );
		SpriteSetY(player ,Spritey(player) - SQUARE_SIZE );
		topY -= 1;
		//DrawMap(mapCells, player);
		//Delay(50);
		
	end else if KeyDown(vk_s) //V
	and (CameraY() < (map0Y + (SQUARE_SIZE * (MAP_SIZE div 2 + 2) - ScreenHeight()))) then
	begin
		MoveCameraBy(0 ,+SQUARE_SIZE );
		SpriteSetY(player ,Spritey(player) + SQUARE_SIZE );
		topY += 1;
		//DrawMap(mapCells, player);
		//Delay(50);
		
	end else if KeyDown(vk_a) and (CameraX() > map0X) then //<
	begin
		MoveCameraBy(-SQUARE_SIZE ,0 );
		SpriteSetX(player ,SpriteX(player) - SQUARE_SIZE );
		topX -= 1;
		//DrawMap(mapCells, player);
		//Delay(50);
		
	end else if KeyDown(vk_d) //>
	and (CameraX() < (map0X + (SQUARE_SIZE * (MAP_SIZE div 2 + 2) - ScreenWidth()))) then
	begin
		MoveCameraBy(+SQUARE_SIZE ,0 );
		SpriteSetX(player ,SpriteX(player) + SQUARE_SIZE );
		topX += 1;
		//DrawMap(mapCells, player);
		//Delay(50);
		//END MOVE CAMERA
	{*******************************************
	 ************CHANGE VIEW CODE***************
	 *******************************************}
	end else if KeyDown(vk_z) then //OUTSIDE
	begin
		map0X := 0;
		map0Y := 0;
		MoveCameraTo(map0X ,map0Y );
		topX := map0X;
		topY := map0Y;
		//DrawMap(mapCells, player);
		
	//INTERIORS
	end else if KeyDown(vk_x) then //BUILDINGS
	begin
		map0X := SQUARE_SIZE * (MAP_SIZE div 2 + 2);
		map0Y := 0;
		MoveCameraTo(map0X ,map0Y);
		topX := map0X div SQUARE_SIZE;
		topY := map0Y;
		//DrawMap(mapCells, player);
		
	end else if KeyDown(vk_c) then //CAVES
	begin
		map0X := 0;
		map0Y := SQUARE_SIZE * (MAP_SIZE div 2 + 2);
		MoveCameraTo(map0X ,map0Y );
		topX := map0X;
		topY := map0Y div SQUARE_SIZE;
		//DrawMap(mapCells, player);
		
	end else if KeyDown(vk_v) then //FORESTS
	begin
		map0X := SQUARE_SIZE * (MAP_SIZE div 2 + 2);
		map0Y := SQUARE_SIZE * (MAP_SIZE div 2 + 2);
		MoveCameraTo(map0X ,map0Y );
		topX := map0X div SQUARE_SIZE;
		topY := map0Y div SQUARE_SIZE;
		//DrawMap(mapCells, player);
	end;
	
		//END CHANGE VIEW
end;

end.