program RPGQuest;
uses SwinGame, sgTypes, DrawWorld, TypeDec, GenerateWorld, MoveCamera, PlayerControl;

procedure LoadResources();
begin
	LoadFontNamed('arial', 'arial.ttf', 10);
	LoadBitmapNamed('cells', 'map.png');
	LoadBitmapNamed('opening', 'opening.png');
	LoadBitmapNamed('player', 'player.png');
end;

procedure initGame(var mapCells : mapCellArray; var player : playerData; var topX, topY, map0X, map0Y : Integer);
var i : Integer;
begin
	showGrid := false;
	showSideBar := true;
	showFrameRate := true;
	SetBiome(mapCells);
	InitPlayer(player, mapCells);
	for i := 10 downto 0 do
	begin
		if player.xLocation >= i then
		begin
			topX := player.xLocation - i;
			break;
		end;
	end;
	for i := 10 downto 0 do
	begin
		if player.yLocation >= i then
		begin
			topy := player.yLocation - i;
			break;
		end;
	end;
	map0X := 0;
	map0Y := 0;
	MoveCameraTo(topX * SQUARE_SIZE ,topY * SQUARE_SIZE);
end;

procedure Main();
var mapCells : mapCellArray;
	map0X, map0Y, topX, topY : Integer;
	player : playerData;
begin
	OpenGraphicsWindow('RPG Quest', 1050, 800);//(SQUARE_SIZE * 20), (SQUARE_SIZE * 20));
	LoadDefaultColors();
	LoadResources();
	
	
	Randomize();
	
	initGame(mapCells, player, topX, topY, map0X, map0Y);
	DrawMap(mapCells, player, topX, topY);
	map0X := 0;
	map0Y := 0;
	
	repeat
		ProcessEvents();
		movePlayer(topX, topY, map0X, map0Y, player, mapCells);
		if not InDeadZone(topX, topY, player) then
		begin
			if (player.xLocation > map0X div SQUARE_SIZE + 5) 
			and (player.YLocation > map0Y div SQUARE_SIZE + 5) then
			begin
				if (player.xLocation < ((map0X div SQUARE_SIZE) + (MAP_SIZE div 2))) 
				and (player.yLocation < ((map0Y div SQUARE_SIZE) + (MAP_SIZE div 2))) then
				begin
					MoveCam(topX, topY, map0X, map0Y, player, mapCells);
				end;
			end;
		end;
		if KeyTyped(vk_g) then
			showGrid := not showGrid;
		if KeyTyped(vk_m) then
			showSideBar := not showSideBar;
		if KeyTyped(vk_r) then //Generate new map
			initGame(mapCells, player, topX, topY, map0X, map0Y);
		
		DrawMap(mapCells, player, topX, topY);
	until WindowCloseRequested();

end;

begin
	Main();
end.
