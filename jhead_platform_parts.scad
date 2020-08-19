include <config.scad>
use <GDMUtils.scad>
use <NEMA.scad>
use <acme_screw.scad>
use <joiners.scad>


$fa = 2;
$fs = 1;


module jhead_platform()
{
	side_joiner_len = 5.01;
	platform_vert_off = rail_height+groove_height+rail_offset;
	l = extruder_length;
	w = rail_width-20;
	h = rail_height;
	thick = jhead_groove_thick;
	motor_width = nema_motor_width(17);
	idler_backside = (jhead_barrel_diam+8)/2+8;
	idler_back_thick = 3.5;

	color("SteelBlue")
	prerender(convexity=10)
	zrot(-90)
	union() {
		difference() {
			union() {
				difference() {
					union() {
						up(thick/2) {
							difference() {
								// Bottom.
								cube(size=[w, l-7.1, thick], center=true);

								// chamfer corners of base
								xspread(w) {
									yspread(l-6.1) {
										chamfer_mask_z(l=rail_height*2, chamfer=joiner_width/3);
									}
								}
							}
						}

						// Center bracing
						difference() {
							upcube([w-platform_thick, adjust_screw_diam+2*2, rail_height/2-5]);
							xspread(w-platform_thick-2*2-18) {
								up(jhead_shelf_thick+jhead_groove_thick) {
									upcube([18, adjust_screw_diam+2*2+1, 7]);
								}
							}
						}

						// Walls.
						up((rail_height/2-5)/2-0.005) {
							xspread(w-platform_thick) {
								thinning_wall(h=rail_height/2-5-0.01, l=[l-15, l-12], thick=platform_thick, strut=5);
							}
						}

						// Joiner backing
						block_w = (w + joiner_width - z_joiner_spacing)/2;
						up(rail_height/2) {
							xflip_copy() {
								yflip_copy() {
									fwd((extruder_length-platform_thick)/2) {
										right((w-block_w)/2) {
											skew_xy(yang=-bridge_arch_angle) {
												difference() {
													cube(size=[block_w-0.1, platform_thick, rail_height], center=true);
													left(block_w/2) back(platform_thick/2) chamfer_mask_z(l=rail_height*2, chamfer=platform_thick/2);
													right(block_w/2) fwd(platform_thick/2) chamfer_mask_z(l=rail_height*2, chamfer=platform_thick/2);
												}
											}
										}
									}
								}
							}
						}

						// Joiner bracing triangles
						tri_w = platform_thick;
						tri_h = rail_height - (rail_height/2-5);
						up(rail_height/2-5-0.05) {
							xflip_copy() {
								yflip_copy() {
									fwd((extruder_length-joiner_width)/2) {
										right((w-tri_w)/2) {
											skew_xy(yang=-bridge_arch_angle) {
												zrot(90) {
													right_half() {
														trapezoid([tri_h*2, tri_w], [0.1, tri_w], h=tri_h, center=false);
													}
												}
											}
										}
									}
								}
							}
						}

						// Jhead base
						fwd(extruder_shaft_len/4/2) {
							up((jhead_shelf_thick+jhead_groove_thick)/2) {
								cube([w-platform_thick, extruder_shaft_len*0.75, jhead_shelf_thick+jhead_groove_thick], center=true);
							}
							up(jhead_shelf_thick+jhead_groove_thick) {
								up(motor_width*0.37/2) {
									cube([jhead_barrel_diam+8, extruder_shaft_len*0.75, motor_width*0.37], center=true);
								}
							}
						}

						// Lower idler mount blocks
						up(jhead_groove_thick+jhead_shelf_thick) {
							xspread(jhead_barrel_diam+8+9+5) {
								up(12/2-0.05) {
									fwd(2/2) {
										cube([20, extruder_shaft_len/2+2, 12], center=true);
									}
								}
							}
						}

						// Adjuster screw block
						up(motor_width/2+adjust_screw_diam/2-5) {
							left(32) {
								difference() {
									cube([15, adjust_screw_diam+2*2, motor_width/2+adjust_screw_diam+3], center=true);
									up(motor_width/2/2) {
										yrot(90) {
											acme_threaded_rod(d=adjust_screw_diam+2*printer_slop, l=15+0.1, thread_depth=adjust_thread_depth, pitch=adjust_screw_pitch, thread_angle=adjust_screw_angle);
											left((adjust_screw_diam+2*printer_slop)/2/2) {
												cube(size=[(adjust_screw_diam+2*printer_slop)/2, adjust_screw_diam/2, 15+0.1], center=true);
											}
										}
									}
								}
							}
						}

						// Motor face plate.
						fwd(extruder_shaft_len/2-2/2) {
							right(extruder_drive_diam/2-0.5) {
								up(thick+jhead_shelf_thick+motor_width/2/2) {
									cube([motor_width, 2, motor_width/2], center=true);
								}
							}
						}

						// Motor supports
						fwd(motor_length/2+extruder_shaft_len/2) {
							right(extruder_drive_diam/2-0.5) {
								xspread(motor_width-5) {
									yspread(rail_height-15) {
										upcube([20, 15, 20]);
									}
								}
							}
						}
					}

					// Clear motor and extruder parts
					up(jhead_groove_thick+jhead_shelf_thick) {
						up(motor_width/2) {
							left(0.5) {
								right(extruder_drive_diam/2) {
									xrot(90) cylinder(h=extruder_shaft_len+1, d=extruder_drive_diam+1, center=true);
									fwd(extruder_shaft_len/2) {
										xrot(90) nema17_mount_holes(depth=2*2+0.05, l=0);
										fwd(motor_length/2) {
											cube([motor_width, motor_length, motor_width], center=true);
										}
									}
								}
								left(extruder_idler_diam/2) {
									back(1) {
										xrot(90) cylinder(h=extruder_shaft_len-2+0.05, d=extruder_idler_diam+2, center=true);
										left((extruder_idler_diam+2)/2) {
											cube([extruder_idler_diam+2, extruder_shaft_len-2+0.05, extruder_idler_diam+2], center=true);
										}
									}
								}
							}
						}
						up(jhead_cap_height+2*printer_slop) {
							cube([jhead_barrel_diam, filament_diam+4*printer_slop, 0.6], center=true);
							up(0.3) {
								cube([filament_diam+4*printer_slop, filament_diam+4*printer_slop, 0.6], center=true);
							}
						}
					}

					// Motor cooling convection hole.
					fwd(motor_width/2+extruder_shaft_len/2) {
						right(extruder_drive_diam/2-0.5) {
							cylinder(d=motor_width*0.85, h=thick*10, center=true);
						}
					}

					// Filament feed
					cylinder(d=filament_diam+4*printer_slop, h=100, center=true, $fn=12);
					up(jhead_groove_thick+jhead_shelf_thick+motor_width*0.37-1+0.05) {
						cylinder(d1=filament_diam+4*printer_slop, d2=filament_diam*3, h=2, center=true, $fn=12);
					}

					// Jhead groove slot
					up(jhead_groove_thick/2) {
						back(extruder_length/4/2) {
							yspread(extruder_length/4) {
								cylinder(h=jhead_groove_thick+0.1, d=jhead_groove_diam+printer_slop, center=true);
							}
							cube([jhead_groove_diam+printer_slop, extruder_length/4, jhead_groove_thick+0.1], center=true);
						}
					}

					// Jhead shelf slot
					up(jhead_groove_thick) {
						up((jhead_shelf_thick+jhead_cap_height+2*printer_slop)/2) {
							back(extruder_length/4/2) {
								yspread(extruder_length/4) {
									cylinder(h=jhead_shelf_thick+jhead_cap_height+2*printer_slop+0.1, d=jhead_barrel_diam+printer_slop, center=true);
								}
								cube([jhead_barrel_diam+printer_slop, extruder_length/4, jhead_shelf_thick+jhead_cap_height+2*printer_slop+0.1], center=true);
							}
						}
					}

					up((jhead_shelf_thick+jhead_groove_thick)/2) {
						// Extruder fan hole.
						back(extruder_length/4) {
							cylinder(h=jhead_shelf_thick+jhead_groove_thick+1, d=extruder_fan_size+2*printer_slop+2*2, center=true);
						}

						// Wire access slot
						back(extruder_length/4-extruder_fan_size/2+8/2) {
							xspread(extruder_fan_size+2*joiner_width) {
								cylinder(h=jhead_shelf_thick+jhead_groove_thick+1, d=8, center=true);
							}
							cube([extruder_fan_size+2*joiner_width, 8, jhead_shelf_thick+jhead_groove_thick+1], center=true);
						}
					}

					// Bottom idler holder
					up(jhead_groove_thick+idler_back_thick+printer_slop/2) {
						left(idler_backside-idler_back_thick) {
							intersection() {
								yrot_copies([0,-98]) {
									teardrop(r=idler_back_thick+printer_slop/2, h=extruder_shaft_len/2+printer_slop, ang=40, $fs=1);
								}
								up(idler_back_thick) {
									cube([2*idler_back_thick+printer_slop, extruder_shaft_len/2+printer_slop, 4*idler_back_thick+printer_slop], center=true);
								}
							}
							down(idler_back_thick/3) {
								yrot_copies([0,-8]) {
									left((idler_back_thick+printer_slop/2)/2) {
										up(50/2) {
											cube([idler_back_thick+printer_slop/2, extruder_shaft_len/2+printer_slop, 50], center=true);
										}
									}
								}
							}
						}
					}

					// Clear space for joiners.
					zrot_copies([0, 180]) {
						back(l/2) {
							xrot(-bridge_arch_angle) {
								up(rail_height/2+0.05) {
									joiner_pair_clear(spacing=z_joiner_spacing, h=h, w=joiner_width, clearance=1, a=joiner_angle);
								}
							}
						}
					}
				}

				// Rail end joiners.
				zrot_copies([0, 180]) {
					back(l/2+0.11) {
						top_half() {
							xrot(-bridge_arch_angle) {
								up(rail_height/2) {
									joiner_pair(spacing=z_joiner_spacing, h=h, w=joiner_width, l=7, a=joiner_angle);
								}
								down(joiner_width/2) {
									xspread(z_joiner_spacing) {
										fwd(joiner_width/2) cube(joiner_width, center=true);
									}
								}
							}
						}
					}
				}

				// Motor joiner clips
				right(extruder_drive_diam/2-0.5) {
					fwd(extruder_shaft_len/2+motor_length/2) {
						difference() {
							up(jhead_groove_thick+jhead_shelf_thick+motor_width/2) {
								difference() {
									xrot(90) joiner_pair(spacing=motor_mount_spacing, h=rail_height, w=joiner_width, l=motor_width/2+jhead_shelf_thick+platform_thick/2, a=joiner_angle);
									yspread(rail_height) {
										xspread(motor_mount_spacing+joiner_width) {
											chamfer_mask_z(l=rail_height*2, chamfer=joiner_width/3);
										}
									}
								}
							}
							cube([motor_mount_spacing+joiner_width+1, rail_height*0.4, motor_width*0.75], center=true);
						}
					}
				}

				// Fan Shroud Joiners
				up(thick+jhead_shelf_thick+extruder_fan_thick-6) {
					back(extruder_length/4) {
						xspread(extruder_fan_size+2*joiner_width) {
							xrot(90) half_joiner2(h=extruder_fan_size/2, w=joiner_width, a=joiner_angle);
						}
					}
				}
			}

			// Clear space for Side half joiners
			up(rail_height/2/2) {
				yspread(extruder_length-30) {
					zring(r=w/2+side_joiner_len-0.05, n=2) {
						zrot(-90) {
							half_joiner_clear(h=rail_height/2, w=joiner_width, a=joiner_angle);
						}
					}
				}
			}
		}

