const number pi = 3.14159265;
const number pi2 = 2.0 * pi;

extern number time;
extern number resolution = 1;

extern number width = 1;
extern number height = 1;
			  
vec4 effect(vec4 color, Image texture, vec2 tc, vec2 pixel_coords)
{
   vec2 p = 2.0 * (tc - 0.5);
   
   number r = sqrt(p.x*width*p.x + p.y*height*p.y);

   if (r > 1.0) discard;
   
   number d = r != 0.0 ? asin(r) / r : 0.0;
			
   vec2 p2 = d * p * resolution;
   
   number x3 = mod(p2.x / (pi2) + 0.5 + time/8, 1.0);
   number y3 = p2.y / (pi2) + 0.5;
   
   vec2 newCoord = vec2(x3, y3);
   
   vec4 sphereColor = color * Texel(texture, newCoord);
			
   return sphereColor;
}