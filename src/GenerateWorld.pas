unit GenerateWorld;

interface

uses SwinGame, sgTypes, TypeDec;

procedure SetBarrierType(var mCell, inCell : mapCell; barrierType : terrainType; biome : cellBiome);
procedure GenerateNature(var mapCells : mapCellArray);
procedure GenerateStructures(var mapCells : mapCellArray; x0, y0 : integer);
procedure GenerateInteriorDoors(var mCell : mapCell; tType : integer);
function AreaClear(const mapCells : mapCellArray; x0, y0 : integer) : Boolean;
procedure GenerateDoors(var mapCells : mapCellArray);
procedure SetBiome(var mapCells : mapCellArray{; player : sprite; topX, topY : integer});

implementation

procedure SetBarrierType(var mCell, inCell : mapCell; barrierType : terrainType; biome : cellBiome);
begin 							//Used for Generating Structures
	mCell.cType := Barrier;		//Sets the cell to be a barrier
	mCell.bType := barrierType; //Sets what type of structure it will be
	
	inCell.biome := cellBiome(biome);
	inCell.cType := Terrain;
end;

procedure GenerateNature(var mapCells : mapCellArray);
var x, y, n, i, inXoffset, inYoffset : integer;
	nType : terrainType;
	nBiome : cellBiome;
	nextGen : mapCellArray;
begin			//Generates caves and forests
	//Sets the offsets to place the interiors in the right biomes
	nextGen := mapCells;
	for x := 2 to MAP_SIZE div 2 - 2 do
	begin
		for y := 2 to MAP_SIZE div 2 - 2 do
		begin
			if (x <= MAP_SIZE div 4) and (y <= MAP_SIZE div 4) then
			begin
				inXoffset := MAP_SIZE div 8;
				inYoffset := MAP_SIZE div 2 + MAP_SIZE div 8;
				nType := Cave;
				nBiome := CaveBiome;
			end else if (x > MAP_SIZE div 4) and (y > MAP_SIZE div 4) then
			begin
				inXoffset := MAP_SIZE div 4 + MAP_SIZE div 8;
				inYoffset := MAP_SIZE div 4 + MAP_SIZE div 8;
				nType := Forest;
				nBiome := ForestBiome;
			end;
			if (mapCells[x, y].cType = Terrain)
			and (((x <= MAP_SIZE div 4) and (y <= MAP_SIZE div 4)) 
			or ((x > MAP_SIZE div 4) and (y > MAP_SIZE div 4))) then
			begin
				n := 0;
				if nextGen[(x - 1), (y - 1)].cType <> Terrain then n += 1;
				if nextGen[(x - 1), y].cType <> Terrain then n += 1;
				if nextGen[(x - 1), (y + 1)].cType <> Terrain then n += 1;
				if nextGen[x, (y - 1)].cType <> Terrain then n += 1;
				if nextGen[x, (y + 1)].cType <> Terrain then n += 1;
				if nextGen[(x + 1), (y - 1)].cType <> Terrain then n += 1;
				if nextGen[(x + 1), y].cType <> Terrain then n += 1;
				if nextGen[(x + 1), (y + 1)].cType <> Terrain then n += 1;
				if (Random(42 - n * 5) = 0) and (n <> 0) then
				begin
					SetBarrierType(nextGen[x, y], nextGen[x + inXoffset, y + inYoffset], nType, nBiome);
				end;
			end;
		end;
	end;
	mapCells := nextGen;
end;

procedure GenerateStructures(var mapCells : mapCellArray; x0, y0 : integer);
var  x, y : integer;
begin
{	Randomize();
	mapCells[x0, y0].size := Random(3); //Size of the structure.
	
	if mapCells[x0, y0].dType <> Building then //Generates the caves and forests
	begin
		GenerateNature(mapCells, 5);
	end else if mapCells[x0, y0].dType = Building then //Generates the building.
	begin
		if mapCells[x0, y0].size = 0 then //small building 3X4
		begin
			for x := (x0 - 1) to (x0 + 1) do
			begin
				for y := (y0 - 3) to y0 do
				begin
					if (x = x0) and (y = y0) then continue; //Ignore the door cell
					SetBarrierType(mapCells[x, y], mapCells[(x + MAP_SIZE div 2), y], Building, BuildingBiome);
				end;
			end;
		end else if mapCells[x0, y0].size = 1 then //medium buildings 5X4
		begin
			for x := (x0 - 2) to (x0 + 2) do
			begin
				for y := (y0 - 3) to y0 do
				begin
					if (x = x0) and (y = y0) then continue; //Ignore the door cell
					SetBarrierType(mapCells[x, y], mapCells[(x + MAP_SIZE div 2), y], Building, BuildingBiome);
				end;
			end;
		end else begin //Large Buildings 7X5
			for x := (x0 - 3) to (x0 + 3) do
			begin
				for y := (y0 - 4) to y0 do
				begin
					if (x = x0) and (y = y0) then continue; //Ignore the door cell
					SetBarrierType(mapCells[x, y], mapCells[(x + MAP_SIZE div 2), y], Building, BuildingBiome);
				end;
			end;
		end;
	end;}