		// Side half joiners
		up(rail_height/2/2) {
			yspread(extruder_length-30) {
				zring(r=w/2+side_joiner_len, n=2) {
					zrot(-90) {
						chamfer(chamfer=3, size=[joiner_width, 2*(side_joiner_len+joiner_width/2), rail_height/2], edges=[[0,0,0,0], [1,1,0,0], [0,0,0,0]]) {
							half_joiner2(h=rail_height/2, w=joiner_width, l=side_joiner_len+joiner_width/2, a=joiner_angle);
						}
					}
				}
			}
		}
	}
}



module jhead_platform_parts() { // make me
     difference() {
	  jhead_platform();
	  jhead_extruder_hole();
     }
}



jhead_platform_parts();



module jhead_extruder_hole() {
     jhead_d = 15;
     jhead_thick = 1;
     up(1.5+jhead_thick/2) {
	  cylinder(h=jhead_thick, d=jhead_d, center=true);
	  xmove(jhead_d/2)
	  cube(size=[jhead_d, jhead_d, jhead_thick], center=true);
     }
     up(4 + jhead_thick/2) {
	  cylinder(h=jhead_thick, d=jhead_d, center=true);
	  xmove(jhead_d/2)
	  cube(size=[jhead_d, jhead_d, jhead_thick], center=true);
     }
}

//jhead_extruder_hole();

// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
