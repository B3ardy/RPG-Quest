unit PlayerControl;

interface

uses SwinGame, sgTypes, TypeDec, MoveCamera;

procedure InitPlayer(var player : playerData; const mapCells : mapCellArray);
function Collision(const player : playerData; dir : char; const mapCells : mapCellArray): boolean;
procedure Doors(var player : playerData; const currentCell : mapCell; var map0X, map0Y, topX, topY : Integer);
function InDeadZone(topX, topY : Integer; const player : playerData):boolean;
procedure movePlayer(var topX, topY, map0X, map0Y : integer; var player : playerData; const mapCells : mapCellArray);

implementation

procedure InitPlayer(var player : playerData; const mapCells : mapCellArray);
var spriteLocation : point2d;
begin
	player.graphic := CreateSprite(BitmapNamed('player'));
	player.health := 80;
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
var i : Integer;
begin
	if currentCell.dType = Grass then
	begin
		if currentCell.biome = CaveBiome then
		begin
			player.yLocation -= MAP_SIZE div 2;
			SpriteSetY(player.graphic, player.yLocation * SQUARE_SIZE);
			map0X := 0;
			map0Y := 0;
			for i := 10 downto 0 do
			begin
				if player.yLocation >= i then
				begin
					topY := player.yLocation - i;
					break;
				end;
			end;
		end else if currentCell.biome = ForestBiome then
		begin
			player.yLocation -= MAP_SIZE div 2;
			player.xLocation -= MAP_SIZE div 2;
			SpriteSetX(player.graphic, player.xLocation * SQUARE_SIZE);
			SpriteSetY(player.graphic, player.yLocation * SQUARE_SIZE);
			map0X := 0;
			map0Y := 0;
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
					topY := player.yLocation - i;
					break;
				end;
			end;
		end else if currentCell.biome = BuildingBiome then
		begin
			player.xLocation -= (MAP_SIZE div 2);
			SpriteSetX(player.graphic, player.xLocation * SQUARE_SIZE);
			map0X := 0;
			map0Y := 0;
			for i := 10 downto 0 do
			begin
				if player.xLocation >= i then
				begin
					topX := player.xLocation - i;
					break;
				end;
			end;
		end;
	end else if currentCell.dType = Cave then
	begin
		player.yLocation += MAP_SIZE div 2;
		SpriteSety(player.graphic, player.yLocation * SQUARE_SIZE);
		map0X := 0;
		map0Y := SQUARE_SIZE * ((MAP_SIZE div 2) + 2);
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
	end;
	MoveCameraTo(topX * SQUARE_SIZE, topY * SQUARE_SIZE);
end;

