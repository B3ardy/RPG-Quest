program RPGQuest;
uses SwinGame, sgTypes;
const SQUARE_SIZE = 40;
	  MAP_SIZE = 500;
type
	//Used to set the floor tyle
	cellBiome = (GrassBiome, CaveBiome, ForestBiome, BuildingBiome, Nothing);
	
	//Door transports to interior
	//Barrier is impassable
	//Terrain = !Barrier
	cellType = (Door, Barrier, Terrain);
	
	//Sets what artwork to use
	terrainType = (Grass, Cave, Forest, Building);
	
	//Information on each cell in the game world
	mapCell = record
		biome : cellBiome; //sets background floor tile
		case cType : cellType of //sets type of cell
			Door : (dType : terrainType; size : integer); //door sets what type of door (cave/forest/building)
			Barrier : (bType : terrainType); //Sets what kind of barrier (cave/forest/building)
			Terrain : (tType : terrainType); //Probably not needed. This can be done with biome
	end;
	
	//Game World
	mapCellArray = array [0 .. MAP_SIZE, 0 .. MAP_SIZE] of mapCell;
	
procedure DrawGrid();
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
	
end;

procedure DrawBuilding(const mapCells : mapCellArray; x, y : integer);
begin
	//draw top of door
	DrawBitmapPart(BitmapNamed('cells'), 200, 80, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * x), (SQUARE_SIZE * (y - 1)));
	if mapCells[x,y].size = 0 then //small building
	begin
		DrawBitmapPart(BitmapNamed('cells'), 160, 0, (3 * SQUARE_SIZE), (4 * SQUARE_SIZE), (SQUARE_SIZE * (x - 1)), (SQUARE_SIZE * (y - 3)));
		
	end else if mapCells[x,y].size = 1 then //medium building
	begin
		//Draw cells above door
		DrawBitmapPart(BitmapNamed('cells'), 200, 0, SQUARE_SIZE, (2 * SQUARE_SIZE), (SQUARE_SIZE * x), (SQUARE_SIZE * (y - 3)));
		
		//Draw left side of building
		//Next to door
		DrawBitmapPart(BitmapNamed('cells'), 200, 160, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * (x - 1)), (SQUARE_SIZE * y));			//Bottom Cell
		DrawBitmapPart(BitmapNamed('cells'), 160, 160, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * (x - 1)), (SQUARE_SIZE * (y - 1)));
		DrawBitmapPart(BitmapNamed('cells'), 200, 0, SQUARE_SIZE, (2 * SQUARE_SIZE), (SQUARE_SIZE * (x - 1)), (SQUARE_SIZE * (y - 3))); //Top Cells
		//Outer edge
		DrawBitmapPart(BitmapNamed('cells'), 160, 0, SQUARE_SIZE, (4 * SQUARE_SIZE), (SQUARE_SIZE * (x - 2)), (SQUARE_SIZE * (y - 3)));
		
		//Draws right side of building
		//Next to door
		DrawBitmapPart(BitmapNamed('cells'), 200, 160, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * (x + 1)), (SQUARE_SIZE * y));		//Bottom Cell
		DrawBitmapPart(BitmapNamed('cells'), 160, 160, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * (x + 1)), (SQUARE_SIZE * (y - 1)));
		DrawBitmapPart(BitmapNamed('cells'), 200, 0, SQUARE_SIZE, (2 * SQUARE_SIZE), (SQUARE_SIZE * (x + 1)), (SQUARE_SIZE * (y - 3)));	//Top Cells
		//Outer edge
		DrawBitmapPart(BitmapNamed('cells'), 240, 0, SQUARE_SIZE, (4 * SQUARE_SIZE), (SQUARE_SIZE * (x + 2)), (SQUARE_SIZE * (y - 3)));
		
	end else if mapCells[x,y].size = 2 then //large building
	begin
		//Draw cells above door
		DrawBitmapPart(BitmapNamed('cells'), 160, 160, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * x), (SQUARE_SIZE * (y - 2))); //Above door
		DrawBitmapPart(BitmapNamed('cells'), 200, 0, SQUARE_SIZE, (2 * SQUARE_SIZE), (SQUARE_SIZE * x), (SQUARE_SIZE * (y - 4)));  //Top of roof
		
		//Draw left side of building
		//Next to door
		DrawBitmapPart(BitmapNamed('cells'), 200, 160, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * (x - 1)), (SQUARE_SIZE * y));		//Bottom Cell
		DrawBitmapPart(BitmapNamed('cells'), 40, 0, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * (x - 1)), (SQUARE_SIZE * (y - 1)));
		DrawBitmapPart(BitmapNamed('cells'), 40, 0, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * (x - 1)), (SQUARE_SIZE * (y - 2)));
		DrawBitmapPart(BitmapNamed('cells'), 200, 0, SQUARE_SIZE, (2 * SQUARE_SIZE), (SQUARE_SIZE * (x - 1)), (SQUARE_SIZE * (y - 4)));   //Top Cells
		//between edges and next to door
		DrawBitmapPart(BitmapNamed('cells'), 200, 160, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * (x - 2)), (SQUARE_SIZE * y));		//Bottom Cell
		DrawBitmapPart(BitmapNamed('cells'), 160, 160, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * (x - 2)), (SQUARE_SIZE * (y - 1)));
		DrawBitmapPart(BitmapNamed('cells'), 160, 160, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * (x - 2)), (SQUARE_SIZE * (y - 2)));
		DrawBitmapPart(BitmapNamed('cells'), 200, 0, SQUARE_SIZE, (2 * SQUARE_SIZE), (SQUARE_SIZE * (x - 2)), (SQUARE_SIZE * (y - 4)));	//Top Cells
		//Outer Edge
		DrawBitmapPart(BitmapNamed('cells'), 160, 120, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * (x - 3)), (SQUARE_SIZE * y));		//Bottom Cell
		DrawBitmapPart(BitmapNamed('cells'), 160, 80, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * (x - 3)), (SQUARE_SIZE * (y - 1)));
		DrawBitmapPart(BitmapNamed('cells'), 160, 80, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * (x - 3)), (SQUARE_SIZE * (y - 2)));
		DrawBitmapPart(BitmapNamed('cells'), 160, 0, SQUARE_SIZE, (2 * SQUARE_SIZE), (SQUARE_SIZE * (x - 3)), (SQUARE_SIZE * (y - 4)));	//Top Cells
		
		//Draw Right side of building
		//Next to door
		DrawBitmapPart(BitmapNamed('cells'), 200, 160, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * (x + 1)), (SQUARE_SIZE * y));		//Bottom Cell
		DrawBitmapPart(BitmapNamed('cells'), 40, 0, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * (x + 1)), (SQUARE_SIZE * (y - 1)));
		DrawBitmapPart(BitmapNamed('cells'), 40, 0, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * (x + 1)), (SQUARE_SIZE * (y - 2)));
		DrawBitmapPart(BitmapNamed('cells'), 200, 0, SQUARE_SIZE, (2 * SQUARE_SIZE), (SQUARE_SIZE * (x + 1)), (SQUARE_SIZE * (y - 4)));   //Top Cells
		//between edges and next to door
		DrawBitmapPart(BitmapNamed('cells'), 200, 160, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * (x + 2)), (SQUARE_SIZE * y));		//Bottom Cell
		DrawBitmapPart(BitmapNamed('cells'), 160, 160, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * (x + 2)), (SQUARE_SIZE * (y - 1)));
		DrawBitmapPart(BitmapNamed('cells'), 160, 160, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * (x + 2)), (SQUARE_SIZE * (y - 2)));
		DrawBitmapPart(BitmapNamed('cells'), 200, 0, SQUARE_SIZE, (2 * SQUARE_SIZE), (SQUARE_SIZE * (x + 2)), (SQUARE_SIZE * (y - 4)));	//Top Cells
		//Outer Edge
		DrawBitmapPart(BitmapNamed('cells'), 240, 120, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * (x + 3)), (SQUARE_SIZE * y));	   //Bottom Cell
		DrawBitmapPart(BitmapNamed('cells'), 240, 80, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * (x + 3)), (SQUARE_SIZE * (y - 1)));
		DrawBitmapPart(BitmapNamed('cells'), 240, 80, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * (x + 3)), (SQUARE_SIZE * (y - 2)));
		DrawBitmapPart(BitmapNamed('cells'), 240, 0, SQUARE_SIZE, (2 * SQUARE_SIZE), (SQUARE_SIZE * (x + 3)), (SQUARE_SIZE * (y - 4)));  //Top Cells
	end;
