draw_set_font( fnt_default );

var _triangles_count = array_length_1d( triangle_array );
var _edges_count     = array_length_1d( edge_array     );
var _nodes_count     = array_length_1d( node_array     );
var _borders_count   = array_length_1d( border_array   );

draw_set_colour( c_white );
draw_set_alpha( 0.4 );
for( var _t = 0; _t < _triangles_count; _t += e_triangle.size )
{
    draw_triangle( triangle_array[ e_triangle.x1 + _t ], triangle_array[ e_triangle.y1 + _t ],
                   triangle_array[ e_triangle.x2 + _t ], triangle_array[ e_triangle.y2 + _t ],
                   triangle_array[ e_triangle.x3 + _t ], triangle_array[ e_triangle.y3 + _t ], false );
}
draw_set_alpha( 1 );

draw_set_colour( c_white );
for( var _e = 0; _e < _edges_count; _e += e_edge.size )
{
	var _x1 = edge_array[ _e + e_edge.x1 ];
	var _y1 = edge_array[ _e + e_edge.y1 ];
	var _x2 = edge_array[ _e + e_edge.x2 ];
	var _y2 = edge_array[ _e + e_edge.y2 ];
	draw_line( _x1, _y1, _x2, _y2 );
	
	var _mx = 0.5*( _x1 + _x2 );
	var _my = 0.5*( _y1 + _y2 );
	draw_text( _mx, _my, "E" + string( _e ) );
}

draw_set_colour( c_gray );
for( var _p = 0; _p < _nodes_count; _p += e_node.size )
{
	var _inst   = node_array[ _p + e_node.inst   ];
	var _x      = node_array[ _p + e_node.x      ];
	var _y      = node_array[ _p + e_node.y      ];
	var _colour = node_array[ _p + e_node.colour ];
	
	if ( _inst.object_index == obj_perimeter_node ) continue;
	draw_set_colour( _colour );
	
	if ( point_distance( mouse_x, mouse_y, _x, _y ) < 50 )
	{
		var _node_edge_array = node_array[ _p + e_node.edges ];
		var _node_edges_count = array_length_1d( _node_edge_array );
		for( var _e = 0; _e < _node_edges_count; _e++ )
		{
			var _edge_id = _node_edge_array[ _e ];
		    var _x1 = edge_array[ _edge_id + e_edge.x1 ];
		    var _y1 = edge_array[ _edge_id + e_edge.y1 ];
		    var _x2 = edge_array[ _edge_id + e_edge.x2 ];
		    var _y2 = edge_array[ _edge_id + e_edge.y2 ];
			draw_line( _x1, _y1, _x2, _y2 );
			
			var _mx = 0.5*( _x1 + _x2 );
			var _my = 0.5*( _y1 + _y2 );
			draw_text( _mx, _my-20, string( _e ) + "=" + string( _edge_id ) );
		}
	}
	draw_text( _x + 10, _y - 20, "P" + string( _p ) );
    draw_circle( _x, _y, 20, false );
	draw_set_colour( c_white );
}

for( var _b = 0; _b < _borders_count; _b += e_border.size )
{
	var _path   = border_array[ _b + e_border.path   ];
	var _colour = border_array[ _b + e_border.colour ];
	
	draw_set_colour( _colour );
	var _path_nodes_count = path_get_number( _path );
	for( var _p = 0; _p < _path_nodes_count; _p++ )
	{
		var _p_next = (_p+1) mod _path_nodes_count;
		var _x1 = path_get_point_x( _path, _p      );
		var _y1 = path_get_point_y( _path, _p      );
		var _x2 = path_get_point_x( _path, _p_next );
		var _y2 = path_get_point_y( _path, _p_next );
		draw_line_width( _x1, _y1, _x2, _y2, 5 );
	}
}

draw_set_colour( c_white );
draw_text( 10, 10, "Delaunay algorithm implementation + Region maker\n2018/07/20\n\n@jujuadams\n\n"
                 + string( _triangles_count / e_triangle.size ) + " triangles\n"
				 + string( _edges_count / e_edge.size ) + " edges\n"
				 + string( _borders_count / e_border.size ) + " borders" );