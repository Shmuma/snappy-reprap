include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>
include <psu_common.scad>


joiner_length = 10;
joiner_x_distance = 50;
joiner_y_distance = 40;
bot_wall_thick = 5;
wall_thick = 3;
psu_ramps_height = 45;
psu_ramps_length = 130;
psu_ramps_width = 65;


module psu_ramps_module() {
     psu_outer_hwidth = (psu_width + joiner_width)/2;
     joiner_x_ofs = (joiner_x_distance + joiner_width)/2;
     joiner_y_ofs = (joiner_y_distance + top_joiner_height)/2;
     joiner_z_ofs = joiner_length-bot_wall_thick;
     base_x_size = psu_ramps_width+joiner_width;//joiner_x_distance + joiner_width*2;
     base_y_size = psu_ramps_length + wall_thick;
/*
	       translate([-joiner_x_ofs, -joiner_y_ofs, joiner_z_ofs])
		    xrot(-90) back(joiner_width)
		    half_joiner_clear(h=top_joiner_height, w=joiner_width,
				l=joiner_length);
	       translate([joiner_x_ofs, -joiner_y_ofs, joiner_z_ofs])
		    xrot(-90) back(joiner_width)
		    half_joiner_clear(h=top_joiner_height, w=joiner_width,
				 l=joiner_length);
	       translate([-joiner_x_ofs, joiner_y_ofs, joiner_z_ofs])
		    xrot(-90) back(joiner_width)
		    half_joiner_clear(h=top_joiner_height, w=joiner_width,
				 l=joiner_length);
	       translate([joiner_x_ofs, joiner_y_ofs, joiner_z_ofs])
		    xrot(-90) back(joiner_width)
		    half_joiner_clear(h=top_joiner_height, w=joiner_width,
				l=joiner_length);
*/     

     difference() {
	  union() {
	       // bottom joiner
	       translate([-joiner_x_ofs, -joiner_y_ofs, joiner_z_ofs])
		    xrot(-90) back(joiner_width)
		    half_joiner(h=top_joiner_height, w=joiner_width,
				l=joiner_length);
	       translate([joiner_x_ofs, -joiner_y_ofs, joiner_z_ofs])
		    xrot(-90) back(joiner_width)
		    half_joiner2(h=top_joiner_height, w=joiner_width,
				 l=joiner_length);
	       translate([-joiner_x_ofs, joiner_y_ofs, joiner_z_ofs])
		    xrot(-90) back(joiner_width)
		    half_joiner2(h=top_joiner_height, w=joiner_width,
				 l=joiner_length);
	       translate([joiner_x_ofs, joiner_y_ofs, joiner_z_ofs])
		    xrot(-90) back(joiner_width)
		    half_joiner(h=top_joiner_height, w=joiner_width,
				l=joiner_length);
	       // bottom wall
	       difference() {
		    down(bot_wall_thick/2)
			 cube(size=[base_x_size, base_y_size, bot_wall_thick+0.1], center=true);
		    union() {
			 // bottom joiner
			 translate([-joiner_x_ofs, -joiner_y_ofs, joiner_z_ofs])
			      xrot(-90) back(joiner_width)
			      half_joiner_clear(h=top_joiner_height, w=joiner_width);
			 translate([joiner_x_ofs, -joiner_y_ofs, joiner_z_ofs])
			      xrot(-90) back(joiner_width)
			      half_joiner_clear(h=top_joiner_height, w=joiner_width);
			 translate([-joiner_x_ofs, joiner_y_ofs, joiner_z_ofs])
			      xrot(-90) back(joiner_width)
			      half_joiner_clear(h=top_joiner_height, w=joiner_width);
			 translate([joiner_x_ofs, joiner_y_ofs, joiner_z_ofs])
			      xrot(-90) back(joiner_width)
			      half_joiner_clear(h=top_joiner_height, w=joiner_width);
		    }
	       }
	  }
	  // cut joiners from top
	  up(bot_wall_thick*10/2)
	       cube(size=[base_x_size + 0.1, base_y_size + 0.1, bot_wall_thick*10], center=true);
     }

