include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>
include <psu_common.scad>


module psu_back() {
    joiner_length = 10;
    joiner_height = (psu_height + platform_thick)/2;
    // length of space near PSU contacts
    contacts_length = 30;
    
    wall_thick = 3;
    y_joiner_spacing = psu_width+joiner_width;
    psu_back_base_length = psu_back_length + wall_thick;
    psu_base_width = psu_width+joiner_width*2;

    psu_outer_hwidth = (psu_width + joiner_width)/2;
    psu_outer_height = psu_height + platform_thick;
    psu_outer_hheight = psu_outer_height/2;
	 

    // connectors to the front part of PSU
    up(joiner_height/2) {
	 yflip() zflip()
	 joiner_pair(spacing=y_joiner_spacing, h=joiner_height, w=joiner_width, l=joiner_length, a=joiner_angle);
    }
    up(joiner_height*3/2) {
	 yflip() zflip()
	 joiner_pair(spacing=y_joiner_spacing, h=joiner_height, w=joiner_width, l=joiner_length, a=joiner_angle);
    }

    // back connector to the main rail
    translate([(psu_width + joiner_length - wall_thick)/2, rail_width/2, rail_height/2]) {
	 zrot(-90)    
	 back(joiner_length)
	 joiner(h=rail_height, w=joiner_width, l=joiner_length, a=joiner_angle);
    }

    difference() {
	 union() {
	      // back wall
	      translate([psu_outer_hwidth, psu_back_base_length/2, psu_outer_hheight]) {
		   fwd(contacts_length/2)
		   sparse_strut(h=psu_outer_height, l=psu_back_base_length-contacts_length, thick=wall_thick, strut=10, max_bridge=20, maxang=45);
		   // top narrowing
		   up((psu_height + platform_thick)/2)
			zflip()
			clipped_narrowing_strut(w=joiner_width, l=psu_back_base_length, wall=wall_thick, target_wall=wall_thick);
		   // bot narrowing
		   down(psu_height/2)
			clipped_narrowing_strut(w=joiner_width, l=psu_back_base_length, wall=wall_thick, target_wall=wall_thick);
	      }

	      // contacts wall
	      translate([psu_outer_hwidth, (psu_back_base_length - contacts_length/2), psu_outer_hheight])
	      sparse_strut(h=psu_outer_height, l=contacts_length, thick=wall_thick, strut=7);

	      // front wall
	      translate([-psu_outer_hwidth, psu_back_base_length/2, psu_outer_hheight]) {
		   sparse_strut(h=psu_outer_height, l=psu_back_base_length, thick=wall_thick, strut=10, max_bridge=20, maxang=45);
		   // top narrowing
		   up(psu_outer_hheight)
			zflip()
			clipped_narrowing_strut(w=joiner_width, l=psu_back_base_length, wall=wall_thick, target_wall=wall_thick);
		   // bot narrowing
		   down(psu_height/2)
			clipped_narrowing_strut(w=joiner_width, l=psu_back_base_length, wall=wall_thick, target_wall=wall_thick);

	      }

	      // left wall
	      translate ([0, psu_back_base_length-wall_thick/2, psu_outer_hheight]) {
		   cube(size=[psu_base_width, wall_thick, psu_outer_height], center=true);
	      }


	      // bottom wall
	      up(platform_thick/2) {
		   back(psu_back_base_length/2)
			yrot(90) 
			sparse_strut(h=psu_base_width, l=psu_back_base_length, thick=platform_thick, maxang=45, strut=10, max_bridge=500);
	      }

	      translate([0, rail_width/4, psu_outer_height]) {
		   // top back joiner
		   right(psu_outer_hwidth)
			xrot(90)
			back(joiner_width)
			half_joiner2(h=top_joiner_height, w=joiner_width, l=joiner_length);
		   // top front joiner
		   left(psu_outer_hwidth)
			xrot(90)
			back(joiner_width)
			half_joiner(h=top_joiner_height, w=joiner_width, l=joiner_length);
	      }
	 }
	 
	 // remove joiner clearing
	 up(joiner_height/2) {
	      joiner_pair_clear(spacing=y_joiner_spacing, h=joiner_height, w=joiner_width, a=joiner_angle);
	 }
	 up(joiner_height*3/2) {
	      joiner_pair_clear(spacing=y_joiner_spacing, h=joiner_height, w=joiner_width, a=joiner_angle);
	 }
    }

}

psu_back();