end;

Procedure DrawStructures(const mapCells : mapCellArray); //Draws each cell of the structure.
var x, y : integer; 									 //What the cell will be depends on 
begin													 //its type, distance from the door
	for x := 0 to (MAP_SIZE div 2) do					 //and its neighbours
	begin
		for y := 0 to (MAP_SIZE div 2) do				 //Iterates through all cells in the 
		begin											 //outside biome
			if mapCells[x, y].cType = Door then
			begin
				if mapCells[x, y].dType = Building then
				begin
					DrawBuilding(mapCells, x, y); //Draws the symetrical buildings
				end;
			end else if mapCells[x, y].cType = Barrier then
			begin
				//Most code can be reused from forest drawing
				if mapCells[x, y].bType = Cave then
				begin
					if (mapCells[x, (y - 1)].cType = Barrier) 
					and ((mapCells[x, (y + 1)].cType = Barrier) or (mapCells[x, (y + 1)].cType = Door)) then 
					begin //cells above and below are cave
						DrawBitmapPart(BitmapNamed('cells'), 0, 120, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * x), (SQUARE_SIZE * y));
					end else if (mapCells[x, (y - 1)].cType <> Barrier) 
					and (mapCells[x, (y + 1)].cType <> Barrier) then
					begin //cells above and below aren't cave
						DrawBitmapPart(BitmapNamed('cells'), 40, 80, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * x), (SQUARE_SIZE * y));
					end else if (mapCells[x, (y - 1)].cType = Barrier) 
					and (mapCells[x, (y + 1)].cType <> Barrier) then
					begin //cell above is forest cell below not forest
						DrawBitmapPart(BitmapNamed('cells'), 40, 120, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * x), (SQUARE_SIZE * y));
					end else if (mapCells[x, (y - 1)].cType <> Barrier) 
					and (mapCells[x, (y + 1)].cType = Barrier) then
					begin //cell above not forest cell below forest
						DrawBitmapPart(BitmapNamed('cells'), 0, 80, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * x), (SQUARE_SIZE * y));
					end;
				end else if mapCells[x, y].bType = Forest then
				begin
					if (mapCells[x, (y - 1)].cType = Barrier) 
					and ((mapCells[x, (y + 1)].cType = Barrier) or (mapCells[x, (y + 1)].cType = Door)) then 
					begin //cells above and below are forest
						DrawBitmapPart(BitmapNamed('cells'), 80, 40, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * x), (SQUARE_SIZE * y));
					end else if (mapCells[x, (y - 1)].cType <> Barrier) 
					and (mapCells[x, (y + 1)].cType <> Barrier) then
					begin //cells above and below aren't forest
						DrawBitmapPart(BitmapNamed('cells'), 120, 0, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * x), (SQUARE_SIZE * y));
					end else if (mapCells[x, (y - 1)].cType = Barrier) 
					and (mapCells[x, (y + 1)].cType <> Barrier) then
					begin //cell above is forest cell below not forest
						DrawBitmapPart(BitmapNamed('cells'), 120, 40, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * x), (SQUARE_SIZE * y));
					end else if (mapCells[x, (y - 1)].cType <> Barrier) 
					and (mapCells[x, (y + 1)].cType = Barrier) then
					begin //cell above not forest cell below forest
						DrawBitmapPart(BitmapNamed('cells'), 80, 0, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * x), (SQUARE_SIZE * y));
					end;
				end;
			end;
		end;
	end;
