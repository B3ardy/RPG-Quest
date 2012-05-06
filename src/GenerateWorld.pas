unit GenerateWorld;

interface

uses SwinGame, sgTypes, TypeDec;

procedure SetBarrierType(var mCell, inCell : mapCell; barrierType : terrainType; biome : cellBiome);
procedure GenerateNature(var mapCells : mapCellArray; x0, y0 : integer; nType : terrainType);
procedure GenerateStructures(var mapCells : mapCellArray; x0, y0 : integer);
procedure GenerateInteriorDoors(var mCell : mapCell; tType : integer);
function AreaClear(const mapCells : mapCellArray; x0, y0 : integer) : Boolean;
procedure GenerateDoors(var mapCells : mapCellArray);
procedure SetBiome(var mapCells : mapCellArray; player : sprite; topX, topY : integer);

implementation

procedure SetBarrierType(var mCell, inCell : mapCell; barrierType : terrainType; biome : cellBiome);
begin 							//Used for Generating Structures
	mCell.cType := Barrier;		//Sets the cell to be a barrier
	mCell.bType := barrierType; //Sets what type of structure it will be
	
	inCell.biome := cellBiome(biome);
	inCell.cType := Terrain;
end;

procedure GenerateNature(var mapCells : mapCellArray; x0, y0 : integer; nType : terrainType);
var x, y, inXoffset, inYoffset : integer;
	nBiome : cellBiome;
