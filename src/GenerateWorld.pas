unit GenerateWorld;

interface

uses SwinGame, sgTypes, TypeDec;

procedure SetBarrierType(var mCell, inCell : mapCell; barrierType : terrainType; biome : cellBiome);
procedure GenerateNature(var mapCells : mapCellArray);
procedure GenerateInteriorDoors(var mCell : mapCell; tType : integer);
procedure PlaceSeeds(var mapCells : mapCellArray);
procedure SetBiome(var mapCells : mapCellArray);

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
			if (x <= MAP_SIZE div 4 + 7) and (y <= MAP_SIZE div 4 + 7) then
			begin
				inXoffset := MAP_SIZE div 8;
				inYoffset := MAP_SIZE div 2 + MAP_SIZE div 8;
				nType := Cave;
				nBiome := CaveBiome;
			end else if (x > MAP_SIZE div 4 - 7) and (y > MAP_SIZE div 4 - 7) then
			begin
				inXoffset := MAP_SIZE div 4 + MAP_SIZE div 8;
				inYoffset := MAP_SIZE div 4 + MAP_SIZE div 8;
				nType := Forest;
				nBiome := ForestBiome;
			end;
			if (mapCells[x, y].cType = Terrain)
			and (((x <= MAP_SIZE div 4 + 7) and (y <= MAP_SIZE div 4 + 7)) 
			or ((x > MAP_SIZE div 4 - 7) and (y > MAP_SIZE div 4 - 7))) then
			begin
				n := 0;
				if (nextGen[(x - 1), (y - 1)].cType <> Terrain) 
				and (nextGen[(x - 1), (y - 1)].cType <> Town) then 
				begin
					n += 1;
				end;
				if (nextGen[(x - 1), y].cType <> Terrain) 
				and (nextGen[(x - 1), y].cType <> Town) then 
				begin
					n += 1;
				end;
				if (nextGen[(x - 1), (y + 1)].cType <> Terrain) 
				and (nextGen[(x - 1), (y + 1)].cType <> Town) then 
				begin
					n += 1;
				end;
				if (nextGen[x, (y - 1)].cType <> Terrain) 
				and (nextGen[x, (y - 1)].cType <> Town) then 
				begin
					n += 1;
				end;
				if (nextGen[x, (y + 1)].cType <> Terrain) 
				and (nextGen[x, (y + 1)].cType <> Town) then 
				begin
					n += 1;
				end;
				if (nextGen[(x + 1), (y - 1)].cType <> Terrain) 
				and (nextGen[(x + 1), (y - 1)].cType <> Town) then 
				begin
					n += 1;
				end;
				if (nextGen[(x + 1), y].cType <> Terrain) 
				and (nextGen[(x + 1), y].cType <> Town) then 
				begin
					n += 1;
				end;
				if (nextGen[(x + 1), (y + 1)].cType <> Terrain) 
				and (nextGen[(x + 1), (y + 1)].cType <> Town) then 
				begin
					n += 1;
				end;
				if (Random(42 - n * 5) = 0) and (n <> 0) then
				begin
					SetBarrierType(nextGen[x, y], nextGen[x + inXoffset, y + inYoffset], nType, nBiome);
				end;
			end;
		end;
	end;
	mapCells := nextGen;
end;

procedure ConstructBuilding(var mapCells : mapCellArray;  x0, y0 : Integer);
var x, y : Integer;
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
end;

procedure GenerateInteriorDoors(var mCell : mapCell; tType : integer);
begin
	mCell.biome := cellBiome(tType);
	mCell.cType := Door; 
	mCell.dType := Grass;
end;

