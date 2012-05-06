unit DrawWorld;

interface

uses SwinGame, sgTypes, TypeDec;

procedure DrawBuilding(const mapCells : mapCellArray; x, y : integer);
Procedure DrawStructures(const mapCells : mapCellArray);
procedure DrawMap(const mapCells : mapCellArray; player : sprite; topX, topY : integer);

implementation

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
	for x := topX to (topX + 20) do //Draws only whats on screen
	begin
		for y := topY to (topY + 20) do
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
	//DrawGrid();
	DrawSprite(player );
	UpdateSprite(player);
	DrawFramerate(SQUARE_SIZE, SQUARE_SIZE);
	RefreshScreen();
end;

end.