end;

procedure GenerateInteriorDoors(var mCell : mapCell; tType : integer);
begin
	mCell.biome := cellBiome(tType);
	mCell.cType := Door; 
	mCell.dType := Grass;
end;

function AreaClear(const mapCells : mapCellArray; x0, y0 : integer) : Boolean;
var x, y : integer; //Checks area so doors spawn away from eachother 
begin 				//so the accompanying buidlings will not overlap
	result := True; //Default is true
	for x := (x0 - 7) to (x0 + 7) do
	begin
		for y := (y0 - 7) to (y0 + 7) do
		begin
			if mapCells[x, y].cType = Door then //Checking own cell is not a problem 
			begin								//because that cell isn't set yet.
				result := False;				//If it finds a door then area not clear
				exit;							//function can then end
			end;
		end;
	end;
end;

procedure GenerateDoors(var mapCells : mapCellArray); //Generates doors on to the game world
var x, y, seed, x0, y0, inXoffset, inYoffset : integer;
	nType : terrainType;
	nBiome : cellBiome;
begin
	Randomize();
	seed := 300;
	//seed := 300;
	for x := 7 to ((MAP_SIZE div 2) - 7) do		//will not place doors close to edges
	begin										//doors allways point down so 
		for y := 7 to ((MAP_SIZE div 2) - 2) do //They can be placed closer to 
		begin									//the bottom edge than to the top
			if (Random(seed) = 0) and AreaClear(mapCells, x, y) then //Checks that no other doors are in the 
			begin													 //vicinity. So structure don't overlap
				if (x <= MAP_SIZE div 4) and (y <= MAP_SIZE div 4) then //caves
				begin
					inXoffset := MAP_SIZE div 8;
					inYoffset := MAP_SIZE div 2 + MAP_SIZE div 8;
					nType := Cave;
					nBiome := CaveBiome;
					mapCells[x, y].cType := Door;	//Set cell type to door
					mapCells[x, y].dType := Cave;	//Set the type of door (cave)
					GenerateInteriorDoors(mapCells[x + MAP_SIZE div 8, (y + MAP_SIZE div 2 + MAP_SIZE div 8)], 1);
					SetBarrierType(mapCells[x - 1, y], mapCells[x + inXoffset - 1, y + inYoffset], nType, nBiome);
					SetBarrierType(mapCells[x - 2, y], mapCells[x + inXoffset - 2, y + inYoffset], nType, nBiome);
					SetBarrierType(mapCells[x + 1, y], mapCells[x + inXoffset + 1, y + inYoffset], nType, nBiome);
					SetBarrierType(mapCells[x + 2, y], mapCells[x + inXoffset + 2, y + inYoffset], nType, nBiome);
					SetBarrierType(mapCells[x - 1, y - 1], mapCells[x + inXoffset - 1, y + inYoffset - 1], nType, nBiome);
					SetBarrierType(mapCells[x , y - 1], mapCells[x + inXoffset, y + inYoffset - 1], nType, nBiome);
					SetBarrierType(mapCells[x + 1, y - 1], mapCells[x + inXoffset + 1, y + inYoffset - 1], nType, nBiome);
					SetBarrierType(mapCells[x + 1, y - 2], mapCells[x + inXoffset, y + inYoffset - 2], nType, nBiome);
				end else if (x <= MAP_SIZE div 4) and (y >= MAP_SIZE div 4)  then //Small Towns
				begin
					mapCells[x, y].cType := Door;		//Set cell type to door
					mapCells[x, y].dType := Building;	//Set the type of door (building)
					GenerateInteriorDoors(mapCells[x + MAP_SIZE div 2 + 2, y], 3);
				end else if (x >= MAP_SIZE div 4) and (y <= MAP_SIZE div 4) then //Big Towns
				begin
					mapCells[x, y].cType := Door;		//Set cell type to door
					mapCells[x, y].dType := Building;	//Set the type of door (building)
					GenerateInteriorDoors(mapCells[x + MAP_SIZE div 2 + 2, y], 3);
				end else begin //Forest
					inXoffset := MAP_SIZE div 4 + MAP_SIZE div 8;
					inYoffset := MAP_SIZE div 4 + MAP_SIZE div 8;
					nType := Forest;
					nBiome := ForestBiome;
					mapCells[x, y].cType := Door;		//Set cell type to door
					mapCells[x, y].dType := Forest;		//Set the type of door (forest)
					GenerateInteriorDoors(mapCells[x + MAP_SIZE div 4 + MAP_SIZE div 8, (y + MAP_SIZE div 4) + MAP_SIZE div 8], 2);
					SetBarrierType(mapCells[x - 1, y], mapCells[x + inXoffset - 1, y + inYoffset], nType, nBiome);
					SetBarrierType(mapCells[x - 2, y], mapCells[x + inXoffset - 2, y + inYoffset], nType, nBiome);
					SetBarrierType(mapCells[x + 1, y], mapCells[x + inXoffset + 1, y + inYoffset], nType, nBiome);
					SetBarrierType(mapCells[x + 2, y], mapCells[x + inXoffset + 2, y + inYoffset], nType, nBiome);
					SetBarrierType(mapCells[x - 1, y - 1], mapCells[x + inXoffset - 1, y + inYoffset - 1], nType, nBiome);
					SetBarrierType(mapCells[x , y - 1], mapCells[x + inXoffset, y + inYoffset - 1], nType, nBiome);
					SetBarrierType(mapCells[x + 1, y - 1], mapCells[x + inXoffset + 1, y + inYoffset - 1], nType, nBiome);
					SetBarrierType(mapCells[x + 1, y - 2], mapCells[x + inXoffset, y + inYoffset - 2], nType, nBiome);
				end;
				
			end;
		end;
	end;
	for x := 0 to 55 do
		GenerateNature(mapCells);
