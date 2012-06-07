program RPGQuest;
uses SwinGame, sgTypes, DrawWorld, TypeDec, GenerateWorld, MoveCamera, PlayerControl;

procedure LoadResources();
begin
	LoadFontNamed('arial', 'arial.ttf', 10);
	LoadBitmapNamed('cells', 'map.png');
	LoadBitmapNamed('opening', 'opening.png');
	LoadBitmapNamed('player', 'player.png');
end;

procedure initGame(var mapCells : mapCellArray; var player : playerData; var topX, topY : Integer);
begin
	SetBiome(mapCells);
	InitPlayer(player, mapCells);
	topX := player.xLocation - 10;
	topY := player.yLocation - 10;
	MoveCameraTo(topX * SQUARE_SIZE ,topY * SQUARE_SIZE);
end;

procedure Main();
var mapCells : mapCellArray;
	map0X, map0Y, topX, topY : Integer;
	player : playerData;
begin
	OpenGraphicsWindow('RPG Quest', 800, 800);//(SQUARE_SIZE * 20), (SQUARE_SIZE * 20));
	LoadDefaultColors();
	LoadResources();
	
	
	Randomize();
	
	initGame(mapCells, player, topX, topY);
	DrawMap(mapCells, player, topX, topY);
	map0X := 0;
	map0Y := 0;
	
	repeat
		ProcessEvents();
		movePlayer(topX, topY, map0X, map0Y, player, mapCells);
		if not deadZone(topX, topY, player) then
			MoveCam(topX, topY, map0X, map0Y, player, mapCells);
		if KeyTyped(vk_r) then //Generate new map
		begin
			initGame(mapCells, player, topX, topY);
		end;
		DrawMap(mapCells, player, topX, topY);
	until WindowCloseRequested();

end;

begin
	Main();
end.
