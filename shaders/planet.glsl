extern number rand;

//varying vec4 vpos;

#ifdef VERTEX
vec4 position( mat4 transform_projection, vec4 vertex_position )
{
	//vpos = vertex_position;
	
	return transform_projection * vertex_position;
}
#endif

#ifdef PIXEL
vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    vec4 texcolor = Texel(texture, texture_coords);
	
	//texcolor.r = 0;
	//texcolor.g = 0;
	//texcolor.b = 0;
	
    //return texcolor;// * color;
	
	
	texcolor.r = rand*texture_coords.x;
	
	return texcolor * color;
}
#endif