end;

procedure DrawMap(const mapCells : mapCellArray; player : sprite; topX, topY : integer);
var x, y : integer;
begin
	ClearScreen(ColorBlack); //Nothingness is black
	for x := topX to (topX + 20) do //for x := 0 to MAP_SIZE do
	begin
		for y := topY to (topY + 20) do //for y := 0 to MAP_SIZE do
		begin
			if mapCells[x, y].biome = GrassBiome then //Draws the outside
			begin
				DrawBitmapPart(BitmapNamed('cells'), 0, 0, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * x), (SQUARE_SIZE * y)); //Grass
				if ((x = 0) and (y <= (MAP_SIZE div 2 + 1))) //Checks if a cell is on the edge of
				or ((y = 0) and (x <= (MAP_SIZE div 2 + 1))) //outside biome
				or ((x = (MAP_SIZE div 2 + 1)) and (y <= (MAP_SIZE div 2 + 1))) 
				or ((y = (MAP_SIZE div 2 + 1)) and (x <= (MAP_SIZE div 2 + 1))) then
				begin //ring of trees surrounding outside
					DrawBitmapPart(BitmapNamed('cells'), 120, 0, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * x), (SQUARE_SIZE * y));
				end;
									
				if mapCells[x, y].cType = Door then //Code to draw doors
				begin
					case mapCells[x, y].dType of //Draws Building Door and cave and forest cells that can have an opening
						Cave : DrawBitmapPart(BitmapNamed('cells'), 40, 120, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * x), (SQUARE_SIZE * y));
						Forest : DrawBitmapPart(BitmapNamed('cells'), 120, 40, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * x), (SQUARE_SIZE * y));
						Building : DrawBitmapPart(BitmapNamed('cells'), 200, 120, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * x), (SQUARE_SIZE * y));
						Grass : DrawBitmap(BitmapNamed('opening'), (SQUARE_SIZE * x), (SQUARE_SIZE * y));
					end; 
					if (mapCells[x, y].dType = Cave) //Draws opening in caves or forests
					or (mapCells[x, y].dType = Forest) then 
						DrawBitmapPart(BitmapNamed('cells'), 240, 160, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * x), (SQUARE_SIZE * y));
				end;
			{*******************************************
			 ***********DRAW INTERIORS CODE*************
			 *******************************************}
			end else if mapCells[x, y].biome = CaveBiome then //Draws interiors in interior biomes(caves/forests/buildings)
			begin											  //Cave
				DrawBitmapPart(BitmapNamed('cells'), 0, 40, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * x), (SQUARE_SIZE * y));
				if mapCells[x, y].cType = Door then DrawBitmap('opening', (SQUARE_SIZE * x), (SQUARE_SIZE * y));
				
			end else if mapCells[x, y].biome = ForestBiome then //Forest
			begin
				DrawBitmapPart(BitmapNamed('cells'), 40, 40, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * x), (SQUARE_SIZE * y));
				if mapCells[x, y].cType = Door then DrawBitmap('opening', (SQUARE_SIZE * x), (SQUARE_SIZE * y));
				
			end else if mapCells[x, y].biome = BuildingBiome then //Building
			begin
				DrawBitmapPart(BitmapNamed('cells'), 40, 0, SQUARE_SIZE, SQUARE_SIZE, (SQUARE_SIZE * x), (SQUARE_SIZE * y));
				if mapCells[x, y].cType = Door then DrawBitmap('opening', (SQUARE_SIZE * x), (SQUARE_SIZE * y));
			end;
				//END DRAW INTERIORS
		end;
	end;
	DrawStructures(mapCells); //Draws rest of Structures on top of grass around their door
	DrawGrid();
	DrawSprite(player );
	UpdateSprite(player);
	RefreshScreen();