begin			//Generates caves and forests
	//Sets the offsets to place the interiors in the right biomes
	if nType = Cave then
	begin
		inXoffset := 0;
		inYoffset := MAP_SIZE div 2;
		nBiome := CaveBiome;
	end else if nType = Forest then
	begin
		inXoffset := MAP_SIZE div 2;
		inYoffset := MAP_SIZE div 2;
		nBiome := ForestBiome;
	end;
	
	// without the necissary diagrams this code could be hard to follow
	// see diagram
	if (mapCells[x0, y0].size = 0) or (mapCells[x0, y0].size = 1) then
	begin
	{************************************
	****GENERATE SMALL CAVES/FORESTS*****
	*************************************}
		for x := (x0 - 1) to (x0 + 1) do
		begin
			for y := (y0 - 2) to y0 do
			begin
				if (x = x0) and (y= y0) then continue; //Core cave/forest
				SetBarrierType(mapCells[x, y], mapCells[(x + inXoffset), (y + inYoffset)], nType, nBiome);
			end;
		end;
		
		//extra random parts
		// 1st gen
		if Random(2) = 0 then //left
		begin
			SetBarrierType(mapCells[(x0 - 2), (y0 - 2)], mapCells[(x0 + inXoffset - 2), (y0 + inYoffset - 2)], nType, nBiome);
			SetBarrierType(mapCells[(x0 - 2), (y0 - 1)], mapCells[(x0 + inXoffset - 2), (y0 + inYoffset - 1)], nType, nBiome);
			SetBarrierType(mapCells[(x0 - 2), y0], mapCells[(x0 + inXoffset - 2), (y0 + inYoffset)], nType, nBiome);
		end;
		
		
		if Random(3) = 0 then //top
		begin
			SetBarrierType(mapCells[(x0 - 1), (y0 - 3)], mapCells[(x0 + inXoffset - 1), (y0 + inYoffset - 3)], nType, nBiome);
			SetBarrierType(mapCells[x0, (y0 - 3)], mapCells[(x0 + inXoffset), (y0 + inYoffset - 3)], nType, nBiome);
			SetBarrierType(mapCells[(x0 + 1), (y0 - 3)], mapCells[(x0 + inXoffset + 1), (y0 + inYoffset - 3)], nType, nBiome);
		end;
		
		
		if Random(3) = 0 then //bottom
			SetBarrierType(mapCells[(x0 + 1), (y0 + 1)], mapCells[(x0 + inXoffset + 1), (y0 + inYoffset + 1)], nType, nBiome);

		
		if Random(4) = 0 then //right
		begin
			SetBarrierType(mapCells[(x0 + 2), (y0 - 2)], mapCells[(x0 + inXoffset + 2), (y0 + inYoffset - 2)], nType, nBiome);
			SetBarrierType(mapCells[(x0 + 2), (y0 - 1)], mapCells[(x0 + inXoffset + 2), (y0 + inYoffset - 1)], nType, nBiome);
			SetBarrierType(mapCells[(x0 + 2), y0], mapCells[(x0 + inXoffset + 2), (y0 + inYoffset)], nType, nBiome);
		end;
		
		
		//2nd gen. based on which 1st gen sections got created
		if (Random(3) = 0) and ((mapCells[(x0 - 2), (y0 - 2)].cType = Barrier) or (mapCells[(x0 - 1), (y0 - 3)].cType = Barrier)) then //top left corner
			SetBarrierType(mapCells[(x0 - 1), (y0 - 3)], mapCells[(x0 + inXoffset - 1), (y0 + inYoffset - 3)], nType, nBiome);
			
		
		if (Random(3) = 0) and (((mapCells[(x0 + 1), (y0 - 3)].cType = Barrier) or (mapCells[(x0 + 2), (y0 - 2)].cType = Barrier))) then //top right corner
			SetBarrierType(mapCells[(x0 + 2), (y0 - 3)], mapCells[(x0 + inXoffset + 2), (y0 + inYoffset - 3)], nType, nBiome);
		
		
		if (Random(4) = 0) and (mapCells[(x0 - 2), y0].cType = Barrier) then //bottom left corner
			SetBarrierType(mapCells[(x0 - 2), (y0 + 1)], mapCells[(x0 + inXoffset - 2), (y0 + inYoffset + 1)], nType, nBiome);
			
		
		if (Random(4) = 0) and (mapCells[(x0 - 1), (y0 - 3)].cType = Barrier) then //above top
		begin
			SetBarrierType(mapCells[(x0 - 1), (y0 - 4)], mapCells[(x0 + inXoffset - 1), (y0 + inYoffset - 4)], nType, nBiome);
			SetBarrierType(mapCells[x0, (y0 - 4)], mapCells[(x0 + inXoffset), (y0 + inYoffset - 4)], nType, nBiome);
		end;
			
		
		if (Random(4) = 0) and ((mapCells[(x0 + 1), (y0 + 1)].cType = Barrier) or (mapCells[(x0 + 2), y0].cType = Barrier)) then //bottom right corner
			SetBarrierType(mapCells[(x0 + 2), (y0 + 1)], mapCells[(x0 + inXoffset + 2), (y0 + inYoffset + 1)], nType, nBiome);
		
		
		if (Random(6) = 0 ) and (mapCells[(x0 + 1), (y0 - 3)].cType = Barrier) then //above top to the right
			SetBarrierType(mapCells[(x0 + 1), (y0 - 4)], mapCells[(x0 + inXoffset + 1), (y0 + inYoffset - 4)], nType, nBiome);

		
		//3rd gen. based on which 2nd gen sections got created
		if (Random(2) = 0) and (mapCells[(x0 + 1), (y0 - 4)].cType = Barrier) then //top point
			SetBarrierType(mapCells[(x0 + 1), (y0 - 5)], mapCells[(x0 + inXoffset + 1), (y0 + inYoffset - 5)], nType, nBiome);
		
		
		if (Random(3) = 0) and (((mapCells[(x0 + 2), y0].cType = Barrier) or (mapCells[(x0 + 2), (y0 + 1)].cType = Barrier))) then //2nd most rightest
		begin
			SetBarrierType(mapCells[(x0 + 3), y0], mapCells[(x0 + inXoffset + 3), (y0 + inYoffset)], nType, nBiome);
			SetBarrierType(mapCells[(x0 + 3), (y0 + 1)], mapCells[(x0 + inXoffset + 3), (y0 + inYoffset + 1)], nType, nBiome);
		end;
		
		
		if (Random(4) = 0) and ((mapCells[(x0 - 2), (y0 - 2)].cType = Barrier) or (mapCells[(x0 - 2), (y0 - 3)].cType = Barrier)) then //more left
		begin
			SetBarrierType(mapCells[(x0 - 3), (y0 - 1)], mapCells[(x0 + inXoffset - 3), (y0 + inYoffset - 1)], nType, nBiome);
			SetBarrierType(mapCells[(x0 - 3), (y0 - 2)], mapCells[(x0 + inXoffset - 3), (y0 + inYoffset - 2)], nType, nBiome);
			SetBarrierType(mapCells[(x0 - 3), (y0 - 3)], mapCells[(x0 + inXoffset - 3), (y0 + inYoffset - 3)], nType, nBiome);
		end;
		
		
		if (Random(6) = 0) and (mapCells[(x0 - 2), (y0 + 1)].cType = Barrier) then //bottom lower left
			SetBarrierType(mapCells[(x0 - 3), (y0 + 1)], mapCells[(x0 + inXoffset - 3), (y0 + inYoffset + 1)], nType, nBiome);
			
		
		if (Random(7) = 0) and (mapCells[(x0 + 2), (y0 + 1)].cType = Barrier) then //bottomest
			SetBarrierType(mapCells[(x0 + 2), (y0 + 2)], mapCells[(x0 + inXoffset + 2), (y0 + inYoffset + 2)], nType, nBiome);
		
		
		//4th gen. Based on which 3rd gen sections got created
		if (Random(5) = 1) and (mapCells[(x0 + 3), y0].cType = Barrier) then //most right
			SetBarrierType(mapCells[(x0 + 4), y0], mapCells[(x0 + inXoffset + 4), (y0 + inYoffset)], nType, nBiome);
		
		
		if (Random(6) = 0) and (mapCells[(x0 - 3), (y0 - 2)].cType = Barrier) then //bottom lower left
			SetBarrierType(mapCells[(x0 - 4), (y0 - 2)], mapCells[(x0 + inXoffset - 4), (y0 + inYoffset - 2)], nType, nBiome);
			
			//END GENERATE SMALL CAVES/FORESTS
	end else if mapCells[x0, y0].size = 2 then
	begin
	{************************************
	*****GENERATE BIG CAVES/FORESTS******
	*************************************}
		for x := (x0 - 2) to (x0 + 2) do
		begin
			for y := (y0 - 3) to y0 do
			begin
				if (x = x0) and (y= y0) then continue;
				SetBarrierType(mapCells[x, y], mapCells[(x + inXoffset), (y + inYoffset)], nType, nBiome);
			end;
		end;
		
		//extra random parts
		// 1st gen
		if Random(2) = 0 then //left
		begin
			SetBarrierType(mapCells[(x0 - 3), (y0 - 3)], mapCells[(x0 + inXoffset - 3), (y0 + inYoffset - 3)], nType, nBiome);
			SetBarrierType(mapCells[(x0 - 3), (y0 - 2)], mapCells[(x0 + inXoffset - 3), (y0 + inYoffset - 2)], nType, nBiome);
			SetBarrierType(mapCells[(x0 - 3), (y0 - 1)], mapCells[(x0 + inXoffset - 3), (y0 + inYoffset - 1)], nType, nBiome);
			SetBarrierType(mapCells[(x0 - 3), y0], mapCells[(x0 + inXoffset - 3), (y0 + inYoffset)], nType, nBiome);
		end;
		
		
		if Random(3) = 0 then //top
		begin
			SetBarrierType(mapCells[(x0 - 1), (y0 - 4)], mapCells[(x0 + inXoffset - 1), (y0 + inYoffset - 4)], nType, nBiome);
			SetBarrierType(mapCells[(x0 - 2), (y0 - 4)], mapCells[(x0 + inXoffset - 2), (y0 + inYoffset - 4)], nType, nBiome);
			SetBarrierType(mapCells[x0, (y0 - 4)], mapCells[(x0 + inXoffset), (y0 + inYoffset - 4)], nType, nBiome);
			SetBarrierType(mapCells[(x0 + 1), (y0 - 4)], mapCells[(x0 + inXoffset + 1), (y0 + inYoffset - 4)], nType, nBiome);
			SetBarrierType(mapCells[(x0 + 2), (y0 - 4)], mapCells[(x0 + inXoffset + 2), (y0 + inYoffset - 4)], nType, nBiome);
		end;
		
		
		if Random(3) = 0 then //bottom left
		begin
			SetBarrierType(mapCells[(x0 + 1), (y0 + 1)], mapCells[(x0 + inXoffset + 1), (y0 + inYoffset + 1)], nType, nBiome);
			SetBarrierType(mapCells[(x0 + 2), (y0 + 1)], mapCells[(x0 + inXoffset + 2), (y0 + inYoffset + 1)], nType, nBiome);
		end;

		
		if Random(4) = 0 then //bottom right
		begin
			SetBarrierType(mapCells[(x0 - 2), (y0 + 1)], mapCells[(x0 + inXoffset - 2), (y0 + inYoffset + 1)], nType, nBiome);
			SetBarrierType(mapCells[(x0 - 3), (y0 + 1)], mapCells[(x0 + inXoffset - 3), (y0 + inYoffset + 1)], nType, nBiome);
		end;
		
		
		if Random(4) = 0 then //right
		begin
			SetBarrierType(mapCells[(x0 + 3), (y0 - 3)], mapCells[(x0 + inXoffset + 3), (y0 + inYoffset - 3)], nType, nBiome);
			SetBarrierType(mapCells[(x0 + 3), (y0 - 2)], mapCells[(x0 + inXoffset + 3), (y0 + inYoffset - 2)], nType, nBiome);
			SetBarrierType(mapCells[(x0 + 3), (y0 - 1)], mapCells[(x0 + inXoffset + 3), (y0 + inYoffset - 1)], nType, nBiome);
			SetBarrierType(mapCells[(x0 + 3), y0], mapCells[(x0 + inXoffset + 3), (y0 + inYoffset)], nType, nBiome);
		end;
		
		//2nd gen. based on which 1st gen sections got created
		
		if (Random(3) = 0) and ((mapCells[(x0 - 3), (y0 - 3)].cType = Barrier) or (mapCells[(x0 - 2), (y0 - 4)].cType = Barrier)) then //top left corner
			SetBarrierType(mapCells[(x0 - 3), (y0 - 4)], mapCells[(x0 + inXoffset - 3), (y0 + inYoffset - 4)], nType, nBiome);
			
		
		if (Random(3) = 0) and (((mapCells[(x0 + 2), (y0 + 4)].cType = Barrier) or (mapCells[(x0 + 3), (y0 + 3)].cType = Barrier))) then //top right corner
			SetBarrierType(mapCells[(x0 + 3), (y0 + 4)], mapCells[(x0 + inXoffset + 3), (y0 + inYoffset + 4)], nType, nBiome);
		
		
		if (Random(4) = 0) and ((mapCells[(x0 + 2), (y0 + 1)].cType = Barrier) or (mapCells[(x0 + 3), y0].cType = Barrier)) then //bottom left corner
			SetBarrierType(mapCells[(x0 + 3), (y0 + 1)], mapCells[(x0 + inXoffset + 3), (y0 + inYoffset + 1)], nType, nBiome);
			
		
		if (Random(4) = 0) and (mapCells[x0, (y0 - 4)].cType = Barrier) then //above top
		begin
			SetBarrierType(mapCells[(x0 - 1), (y0 - 5)], mapCells[(x0 + inXoffset - 1), (y0 + inYoffset - 5)], nType, nBiome);
			SetBarrierType(mapCells[(x0 - 2), (y0 - 5)], mapCells[(x0 + inXoffset - 2), (y0 + inYoffset - 5)], nType, nBiome);
			SetBarrierType(mapCells[x0, (y0 - 5)], mapCells[(x0 + inXoffset), (y0 + inYoffset - 5)], nType, nBiome);
		end;
			
		
		if (Random(6) = 0) and ((mapCells[(x0 - 3), (y0 + 1)].cType = Barrier)) then //bottom right corner
			SetBarrierType(mapCells[(x0 - 4), (y0 + 1)], mapCells[(x0 + inXoffset - 4), (y0 + inYoffset + 1)], nType, nBiome);
		
		
		if (Random(6) = 0 ) and (mapCells[(x0 + 1), (y0 - 4)].cType = Barrier) then //above top to the right
		begin
			SetBarrierType(mapCells[(x0 + 1), (y0 - 5)], mapCells[(x0 + inXoffset + 1), (y0 + inYoffset - 5)], nType, nBiome);
			SetBarrierType(mapCells[(x0 + 2), (y0 - 5)], mapCells[(x0 + inXoffset + 2), (y0 + inYoffset - 5)], nType, nBiome);
		end;

		//3rd gen. based on which 2nd gen sections got created
		
		if (Random(2) = 0) and (mapCells[(x0 + 1), (y0 - 5)].cType = Barrier) then //top point
			SetBarrierType(mapCells[(x0 + 1), (y0 - 6)], mapCells[(x0 + inXoffset + 1), (y0 + inYoffset - 6)], nType, nBiome);
		
		
		if (Random(3) = 0) and (((mapCells[(x0 + 3), y0].cType = Barrier) or (mapCells[(x0 + 3), (y0 + 1)].cType = Barrier))) then //2nd most rightest
		begin
			SetBarrierType(mapCells[(x0 + 4), (y0 - 1)], mapCells[(x0 + inXoffset + 4), (y0 + inYoffset - 1)], nType, nBiome);
			SetBarrierType(mapCells[(x0 + 4), y0], mapCells[(x0 + inXoffset + 4), (y0 + inYoffset)], nType, nBiome);
			SetBarrierType(mapCells[(x0 + 4), (y0 + 1)], mapCells[(x0 + inXoffset + 4), (y0 + inYoffset + 1)], nType, nBiome);
		end;
		
		
		if (Random(4) = 0) and ((mapCells[(x0 - 3), (y0 - 2)].cType = Barrier) or (mapCells[(x0 - 3), (y0 - 4)].cType = Barrier)) then //more left
		begin
			SetBarrierType(mapCells[(x0 - 4), (y0 - 2)], mapCells[(x0 + inXoffset - 4), (y0 + inYoffset - 2)], nType, nBiome);
			SetBarrierType(mapCells[(x0 - 4), (y0 - 3)], mapCells[(x0 + inXoffset - 4), (y0 + inYoffset - 3)], nType, nBiome);
			SetBarrierType(mapCells[(x0 - 4), (y0 - 4)], mapCells[(x0 + inXoffset - 4), (y0 + inYoffset - 4)], nType, nBiome);
		end;
			
		
		if (Random(7) = 0) and (mapCells[(x0 + 3), (y0 + 1)].cType = Barrier) then //bottomest
			SetBarrierType(mapCells[(x0 + 3), (y0 + 2)], mapCells[(x0 + inXoffset + 3), (y0 + inYoffset + 2)], nType, nBiome);
		
		
		//4th gen. Based on which 3rd gen sections got created
		if (Random(5) = 1) and (mapCells[(x0 + 4), y0].cType = Barrier) then //most right
			SetBarrierType(mapCells[(x0 + 5), y0], mapCells[(x0 + inXoffset + 5), (y0 + inYoffset)], nType, nBiome);
		
		
		if (Random(6) = 0) and (mapCells[(x0 - 4), (y0 - 3)].cType = Barrier) then //bottom lower left
			SetBarrierType(mapCells[(x0 - 5), (y0 - 3)], mapCells[(x0 + inXoffset - 5), (y0 + inYoffset - 3)], nType, nBiome);
		
			//END GENERATE BIG CAVES/FORESTS
	end;
