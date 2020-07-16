use <GDMUtils.scad>


psu_width = 50;
psu_height = 112;
psu_back_length = 130;
display_ofs = 30;

top_joiner_height = 20;


module clipped_narrowing_strut(w=10, l=100, wall=5, ang=30, target_wall=3) {
     h = (w - target_wall) / tan(ang) / 2;
     cube_h = h + w;
     difference() {
	  narrowing_strut(w=w, l=l, wall=wall, ang=ang);
     
	  up(wall+h)
	  up(cube_h/2)
	       cube(size=[w, l+0.1, cube_h], center=true);
     }
}
