unit PlayerControl;

interface

uses SwinGame, sgTypes, TypeDec;

procedure InitPlayer(var player : playerData; const mapCells : mapCellArray);
function Collision(const player : playerData; dir : char; const mapCells : mapCellArray): boolean;
procedure Doors(var player : playerData; const currentCell : mapCell; var map0X, map0Y, topX, topY : Integer);
function deadZone(topX, topY : Integer; const player : playerData):boolean;
procedure movePlayer(var topX, topY, map0X, map0Y : integer; var player : playerData; const mapCells : mapCellArray);

implementation

procedure InitPlayer(var player : playerData; const mapCells : mapCellArray);
var spriteLocation : point2d;
begin
	player.graphic := CreateSprite(BitmapNamed('player'));
	player.health := 100;
	player.level := 1;
	player.xp := 0;
	repeat
		player.xLocation := (random(MAP_SIZE div 2) + 1);// * 40;
		player.yLocation := (random(MAP_SIZE div 2) + 1);// * 40;
	until mapCells[player.xLocation, player.yLocation].cType = Terrain;
	spriteLocation.x := player.xLocation * 40;
	spriteLocation.y := player.yLocation * 40;
	SpriteSetPosition(player.graphic, spriteLocation);
end;

function Collision(const player : playerData; dir : char; const mapCells : mapCellArray): boolean;
begin
	if dir = 'w' then
	begin
		if mapCells[player.xLocation, player.yLocation - 1].cType = Barrier then
		begin
			result := true;
			exit;
		end;
		result := false;
		exit;
	end else if dir = 'a' then
	begin
		if mapCells[player.xLocation - 1, player.yLocation].cType = Barrier then
		begin
			result := true;
			exit;
		end;
		result := false;
		exit;
	end else if dir = 's' then
	begin
		if mapCells[player.xLocation, player.yLocation + 1].cType = Barrier then
		begin
			result := true;
			exit;
		end;
		result := false;
		exit;
	end else if dir = 'd' then
	begin
		if mapCells[player.xLocation + 1, player.yLocation].cType = Barrier then
		begin
			result := true;
			exit;
		end;
		result := false;
		exit;
	end;
end;

procedure Doors(var player : playerData; const currentCell : mapCell; var map0X, map0Y, topX, topY : Integer);
begin
	if currentCell.dType = Grass then
	begin
		if currentCell.biome = CaveBiome then
		begin
			player.yLocation -= MAP_SIZE div 2;
			SpriteSety(player.graphic, player.yLocation * SQUARE_SIZE);
			map0X := 0;
			map0Y := 0;
			topX := player.xLocation - 10;
			topY := player.yLocation - 10;
		end else if currentCell.biome = ForestBiome then
		begin
			player.yLocation -= MAP_SIZE div 2;
			player.xLocation -= MAP_SIZE div 2;
			SpriteSetX(player.graphic, player.xLocation * SQUARE_SIZE);
			SpriteSetY(player.graphic, player.yLocation * SQUARE_SIZE);
			map0X := 0;
			map0Y := 0;
			topX := player.xLocation - 10;
			topY := player.yLocation - 10;
		end else if currentCell.biome = BuildingBiome then
		begin
			player.xLocation -= (MAP_SIZE div 2);
			SpriteSetX(player.graphic, player.xLocation * SQUARE_SIZE);
			map0X := 0;
			map0Y := 0;
			topX := player.xLocation - 10;
			topY := player.yLocation - 10;
		end;
	end else if currentCell.dType = Cave then
	begin
		player.yLocation += MAP_SIZE div 2;
		SpriteSety(player.graphic, player.yLocation * SQUARE_SIZE);
		map0X := 0;
		map0Y := SQUARE_SIZE * ((MAP_SIZE div 2) + 2);
		topX := player.xLocation - 10;
		topY := player.yLocation - 10;
	end else if currentCell.dType = Forest then
	begin
		player.yLocation += MAP_SIZE div 2;
		player.xLocation += MAP_SIZE div 2;
		SpriteSetX(player.graphic, player.xLocation * SQUARE_SIZE);
		SpriteSetY(player.graphic, player.yLocation * SQUARE_SIZE);
		map0X := SQUARE_SIZE * ((MAP_SIZE div 2) + 2);
		map0Y := SQUARE_SIZE * ((MAP_SIZE div 2) + 2);
		topX := player.xLocation - 10;
		topY := player.yLocation - 10;
	end else if currentCell.dType = Building then
	begin
		player.xLocation += (MAP_SIZE div 2);
		SpriteSetX(player.graphic, player.xLocation * SQUARE_SIZE);
		map0X := SQUARE_SIZE * ((MAP_SIZE div 2) + 2);
		map0Y := 0;
		topX := player.xLocation - 10;
		topY := player.yLocation - 10;
	end;
	MoveCameraTo(topX * SQUARE_SIZE, topY * SQUARE_SIZE);
end;

function deadZone(topX, topY : Integer; const player : playerData):boolean;
begin
	if (player.xLocation <= topX + 5) or (player.xLocation >= topX + 15) 
	or (player.yLocation <= topY + 5) or (player.yLocation >= topY + 15) then
	begin
		result := false;
	end else begin
		result := true;
	end;
end;