end;

procedure ClearPaths(var mapCells : mapCellArray);
var x, y, i, inXoffset, inYoffset : integer;
	nextGen : mapCellArray;
begin			
	nextGen := mapCells;
	for x := 2 to MAP_SIZE div 2 - 2 do
	begin
		for y := 2 to MAP_SIZE div 2 - 2 do
		begin
			if (x <= MAP_SIZE div 4) and (y <= MAP_SIZE div 4) then
			begin
				inXoffset := MAP_SIZE div 8;
				inYoffset := MAP_SIZE div 2 + MAP_SIZE div 8;
			end else if (x > MAP_SIZE div 4) and (y > MAP_SIZE div 4) then
			begin
				inXoffset := MAP_SIZE div 4 + MAP_SIZE div 8;
				inYoffset := MAP_SIZE div 4 + MAP_SIZE div 8;
			end;
			if (mapCells[x, y].cType = Door)
			and (((x <= MAP_SIZE div 4) and (y <= MAP_SIZE div 4)) 
			or ((x > MAP_SIZE div 4) and (y > MAP_SIZE div 4))) then
			begin
				for i := 1 to 5 do
				begin
					if (mapCells[x, y + i].cType = Barrier) and (mapCells[x, y + i + 1].biome = GrassBiome) then 
					begin
						nextGen[x, y + i].cType := Terrain;
						nextGen[x + inXoffset, y + i + inYoffset].biome := Nothing;
						nextGen[x + inXoffset, y + i + inYoffset].cType := Barrier;
					end;
				end;
			end;
		end;
	end;
	mapCells := nextGen;
end;

//Sets outside to grass and sets all interiors to nothing
procedure SetBiome(var mapCells : mapCellArray{; player : sprite; topX, topY : integer});
var x, y : integer;
begin		
	for x := 0 to MAP_SIZE do
	begin
		for y := 0 to MAP_SIZE do
		begin
			if (x <= (MAP_SIZE div 2 + 1)) and (y <= (MAP_SIZE div 2 + 1)) then //Outside
			begin
				mapCells[x, y].biome := GrassBiome;
				mapCells[x, y].cType := Terrain;
			end else //Interiors
			begin
				mapCells[x, y].biome := Nothing;
				mapCells[x, y].cType := Barrier;
			end;
			if ((x = 0) and (y <= (MAP_SIZE div 2 + 1))) 
			or ((y = 0) and (x <= (MAP_SIZE div 2 + 1))) 
			or ((x = (MAP_SIZE div 2 + 1)) and (y <= (MAP_SIZE div 2 + 1))) 
			or ((y = (MAP_SIZE div 2 + 1)) and (x <= (MAP_SIZE div 2 + 1))) then
			begin
				//ring of trees surrounding outside
				//DrawBitmapPart(BitmapNamed('cells'), 120, 0, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * x), (SQUARE_SIZE * y)); 
				mapCells[x, y].cType := Barrier;
				mapCells[x, y].bType := Forest;
			end;
		end;
	end;
	GenerateDoors(mapCells); //Place "seeds" for structures
	ClearPaths(mapCells); //clears paths to doorways for structures
end;

end.