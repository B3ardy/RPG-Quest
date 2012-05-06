program RPGQuest;
uses SwinGame, sgTypes, DrawWorld, TypeDec, GenerateWorld, MoveCamera;
	
{procedure //DrawGrid();
var x, y : integer;
	yText : String;
begin
	for x := 0 to MAP_SIZE + 1 do
	begin
		Str(x, yText);
		DrawText(yText, ColorWhite,  'arial', (x * SQUARE_SIZE), 0);
		DrawLine(ColorGrey, (x * SQUARE_SIZE), 0, (x * SQUARE_SIZE), (SQUARE_SIZE * (MAP_SIZE + 2)));
	end;
		
	for y := 0 to MAP_SIZE + 1 do
	begin
		Str(y, yText);
		DrawText(yText, ColorWhite,  'arial', 0, (y * SQUARE_SIZE));
		DrawLine(ColorGrey, 0, (y * SQUARE_SIZE), (SQUARE_SIZE * (MAP_SIZE + 2)), (y * SQUARE_SIZE));
	end;
	DrawFramerate(SQUARE_SIZE, SQUARE_SIZE);
end;}

function Collision(const player : sprite);
begin
	
end;

procedure LoadResources();
begin
	LoadFontNamed('arial', 'arial.ttf', 10);
	LoadBitmapNamed('cells', 'map.png');
	LoadBitmapNamed('opening', 'opening.png');
	LoadBitmapNamed('player', 'player.png');
end;

procedure InitPlayer(var player : sprite);
begin
	player := reateSprite(BitmapNamed('player'));
	SpriteSetX(player ,40 );
    SpriteSetY(player ,40 );
end;

procedure Main();
var mapCells : mapCellArray;
	map0X, map0Y, topX, topY : Integer;
	player : sprite;
begin
	OpenGraphicsWindow('RPG Quest', 800, 800);//(SQUARE_SIZE * 20), (SQUARE_SIZE * 20));
	LoadDefaultColors();
	LoadResources();
	
	InitPlayer(player);
	
	Randomize();
	topX := 0;
	topY := 0;
	
	SetBiome(mapCells, player, -1, -1);
	DrawMap(mapCells, player, topX, topY);
	
	map0X := 0;
	map0Y := 0;
	
	repeat
		ProcessEvents();
		MoveCam(topX, topY, map0X, map0Y, player);
		if KeyTyped(vk_r) then //Generate new map
		begin
			SetBiome(mapCells, player, topX, topY);
		end;
		DrawMap(mapCells, player, topX, topY);
	until WindowCloseRequested();

end;

begin
	Main();
end.
