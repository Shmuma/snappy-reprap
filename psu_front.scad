include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>

psu_width = 50;
psu_height = 112;
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


module psu_front() {
    joiner_length = 10;
    joiner_height = (psu_height + platform_thick)/2;
    
    wall_thick = 3;
    y_joiner_spacing = psu_width+joiner_width;
    psu_front_length = rail_width/2 + display_ofs + wall_thick;
    psu_front_width = psu_width+joiner_width*2;
    base_y_ofs = psu_front_length/2 - rail_width/2;
    
    // left connectors to the back part of PSU
    translate([0, rail_width/2, joiner_height/2]) {
	 joiner_pair(spacing=y_joiner_spacing, h=joiner_height, w=joiner_width, l=joiner_length, a=joiner_angle);
    }
    translate([0, rail_width/2, joiner_height*3/2]) {
	 joiner_pair(spacing=y_joiner_spacing, h=joiner_height, w=joiner_width, l=joiner_length, a=joiner_angle);
    }

    // back connector to the main rail
    translate([(psu_width + joiner_length - wall_thick)/2, 0, rail_height/2]) {
	 zrot(-90)    
	 back(joiner_length)
	 joiner(h=rail_height, w=joiner_width, l=joiner_length, a=joiner_angle);
    }

    // test top joiner
    
    difference() {
	 union() {
	      // back wall
	      translate([(psu_width + joiner_width)/2, -base_y_ofs, (psu_height + platform_thick)/2]) {
		   sparse_strut(h=psu_height + platform_thick, l=psu_front_length, thick=wall_thick, strut=10, max_bridge=20, maxang=45);
		   // top narrowing
		   up((psu_height + platform_thick)/2)
			zflip()
			clipped_narrowing_strut(w=joiner_width, l=psu_front_length, wall=wall_thick, target_wall=wall_thick);
		   // bot narrowing
		   down(psu_height/2)
			clipped_narrowing_strut(w=joiner_width, l=psu_front_length, wall=wall_thick, target_wall=wall_thick);
	      }

	      // front wall
	      translate([-(psu_width + joiner_width)/2, -base_y_ofs, (psu_height + platform_thick)/2]) {
		   sparse_strut(h=psu_height + platform_thick, l=psu_front_length, thick=wall_thick, strut=10, max_bridge=20, maxang=45);
		   // top narrowing
		   up((psu_height + platform_thick)/2)
			zflip()
			clipped_narrowing_strut(w=joiner_width, l=psu_front_length, wall=wall_thick, target_wall=wall_thick);
		   // bot narrowing
		   down(psu_height/2)
			clipped_narrowing_strut(w=joiner_width, l=psu_front_length, wall=wall_thick, target_wall=wall_thick);

	      }


	      // right wall
	      translate ([0, -(display_ofs+wall_thick), (psu_height + platform_thick)/2]) {
		   zrot(90)
			sparse_strut(h=psu_height + platform_thick, l=psu_front_width, thick=wall_thick, strut=10, max_bridge=20, maxang=45);
	      }
    
    
	      // bottom wall
	      up(platform_thick/2) {
		   ymove(-base_y_ofs) {
			yrot(90) 
			     sparse_strut(h=psu_front_width, l=psu_front_length, thick=platform_thick, maxang=45, strut=10, max_bridge=500);
		   }
	      }


	      translate([0, rail_width/4, psu_height + platform_thick]) {
		   // top back joiner
		   right((psu_width + joiner_width)/2)
			xrot(90)
			back(joiner_width)
			half_joiner(h=top_joiner_height, w=joiner_width, l=joiner_length);
		   // top front joiner
		   left((psu_width + joiner_width)/2)
			xrot(90)
			back(joiner_width)
			half_joiner2(h=top_joiner_height, w=joiner_width, l=joiner_length);
	      }
	 }
	 // remove joiner clearing
	 translate([0, rail_width/2, joiner_height/2]) {
	      joiner_pair_clear(spacing=y_joiner_spacing, h=joiner_height, w=joiner_width, a=joiner_angle);
	 }
	 translate([0, rail_width/2, joiner_height*3/2]) {
	      joiner_pair_clear(spacing=y_joiner_spacing, h=joiner_height, w=joiner_width, a=joiner_angle);
	 }
    }
}

psu_front();