end;

procedure GenerateStructures(var mapCells : mapCellArray; x0, y0 : integer);
var  x, y : integer;
begin
	Randomize();
	mapCells[x0, y0].size := Random(3); //Size of the structure.
	
	if mapCells[x0, y0].dType <> Building then //Generates the caves and forests
	begin
		GenerateNature(mapCells, x0, y0, mapCells[x0, y0].dType);
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
	end;
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
var x, y, seed, xOffset, yOffset, tType : integer;
begin
	Randomize();
	seed := 200;
	for x := 7 to ((MAP_SIZE div 2) - 7) do		//will not place doors close to edges
	begin										//doors allways point down so 
		for y := 7 to ((MAP_SIZE div 2) - 2) do //They can be placed closer to 
		begin									//the bottom edge than to the top
			if (Random(seed) = 0) and AreaClear(mapCells, x, y) then //Checks that no other doors are in the 
			begin													 //vicinity. So structure don't overlap
				tType := Random(3) + 1;
				mapCells[x, y].cType := Door; //Set cell type to door
				mapCells[x, y].dType := terrainType(tType); 	//Set the type of door (cave/forest/building)
				Delay(3); //delay provides more randomness		  and hence what type of structure will be there
						  //because random() tied to clock
				xOffset := 0; //Sets doors for interiors
				yOffset := 0;
				if mapCells[x, y].dType = Cave then
				begin
					yOffset := MAP_SIZE div 2;
					GenerateInteriorDoors(mapCells[(x + xOffset), (y + yOffset)], tType);
				end else if mapCells[x, y].dType = Forest then
				begin
					xOffset := MAP_SIZE div 2;
					yOffset := MAP_SIZE div 2;
					GenerateInteriorDoors(mapCells[(x + xOffset), (y + yOffset)], tType);
				end else if mapCells[x, y].dType = Building then begin
					xOffset := MAP_SIZE div 2;
					GenerateInteriorDoors(mapCells[(x + xOffset), (y + yOffset)], tType);
				end;
				
				GenerateStructures(mapCells, x, y); //Generate the structures around the doors
				
			end;
		end;
	end;