function InDeadZone(topX, topY : Integer; const player : playerData):boolean;
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
var moved : boolean;
begin
	moved := false;
	if (KeyDown(vk_a) and KeyDown(vk_w)) //<^
	and ((not Collision(player, 'a', mapCells)) and (not Collision(player, 'w', mapCells))) then
	begin
		player.xLocation -= 1;
		player.yLocation -= 1;
	
		SpriteSetX(player.graphic ,SpriteX(player.graphic) - SQUARE_SIZE );
		SpriteSetY(player.graphic ,Spritey(player.graphic) - SQUARE_SIZE );
		
		if ((player.xLocation <= topX + 5) and (player.yLocation <= topY + 5)) 
		or ((player.xLocation >= topX + 15) and (player.yLocation >= topY + 15))
		or ((player.xLocation >= topX + 15) and (player.yLocation <= topY + 5)) 
		or ((player.xLocation <= topX + 5) and (player.yLocation >= topY + 15))then
		begin
			//MoveCam(topX, topY, map0X, map0Y, player, mapCells);
		end;
		Delay(25);
		moved := true;
		
	end else if (KeyDown(vk_d) and KeyDown(vk_w)) //>^
	and ((not Collision(player, 'd', mapCells)) and (not Collision(player, 'w', mapCells))) then
	begin
		player.xLocation += 1;
		player.yLocation -= 1;
	
		SpriteSetX(player.graphic ,SpriteX(player.graphic) + SQUARE_SIZE );
		SpriteSetY(player.graphic ,Spritey(player.graphic) - SQUARE_SIZE );
		
		if ((player.xLocation <= topX + 5) and (player.yLocation <= topY + 5)) 
		or ((player.xLocation >= topX + 15) and (player.yLocation >= topY + 15))
		or ((player.xLocation >= topX + 15) and (player.yLocation <= topY + 5)) 
		or ((player.xLocation <= topX + 5) and (player.yLocation >= topY + 15))then
		begin
			//MoveCam(topX, topY, map0X, map0Y, player, mapCells);
		end;
		Delay(25);
		moved := true;
		
	end else if (KeyDown(vk_d) and KeyDown(vk_s)) // >V
	and ((not Collision(player, 'd', mapCells)) and (not Collision(player, 's', mapCells))) then
	begin
		player.xLocation += 1;
		player.yLocation += 1;
	
		SpriteSetX(player.graphic ,SpriteX(player.graphic) + SQUARE_SIZE );
		SpriteSetY(player.graphic ,Spritey(player.graphic) + SQUARE_SIZE );
		
		if ((player.xLocation <= topX + 5) and (player.yLocation <= topY + 5)) 
		or ((player.xLocation >= topX + 15) and (player.yLocation >= topY + 15))
		or ((player.xLocation >= topX + 15) and (player.yLocation <= topY + 5)) 
		or ((player.xLocation <= topX + 5) and (player.yLocation >= topY + 15))then
		begin
			//MoveCam(topX, topY, map0X, map0Y, player, mapCells);
		end;
		Delay(25);
		moved := true;
		
	end else if (KeyDown(vk_a) and KeyDown(vk_s)) //<V 
	and ((not Collision(player, 'a', mapCells)) and (not Collision(player, 's', mapCells))) then
	begin
		player.xLocation -= 1;
		player.yLocation += 1;
	
		SpriteSetX(player.graphic ,SpriteX(player.graphic) - SQUARE_SIZE );
		SpriteSetY(player.graphic ,Spritey(player.graphic) + SQUARE_SIZE );
		
		if ((player.xLocation <= topX + 5) and (player.yLocation <= topY + 5)) 
		or ((player.xLocation >= topX + 15) and (player.yLocation >= topY + 15))
		or ((player.xLocation >= topX + 15) and (player.yLocation <= topY + 5)) 
		or ((player.xLocation <= topX + 5) and (player.yLocation >= topY + 15))then
		begin
			//MoveCam(topX, topY, map0X, map0Y, player, mapCells);
		end;
		Delay(25);
		Delay(25);
		moved := true;
		
	end else if KeyDown(vk_w) //^
	and (not Collision(player, 'w', mapCells)) then 
	begin
		player.yLocation -= 1;
	
		SpriteSetY(player.graphic ,Spritey(player.graphic) - SQUARE_SIZE );
		
		if (player.xLocation <= topX + 5) or (player.xLocation >= topX + 15) then
			MoveCam(topX, topY, map0X, map0Y, player, mapCells);
		Delay(25);
		Delay(25);
		moved := true;
		
	end else if KeyDown(vk_s) //V
	and (not Collision(player, 's', mapCells)) then 
	begin
		player.yLocation += 1;
	
		SpriteSetY(player.graphic ,Spritey(player.graphic) + SQUARE_SIZE );
		
		if (player.xLocation <= topX + 5) or (player.xLocation >= topX + 15) then
			MoveCam(topX, topY, map0X, map0Y, player, mapCells);
		Delay(25);
		moved := true;
		
	end else if KeyDown(vk_a) //<
	and (not Collision(player, 'a', mapCells)) then 
	begin
		player.xLocation -= 1;
	
		SpriteSetX(player.graphic ,SpriteX(player.graphic) - SQUARE_SIZE );
		
		if (player.yLocation <= topY + 5) or (player.yLocation >= topY + 15) then
			MoveCam(topX, topY, map0X, map0Y, player, mapCells);
		Delay(25);
		moved := true;
		
	end else if KeyDown(vk_d) //>
	and (not Collision(player, 'd', mapCells)) then 
	begin
		player.xLocation += 1;
		
		SpriteSetX(player.graphic ,SpriteX(player.graphic) + SQUARE_SIZE );
		
		if (player.yLocation <= topY + 5) or (player.yLocation >= topY + 15) then
			MoveCam(topX, topY, map0X, map0Y, player, mapCells);
		Delay(25);
		moved := true;
	end;
	if (mapCells[player.xLocation, player.yLocation].cType = Door) and moved then
			Doors(player, mapCells[player.xLocation, player.yLocation], map0X, map0Y, topX, topY);
end;

end.