procedure movePlayer(var topX, topY, map0X, map0Y : integer; var player : playerData; const mapCells : mapCellArray);
begin
	if (KeyDown(vk_a) and KeyDown(vk_w)) //<^
	and ((player.xLocation > map0X) and (player.yLocation > map0Y))
	and ((not Collision(player, 'a', mapCells)) and (not Collision(player, 'w', mapCells))) then
	begin
		player.xLocation -= 1;
		player.yLocation -= 1;
	
		SpriteSetX(player.graphic ,SpriteX(player.graphic) - SQUARE_SIZE );
		SpriteSetY(player.graphic ,Spritey(player.graphic) - SQUARE_SIZE );
		
		if mapCells[player.xLocation, player.yLocation].cType = Door then
			Doors(player, mapCells[player.xLocation, player.yLocation], map0X, map0Y, topX, topY);
		
	end else if (KeyDown(vk_d) and KeyDown(vk_w)) //>^
	and ((player.xLocation < (map0X + (SQUARE_SIZE * (MAP_SIZE div 2 + 2))))
	and (player.yLocation > map0Y))
	and ((not Collision(player, 'd', mapCells)) and (not Collision(player, 'w', mapCells))) then
	begin
		player.xLocation += 1;
		player.yLocation -= 1;
	
		SpriteSetX(player.graphic ,SpriteX(player.graphic) + SQUARE_SIZE );
		SpriteSetY(player.graphic ,Spritey(player.graphic) - SQUARE_SIZE );
		
		if mapCells[player.xLocation, player.yLocation].cType = Door then
			Doors(player, mapCells[player.xLocation, player.yLocation], map0X, map0Y, topX, topY);
		
	end else if (KeyDown(vk_d) and KeyDown(vk_s)) // >V
	and ((player.xLocation < (map0X + (SQUARE_SIZE * (MAP_SIZE div 2 + 2))))
	and (player.yLocation < map0Y + (SQUARE_SIZE * (MAP_SIZE div 2 + 2))))
	and ((not Collision(player, 'd', mapCells)) and (not Collision(player, 's', mapCells))) then
	begin
		player.xLocation += 1;
		player.yLocation += 1;
	
		SpriteSetX(player.graphic ,SpriteX(player.graphic) + SQUARE_SIZE );
		SpriteSetY(player.graphic ,Spritey(player.graphic) + SQUARE_SIZE );
		
		if mapCells[player.xLocation, player.yLocation].cType = Door then
			Doors(player, mapCells[player.xLocation, player.yLocation], map0X, map0Y, topX, topY);
		
	end else if (KeyDown(vk_a) and KeyDown(vk_s)) //<V 
	and ((player.yLocation < (map0Y + (SQUARE_SIZE * (MAP_SIZE div 2 + 2))))
	and (player.xLocation > map0X))
	and ((not Collision(player, 'a', mapCells)) and (not Collision(player, 's', mapCells))) then
	begin
		player.xLocation -= 1;
		player.yLocation += 1;
	
		SpriteSetX(player.graphic ,SpriteX(player.graphic) - SQUARE_SIZE );
		SpriteSetY(player.graphic ,Spritey(player.graphic) + SQUARE_SIZE );
		
		if mapCells[player.xLocation, player.yLocation].cType = Door then
			Doors(player, mapCells[player.xLocation, player.yLocation], map0X, map0Y, topX, topY);
		
	end else if KeyDown(vk_w) //^
	and (player.yLocation > map0Y)
	and (not Collision(player, 'w', mapCells)) then 
	begin
		player.yLocation -= 1;
	
		SpriteSetY(player.graphic ,Spritey(player.graphic) - SQUARE_SIZE );
		
		if mapCells[player.xLocation, player.yLocation].cType = Door then
			Doors(player, mapCells[player.xLocation, player.yLocation], map0X, map0Y, topX, topY);
		
	end else if KeyDown(vk_s) //V
	and (player.yLocation < (map0Y + (SQUARE_SIZE * (MAP_SIZE div 2 + 2))))
	and (not Collision(player, 's', mapCells)) then 
	begin
		player.yLocation += 1;
	
		SpriteSetY(player.graphic ,Spritey(player.graphic) + SQUARE_SIZE );
		
		if mapCells[player.xLocation, player.yLocation].cType = Door then
			Doors(player, mapCells[player.xLocation, player.yLocation], map0X, map0Y, topX, topY);
		
	end else if KeyDown(vk_a) //<
	and (player.xLocation > map0X)
	and (not Collision(player, 'a', mapCells)) then 
	begin
		player.xLocation -= 1;
	
		SpriteSetX(player.graphic ,SpriteX(player.graphic) - SQUARE_SIZE );
		
		if mapCells[player.xLocation, player.yLocation].cType = Door then
			Doors(player, mapCells[player.xLocation, player.yLocation], map0X, map0Y, topX, topY);
		
	end else if KeyDown(vk_d) //>
	and (player.xLocation < (map0X + (SQUARE_SIZE * (MAP_SIZE div 2 + 2))))
	and (not Collision(player, 'd', mapCells)) then 
	begin
		player.xLocation += 1;
		
		SpriteSetX(player.graphic ,SpriteX(player.graphic) + SQUARE_SIZE );
		
		if mapCells[player.xLocation, player.yLocation].cType = Door then
			Doors(player, mapCells[player.xLocation, player.yLocation], map0X, map0Y, topX, topY);
	end;
end;

end.