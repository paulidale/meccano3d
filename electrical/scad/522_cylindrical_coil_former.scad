// PN 522 cylindrical coil plastic former
//
// Successfully sliced with Slic3r (using pillar supports)
// and printed in PLA. Clean up the wires holes with a 0.039"
// drill and run a 5/32 BSW tap through the mounting holes
// before winding the coil.
//
$fn=120;
inch=25.4;

end_rad=0.177*inch;
side_rad=0.819/2*inch;

base_thick=0.127*inch;
top_thick=0.062*inch;

mount_hole_x=0.500*inch;
height=1.021*inch;

chimney_outside_rad=0.512/2*inch;
chimney_inside_rad=0.391/2*inch;

e_mount_hole_x=mount_hole_x;
e_mount_hole_y=0;
s_mount_hole_x=-mount_hole_x;
s_mount_hole_y=0;

eye_rad=4.7/2;
mounting_hole_rad=3.17/2;

base_cutout_height=0.055*inch;
base_cutout_border=0.055*inch;

wire_rad=0.5;
wire_e_x=chimney_outside_rad+wire_rad;
wire_e_y=0;
wire_s_x=-0.3573*inch;
wire_s_y=-0.1027*inch;

text_y=0.1*inch;

module coil_form() {

  // add the bottom, top and chimney together
  // then subtract the chimney interior, eyelet
  // and wire holes, wire conduits and base cutout
  difference() {
    union() {
      // bottom
      difference() {
        hull() {
          cylinder(h=base_thick,r=side_rad);
          translate([mount_hole_x,0,0]) cylinder(h=base_thick,r=end_rad);
          translate([-mount_hole_x,0,0]) cylinder(h=base_thick,r=end_rad);
        }
        hull() {
          cylinder(h=base_cutout_height,r=side_rad-base_cutout_border);
          translate([mount_hole_x,0,0]) cylinder(h=base_cutout_height,r=end_rad-base_cutout_border);
          translate([-mount_hole_x,0,0]) cylinder(h=base_cutout_height,r=end_rad-base_cutout_border);
        }
      }
      translate([mount_hole_x,0,0]) cylinder(h=base_thick,r=end_rad);
      translate([-mount_hole_x,0,0]) cylinder(h=base_thick,r=end_rad);
      // top
      translate([0,0,height-top_thick]) hull() {
        cylinder(h=top_thick,r=side_rad);
        translate([mount_hole_x,0,0]) cylinder(h=top_thick,r=end_rad);
        translate([-mount_hole_x,0,0]) cylinder(h=top_thick,r=end_rad);
      }
      // chimney outside
      translate([0,0,base_cutout_height])
        cylinder(h=height-base_cutout_height,r=chimney_outside_rad);
      // coil text
      translate([wire_s_x,text_y,height])
        color("Blue") linear_extrude(height=0.3)
          text("S",font=":Bold",size=3,halign="center");
      translate([wire_e_x,text_y,height])
        color("Blue") linear_extrude(height=0.3) 
          text("E",font=":Bold",size=3,halign="center");
    }
    // remove chimney interior
    cylinder(h=height,r=chimney_inside_rad);
    // remove left eyelet
    translate([mount_hole_x,0,height-top_thick]) cylinder(h=top_thick,r=eye_rad);
    // remove right eyelet
    translate([-mount_hole_x,0,height-top_thick]) cylinder(h=top_thick,r=eye_rad);
    // remove left mounting hole
    translate([mount_hole_x,0,0]) cylinder(h=base_thick,r=mounting_hole_rad);
    // remove right mounting hole
    translate([-mount_hole_x,0,0]) cylinder(h=base_thick,r=mounting_hole_rad);
    // remove base cutout
//    translate([base_cutout_border,base_cutout_border,0]) cube([width-2*base_cutout_border,base_depth-2*base_cutout_border,base_cutout_height]);
    // remove S wire hole
    translate([wire_s_x,wire_s_y,height-top_thick]) cylinder(h=top_thick,r=wire_rad);
    // remove E wire hole
    translate([wire_e_x,wire_e_y,height-top_thick]) cylinder(h=top_thick,r=wire_rad);
    // remove S wire conduit
    translate([0,0,height-wire_rad])
      linear_extrude(height=wire_rad) 
        polygon([
          [wire_s_x,wire_s_y+wire_rad],
          [s_mount_hole_x,s_mount_hole_y+wire_rad],
          [s_mount_hole_x,s_mount_hole_y-wire_rad],
          [wire_s_x,wire_s_y-wire_rad],
          [wire_s_x,wire_s_y+wire_rad]]);
    // remove E wire conduit
    translate([0,0,height-wire_rad])
      linear_extrude(height=wire_rad) 
        polygon([
          [wire_e_x,wire_e_y+wire_rad],
          [e_mount_hole_x,e_mount_hole_y+wire_rad],
          [e_mount_hole_x,e_mount_hole_y-wire_rad],
          [wire_e_x,wire_e_y-wire_rad],
          [wire_e_x,wire_e_y+wire_rad]]);
  }
}

coil_form();
