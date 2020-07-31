include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>
include <psu_common.scad>


module psu_plug() {
     joiner_length = 10;
     plug_length = 40;
     plug_height = 70;
     filler_height = plug_height - rail_height;
     wall_thick = 3;
     hole_side = 10;

     socket_length = 49;
     socket_width = 29;
     socket_hole_d = 3;
     socket_hole_ofs = 6;

     up(plug_length) xrot(90) {
	  // connector
	  up(rail_height/2)
	       joiner_pair(spacing=platform_length/2, h=rail_height,
			   w=joiner_width, l=joiner_length, a=joiner_angle);
	  // fillers
	  translate([platform_length/4, -joiner_length/2, rail_height + filler_height/2])
	       cube([joiner_width, joiner_length, filler_height], center=true);
	  translate([-platform_length/4, -joiner_length/2, rail_height + filler_height/2])
	       cube([joiner_width, joiner_length, filler_height], center=true);
	  
	  // narrowings
	  translate([platform_length/4, -joiner_length, plug_height/2])
	       xrot(90)
	       clipped_narrowing_strut(w=joiner_width, l=plug_height,
				       wall=wall_thick, target_wall=wall_thick);
	  translate([-platform_length/4, -joiner_length, plug_height/2])
	       xrot(90)
	       clipped_narrowing_strut(w=joiner_width, l=plug_height,
				       wall=wall_thick, target_wall=wall_thick);

	  difference() {
	       union() {
		    // floor
		    translate([0, -plug_length/2, wall_thick/2])
			 cube([platform_length/2 + joiner_width,
			       plug_length, wall_thick], center=true);
		    // top
		    translate([0, -plug_length/2, plug_height - wall_thick/2])
			 cube([platform_length/2 + joiner_width,
			       plug_length, wall_thick], center=true);
		    // left wall
		    translate([-platform_length/4, -plug_length/2, plug_height/2])
			 cube([wall_thick, plug_length, plug_height], center=true);
		    // right wall
		    translate([platform_length/4, -plug_length/2, plug_height/2])
			 cube([wall_thick, plug_length, plug_height], center=true);
		    // back wall
		    translate([0, -plug_length + wall_thick/2, plug_height/2])
			 cube([platform_length/2 + joiner_width, wall_thick, plug_height],
			      center=true);
	       }
	       up(rail_height/2)
		    joiner_pair_clear(spacing=platform_length/2, h=rail_height,
				      w=joiner_width, a=joiner_angle);
	       // hole for the wires
	       translate([platform_length/4, -plug_length + hole_side,
			  hole_side/2 + wall_thick])
		    cube([wall_thick+1, hole_side, hole_side], center=true);
	       // hole for the plug
	       translate([0, -plug_length+wall_thick/2, plug_height/2])
		    cube([socket_width, wall_thick+1, socket_length], center=true);
	       // screw holes
	       translate([socket_width/2+socket_hole_ofs, -plug_length+wall_thick/2,
			  plug_height/2])
		    xrot(90)
		    cylinder(h=wall_thick+1, d=socket_hole_d, $fn=20, center=true);
	       translate([-socket_width/2-socket_hole_ofs, -plug_length+wall_thick/2,
			  plug_height/2])
		    xrot(90)
		    cylinder(h=wall_thick+1, d=socket_hole_d, $fn=20, center=true);
	  }
     }
}

psu_plug();