end;

//Sets outside to grass and sets all interiors to nothing
procedure SetBiome(var mapCells : mapCellArray; player : sprite; topX, topY : integer);
var x, y : integer;
begin		
	for x := 0 to MAP_SIZE do
	begin
		for y := 0 to MAP_SIZE do
		begin
			if ((x = 0) and (y <= (MAP_SIZE div 2 + 1))) 
			or ((y = 0) and (x <= (MAP_SIZE div 2 + 1))) 
			or ((x = (MAP_SIZE div 2 + 1)) and (y <= (MAP_SIZE div 2 + 1))) 
			or ((y = (MAP_SIZE div 2 + 1)) and (x <= (MAP_SIZE div 2 + 1))) then
			begin
				//ring of trees surrounding outside
				DrawBitmapPart(BitmapNamed('cells'), 120, 0, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * x), (SQUARE_SIZE * y)); 
				mapCells[x, y].cType := Barrier;
			end;
			if (x <= (MAP_SIZE div 2 + 1)) and (y <= (MAP_SIZE div 2 + 1)) then //Outside
			begin
				mapCells[x, y].biome := GrassBiome;
				mapCells[x, y].cType := Terrain;
			end else //Interiors
			begin
				mapCells[x, y].biome := Nothing;
				mapCells[x, y].cType := Barrier;
			end;
		end;
	end;
	GenerateDoors(mapCells);
end;

end.