procedure GenerateTowns(var mapCells : mapCellArray; x, y, size : integer);
//var  x, y : integer;
begin
	if size = 7 then
	begin
		{*******************************
		 *******MEDIUM BUILDINGS********
		 *******************************}
		mapCells[x - 3, y - 1].cType := Door;
		mapCells[x - 3, y - 1].dType := Building;
		mapCells[x - 3, y - 1].size := 1;
		GenerateInteriorDoors(mapCells[(x - 3) + MAP_SIZE div 2, y - 1], 3);
		ConstructBuilding(mapCells, x - 3, y - 1);
		
		mapCells[x - 3, y + 6].cType := Door;
		mapCells[x - 3, y + 6].dType := Building;
		mapCells[x - 3, y + 6].size := 1;
		GenerateInteriorDoors(mapCells[(x - 3) + MAP_SIZE div 2, y + 6], 3);
		ConstructBuilding(mapCells, x - 3, y + 6);
		
		mapCells[x + 3, y - 1].cType := Door;
		mapCells[x + 3, y - 1].dType := Building;
		mapCells[x + 3, y - 1].size := 1;
		GenerateInteriorDoors(mapCells[x + 3 + MAP_SIZE div 2, y - 1], 3);
		ConstructBuilding(mapCells, x + 3, y - 1);
		
		mapCells[x + 3, y + 6].cType := Door;
		mapCells[x + 3, y + 6].dType := Building;
		mapCells[x + 3, y + 6].size := 1;
		GenerateInteriorDoors(mapCells[(x + 3) + MAP_SIZE div 2, y + 6], 3);
		ConstructBuilding(mapCells, x + 3, y + 6);
		
		{*******************************
		 ********SMALL BUILDINGS********
		 *******************************}
		
		mapCells[x - 7, y - 1].cType := Door;
		mapCells[x - 7, y - 1].dType := Building;
		mapCells[x - 7, y - 1].size := 0;
		GenerateInteriorDoors(mapCells[(x - 7) + MAP_SIZE div 2, y - 1], 3);
		ConstructBuilding(mapCells, x - 7, y - 1);
		
		mapCells[x - 7, y + 6].cType := Door;
		mapCells[x - 7, y + 6].dType := Building;
		mapCells[x - 7, y + 6].size := 0;
		GenerateInteriorDoors(mapCells[(x - 7) + MAP_SIZE div 2, y + 6], 3);
		ConstructBuilding(mapCells, x - 7, y + 6);
		
		mapCells[x + 7, y - 1].cType := Door;
		mapCells[x + 7, y - 1].dType := Building;
		mapCells[x + 7, y - 1].size := 0;
		GenerateInteriorDoors(mapCells[x + 7 + MAP_SIZE div 2, y - 1], 3);
		ConstructBuilding(mapCells, x + 7, y - 1);
		
		mapCells[x + 7, y + 6].cType := Door;
		mapCells[x + 7, y + 6].dType := Building;
		mapCells[x + 7, y + 6].size := 0;
		GenerateInteriorDoors(mapCells[(x + 7) + MAP_SIZE div 2, y + 6], 3);
		ConstructBuilding(mapCells, x + 7, y + 6);
		
		mapCells[x - 2, y - 6].cType := Door;
		mapCells[x - 2, y - 6].dType := Building;
		mapCells[x - 2, y - 6].size := 0;
		GenerateInteriorDoors(mapCells[(x - 2) + MAP_SIZE div 2, y - 6], 3);
		ConstructBuilding(mapCells, x - 2, y - 6);
		
		mapCells[x - 2, y + 11].cType := Door;
		mapCells[x - 2, y + 11].dType := Building;
		mapCells[x - 2, y + 11].size := 0;
		GenerateInteriorDoors(mapCells[(x - 2) + MAP_SIZE div 2, y + 11], 3);
		ConstructBuilding(mapCells, x - 2, y + 11);
		
		mapCells[x + 2, y - 6].cType := Door;
		mapCells[x + 2, y - 6].dType := Building;
		mapCells[x + 2, y - 6].size := 0;
		GenerateInteriorDoors(mapCells[x + 2 + MAP_SIZE div 2, y - 6], 3);
		ConstructBuilding(mapCells, x + 2, y - 6);
		
		mapCells[x + 2, y + 11].cType := Door;
		mapCells[x + 2, y + 11].dType := Building;
		mapCells[x + 2, y + 11].size := 0;
		GenerateInteriorDoors(mapCells[(x + 2) + MAP_SIZE div 2, y + 11], 3);
		ConstructBuilding(mapCells, x + 2, y + 11);
	end else if size = 10 then 
	begin
		{*******************************
		 ********LARGE BUILDINGS********
		 *******************************}
		mapCells[x - 4, y - 1].cType := Door;
		mapCells[x - 4, y - 1].dType := Building;
		mapCells[x - 4, y - 1].size := 2;
		GenerateInteriorDoors(mapCells[(x - 4) + MAP_SIZE div 2, y - 1], 3);
		ConstructBuilding(mapCells, x - 4, y - 1);
		
		mapCells[x - 4, y + 7].cType := Door;
		mapCells[x - 4, y + 7].dType := Building;
		mapCells[x - 4, y + 7].size := 2;
		GenerateInteriorDoors(mapCells[(x - 4) + MAP_SIZE div 2, y + 7], 3);
		ConstructBuilding(mapCells, x - 4, y + 7);
		
		mapCells[x + 4, y - 1].cType := Door;
		mapCells[x + 4, y - 1].dType := Building;
		mapCells[x + 4, y - 1].size := 2;
		GenerateInteriorDoors(mapCells[x + 4 + MAP_SIZE div 2, y - 1], 3);
		ConstructBuilding(mapCells, x + 4, y - 1);
		
		mapCells[x + 4, y + 7].cType := Door;
		mapCells[x + 4, y + 7].dType := Building;
		mapCells[x + 4, y + 7].size := 2;
		GenerateInteriorDoors(mapCells[(x + 4) + MAP_SIZE div 2, y + 7], 3);
		ConstructBuilding(mapCells, x + 4, y + 7);
		
		{*******************************
		 *******MEDIUM BUILDINGS********
		 *******************************}
		mapCells[x - 3, y - 7].cType := Door;
		mapCells[x - 3, y - 7].dType := Building;
		mapCells[x - 3, y - 7].size := 1;
		GenerateInteriorDoors(mapCells[(x - 3) + MAP_SIZE div 2, y - 7], 3);
		ConstructBuilding(mapCells, x - 3, y - 7);
		
		mapCells[x - 3, y + 12].cType := Door;
		mapCells[x - 3, y + 12].dType := Building;
		mapCells[x - 3, y + 12].size := 1;
		GenerateInteriorDoors(mapCells[(x - 3) + MAP_SIZE div 2, y + 12], 3);
		ConstructBuilding(mapCells, x - 3, y + 12);
		
		mapCells[x + 3, y - 7].cType := Door;
		mapCells[x + 3, y - 7].dType := Building;
		mapCells[x + 3, y - 7].size := 1;
		GenerateInteriorDoors(mapCells[x + 3 + MAP_SIZE div 2, y - 7], 3);
		ConstructBuilding(mapCells, x + 3, y - 7);
		
		mapCells[x + 3, y + 12].cType := Door;
		mapCells[x + 3, y + 12].dType := Building;
		mapCells[x + 3, y + 12].size := 1;
		GenerateInteriorDoors(mapCells[(x + 3) + MAP_SIZE div 2, y + 12], 3);
		ConstructBuilding(mapCells, x + 3, y + 12);
		
		mapCells[x - 10, y - 1].cType := Door;
		mapCells[x - 10, y - 1].dType := Building;
		mapCells[x - 10, y - 1].size := 1;
		GenerateInteriorDoors(mapCells[(x - 10) + MAP_SIZE div 2, y - 1], 3);
		ConstructBuilding(mapCells, x - 10, y - 1);
		
		mapCells[x - 10, y + 6].cType := Door;
		mapCells[x - 10, y + 6].dType := Building;
		mapCells[x - 10, y + 6].size := 1;
		GenerateInteriorDoors(mapCells[(x - 10) + MAP_SIZE div 2, y + 6], 3);
		ConstructBuilding(mapCells, x - 10, y + 6);
		
		mapCells[x + 10, y - 1].cType := Door;
		mapCells[x + 10, y - 1].dType := Building;
		mapCells[x + 10, y - 1].size := 1;
		GenerateInteriorDoors(mapCells[x + 10 + MAP_SIZE div 2, y - 1], 3);
		ConstructBuilding(mapCells, x + 10, y - 1);
		
		mapCells[x + 10, y + 6].cType := Door;
		mapCells[x + 10, y + 6].dType := Building;
		mapCells[x + 10, y + 6].size := 1;
		GenerateInteriorDoors(mapCells[(x + 10) + MAP_SIZE div 2, y + 6], 3);
		ConstructBuilding(mapCells, x + 10, y + 6);
		
		{*******************************
		 ********SMALL BUILDINGS********
		 *******************************}
		
		mapCells[x - 9, y - 6].cType := Door;
		mapCells[x - 9, y - 6].dType := Building;
		mapCells[x - 9, y - 6].size := 0;
		GenerateInteriorDoors(mapCells[(x - 9) + MAP_SIZE div 2, y - 6], 3);
		ConstructBuilding(mapCells, x - 9, y - 6);
		
		mapCells[x - 9, y + 11].cType := Door;
		mapCells[x - 9, y + 11].dType := Building;
		mapCells[x - 9, y + 11].size := 0;
		GenerateInteriorDoors(mapCells[(x - 9) + MAP_SIZE div 2, y + 11], 3);
		ConstructBuilding(mapCells, x - 9, y + 11);
		
		mapCells[x + 9, y - 6].cType := Door;
		mapCells[x + 9, y - 6].dType := Building;
		mapCells[x + 9, y - 6].size := 0;
		GenerateInteriorDoors(mapCells[x + 9 + MAP_SIZE div 2, y - 6], 3);
		ConstructBuilding(mapCells, x + 9, y - 6);
		
		mapCells[x + 9, y + 11].cType := Door;
		mapCells[x + 9, y + 11].dType := Building;
		mapCells[x + 9, y + 11].size := 0;
		GenerateInteriorDoors(mapCells[(x + 9) + MAP_SIZE div 2, y + 11], 3);
		ConstructBuilding(mapCells, x + 9, y + 11);
		
	end;