end;

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
	DrawMap(mapCells, player, topX, topY);
end;

procedure LoadResources();
begin
	LoadFontNamed('arial', 'arial.ttf', 10);
	LoadBitmapNamed('cells', 'map.png');
	LoadBitmapNamed('opening', 'opening.png');
	LoadBitmapNamed('player', 'player.png');
end;

procedure Main();
var mapCells : mapCellArray;
	map0X, map0Y, topX, topY : Integer;
	player : sprite;
begin
	OpenGraphicsWindow('RPG Quest', 800, 800);//(SQUARE_SIZE * 20), (SQUARE_SIZE * 20));
	LoadDefaultColors();
	LoadResources();
	
	player := CreateSprite(BitmapNamed('player'));
	SpriteSetX(player ,40 );
    SpriteSetY(player ,40 );
	
	Randomize();
	topX := 0;
	topY := 0;
	//Initialize world
	SetBiome(mapCells, player, -1, -1);
	
	
	//DrawSprite(player );
	//UpdateSprite(player );
	
	map0X := 0;
	map0Y := 0;
	
	repeat
		ProcessEvents();
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
		end else if KeyTyped(vk_r) then //Generate new map
		begin
			SetBiome(mapCells, player, topX, topY);
		end;
		DrawMap(mapCells, player, topX, topY);
			//END CHANGE VIEW
	until WindowCloseRequested();

end;

begin
	Main();
end.
