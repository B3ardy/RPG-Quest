unit TypeDec;

interface

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
	
implementation

end.