     // front wall
     translate([0, -(base_y_size-wall_thick)/2, psu_ramps_height/2])
	  xrot(90)
	  cube(size=[base_x_size, psu_ramps_height, wall_thick], center=true);

     difference() {
	  union() {
	       // left wall
	       translate([-(base_x_size - joiner_width)/2, 0, psu_ramps_height/2])
		    sparse_strut(h=psu_ramps_height, l=base_y_size, thick=wall_thick, strut=5, max_bridge=20, maxang=45);
	       // right wall
	       translate([(base_x_size - joiner_width)/2, 0, psu_ramps_height/2])
		    sparse_strut(h=psu_ramps_height, l=base_y_size, thick=wall_thick, strut=5, max_bridge=20, maxang=45);

	       // top narrowings
	       translate([(base_x_size - joiner_width)/2, wall_thick/2, psu_ramps_height])
		    zflip()
		    clipped_narrowing_strut(w=joiner_width, l=psu_ramps_length, wall=bot_wall_thick, target_wall=wall_thick);

	       translate([-(base_x_size - joiner_width)/2, wall_thick/2, psu_ramps_height])
		    zflip()
		    clipped_narrowing_strut(w=joiner_width, l=psu_ramps_length, wall=bot_wall_thick, target_wall=wall_thick);
	  }
	  union() {
	       translate([(base_x_size - joiner_width)/2, -joiner_y_ofs, psu_ramps_height-joiner_width])
		    xrot(90) back(joiner_width)
		    half_joiner_clear(h=top_joiner_height, w=joiner_width);
	       translate([-(base_x_size - joiner_width)/2, -joiner_y_ofs, psu_ramps_height-joiner_width])
		    xrot(90) back(joiner_width)
		    half_joiner_clear(h=top_joiner_height, w=joiner_width);
	       translate([(base_x_size - joiner_width)/2, joiner_y_ofs, psu_ramps_height-joiner_width])
		    xrot(90) back(joiner_width)
		    half_joiner_clear(h=top_joiner_height, w=joiner_width);
	       translate([-(base_x_size - joiner_width)/2, joiner_y_ofs, psu_ramps_height-joiner_width])
		    xrot(90) back(joiner_width)
		    half_joiner_clear(h=top_joiner_height, w=joiner_width);
	  }
     }
     difference() {
	  union() {
	       // top joiners
	       translate([-(base_x_size - joiner_width)/2, -joiner_y_ofs, psu_ramps_height-joiner_width])
		    xrot(90) back(joiner_width)
		    half_joiner2(h=top_joiner_height, w=joiner_width,
				 l=joiner_length);		      
	       translate([(base_x_size - joiner_width)/2, -joiner_y_ofs, psu_ramps_height-joiner_width])
		    xrot(90) back(joiner_width)
		    half_joiner(h=top_joiner_height, w=joiner_width,
				l=joiner_length);
	       translate([-(base_x_size - joiner_width)/2, joiner_y_ofs, psu_ramps_height-joiner_width])
		    xrot(90) back(joiner_width)
		    half_joiner(h=top_joiner_height, w=joiner_width,
				l=joiner_length);
	       translate([(base_x_size - joiner_width)/2, joiner_y_ofs, psu_ramps_height-joiner_width])
		    xrot(90) back(joiner_width)
		    half_joiner2(h=top_joiner_height, w=joiner_width,
				 l=joiner_length);
	  }
	  up(psu_ramps_height-wall_thick*10/2-bot_wall_thick)
	       cube(size=[base_x_size+0.1, base_y_size/1.5, wall_thick*10], center=true);     
     }

}


module psu_ramps() {
     up((psu_ramps_length+wall_thick)/2)
     xrot(90)
     psu_ramps_module();
}


psu_ramps();
