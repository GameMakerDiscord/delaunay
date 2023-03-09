//If we're in the large example room, load in some nodes from a CSV file
if ( room == rm_large )
{
    /*
	var _width  = room_width*.5-300;
	var _height = room_height*.5-300;
	var _cx     = room_width*.5;
	var _cy     = room_height*.5;

	for( var _angle = 0; _angle < 360; _angle += 15 )
	{
	    instance_create_depth( _cx + lengthdir_x( _width, _angle ), _cy + lengthdir_y( _height, _angle ), 0, obj_perimeter_node ); 
	}
	*/
	var _grid = load_csv( "debug(1).txt" );
	var _height = ds_grid_height( _grid );
	for( var _y = 0; _y < _height; _y++ )
	{
		var _star_x = real( _grid[# 1, _y ] );
		var _star_y = real( _grid[# 2, _y ] );
		var _star_f = real( _grid[# 3, _y ] );
        if ( _grid[# 0, _y ] == "star" ) {
    		var _inst = instance_create_depth( _star_x, _star_y, 0, obj_node );
    		_inst.image_blend = make_colour_hsv( _star_f*255/8, 255, 255 );
        } else {
            instance_create_depth( _star_x, _star_y, 0, obj_perimeter_node );
        }
	}
}

//Create a couple of vertex formats that'll get used later
vertex_format_begin();
vertex_format_add_position();
vertex_format_add_color();
global.vft_2d_region = vertex_format_end();

vertex_format_begin();
vertex_format_add_position();
vertex_format_add_normal();
vertex_format_add_texcoord();
global.vft_2d_boundary = vertex_format_end();

//Run over all nodes in the room and drop their coordinates into an array
node_array = array_create( 0 );
node_lookup_map = ds_map_create();
nodes_make_from_object( node_array, node_lookup_map, obj_node );

//Run the Delaunay triangulation algorithm
triangle_array = array_create( 0 );
delaunay_bowyer_watson( node_array, triangle_array,   0, 0, room_width, room_height,   true );

//Collect an array of unique edges (and also build a lookup table for them)
edge_array = array_create( 0 );
edge_lookup_map = ds_map_create();
triangulation_find_unique_edges( triangle_array, edge_array, edge_lookup_map );

//Build a map of nodes coordinates, and for each node create a list of edges that connect to it
node_to_edge_map = ds_map_create(); //Will contain nested lists
edges_associate_nodes( edge_array, node_to_edge_map );

//Add an array of edges to each node
nodes_assign_edges( node_array, node_to_edge_map );

//Order each node's edges in a counterclockwise order
nodes_sort_edges( node_array, edge_array );

//Make borders around each set of nodes
border_array = array_create( 0 );
borders_make( border_array, node_array, edge_array, node_lookup_map, 10 );

//Angular borders might be ok for some people, but over here at Grumpy Pug Industries, we demand loose curves
borders_smooth( border_array, 5, 0.8 );

//Now generate the vertex buffers for the boundary and the region itself
borders_make_boundary_vertex_buffer( border_array );
borders_make_region_vertex_buffer( border_array );