end;

function AreaClear(const mapCells : mapCellArray; x0, y0, size : integer) : Boolean;
var x, y : integer; //Checks area so doors spawn away from eachother 
begin 				//so the accompanying buidlings will not overlap
	result := True; //Default is true
	for x := (x0 - size) to (x0 + size) do
	begin
		for y := (y0 - size) to (y0 + size) do
		begin
			if (mapCells[x, y].cType = Door) or (mapCells[x, y].cType = Town) then //Checking own cell is not a problem 
			begin								//because that cell isn't set yet.
				result := False;				//If it finds a door then area not clear
				exit;							//function can then end
			end;
		end;
	end;
end;

procedure PlaceSeeds(var mapCells : mapCellArray); //Generates doors on to the game world
var x, y, seed, x0, y0, inXoffset, inYoffset : integer;
	nType : terrainType;
	nBiome : cellBiome;
begin
	Randomize();
	seed := 300;
	//seed := 300;
	for x := 7 to ((MAP_SIZE div 2) - 7) do		//will not place doors close to edges
	begin										//doors allways point down so 
		for y := 7 to ((MAP_SIZE div 2) - 7) do //They can be placed closer to 
		begin									//the bottom edge than to the top
			if (Random(seed) = 0) and AreaClear(mapCells, x, y, 7) then //Checks that no other doors are in the 
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
				end else if (x <= MAP_SIZE div 4 - 11) 
				and (x > 11) and (y > MAP_SIZE div 4 + 11) 
				and (y < MAP_SIZE div 2 - 11) and (AreaClear(mapCells, x, y, 15)) 
				and (Random(4) = 0) then //Small Towns
				begin
					mapCells[x, y].cType := Town;		//Set cell type to town
					mapCells[x, y].tSize := 7;			//Set the size of town
					GenerateTowns(mapCells, x, y, 7);
				end else if (x > MAP_SIZE div 4 + 16) and (x < MAP_SIZE div 2 - 9) 
				and (y <= MAP_SIZE div 4 - 16) and (y > 16) 
				and (AreaClear(mapCells, x, y, 15)) and (Random(4) = 0) then //Big Towns
				begin
					mapCells[x, y].cType := Town;		//Set cell type to town
					mapCells[x, y].tSize := 10;			//Set the size of town
					GenerateTowns(mapCells, x, y, 10);
				end else if (x > MAP_SIZE div 4) and (y > MAP_SIZE div 4) then //Forest
				begin 
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
	open, closed : array of starCell;
	path : boolean;
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
				for i := 1 to 6 do
				begin
					if (mapCells[x - 3 + i, y + 5].cType = Barrier) and (mapCells[x - 5 + i, y + 6].biome = GrassBiome) then 
					begin
						nextGen[x - 3 + i, y + 5].cType := Terrain;
						nextGen[x + inXoffset - 3 + i, y + 5 + inYoffset].biome := Nothing;
						nextGen[x + inXoffset - 3 + i, y + 5 + inYoffset].cType := Barrier;
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
				mapCells[x, y].cType := Barrier;
				mapCells[x, y].bType := Forest;
			end;
		end;
	end;
	PlaceSeeds(mapCells); //Place "seeds" for structures
	ClearPaths(mapCells); //clears paths to doorways for structures
end;

end.