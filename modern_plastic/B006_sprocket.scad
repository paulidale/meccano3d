//
// B006 sprocket: this part was only ever included in three modern
// sets: the Drilling Vehicle (4600), the Rattle Trap (5650) and
// the Time Machine (7651). And only the Drilling Vehicle had them
// in sufficient quantity to be useful. All of these sets are now
// as rare as hen's teeth. Which is a shame, as the tracks it was
// designed for where recycled in the 2005 15 model set, and the
// tracks really don't work well without these sprockets.
//
// This model has been optimized for brass 19T pinions rather than
// the plastic variety (mostly because I had the former and not the
// latter). The DXF settings for the gear outline are:
//
// Circular pitch: 2.09990666845
// Pressure angle: 20
// Clearance: 0.15
// Backlash: 0.15
// Profile shift: 0
// Wheel 1 tooth count: -19
// Wheel 1 Center Hole diameter: 0
// Wheel 2 tooth count: 4
// Wheel 2 Center Hole diameter: 0
// Show: Wheel 1 only
// Rotation steps per tooth angle: 10
// Number of segments: 30
//
// V1.0 April 13, 2018 WH - best guess dimensions
// V1.1 April 18, 2018 WH - minor comment change
// V1.2 April 24, 2018 WH - dimensions from actual part - Thanks to Newspaniard
//
$fn=40;
eps=0.05;
//
// parameters
//
intermittent_rings=true;	// true for tread ring on only one side at
                          // a time, alternating; false for continuous
                          // tread rings on both sides
//
// Meccano constants
//
inch=25.4;
axle_id=0.168*inch;

module B006_sprocket(intermittent_rings=true) {

  tube_od=0.655*inch;
  tube_id=0.571*inch;
  tube_h=1*inch;

  recess_h=0.320*inch; // 8.35;

  tread_w=0.435*inch;  // treads are actually 3/8" (0.375")

  ring_d=0.900*inch; // 0.860*inch;
  ring_h=0.060*inch; // 0.085*inch;
  ring_w=(ring_d-tube_od)/2;

  ring1_height=(tube_h-tread_w-2*ring_h)/2;
  ring2_height=ring1_height+ring_h+tread_w;

  spoke_w1=0.085*inch; // 0.055*inch;
  spoke_w2=0.100*inch; // 0.055*inch;
  spoke_angle=45;

  gear_h=1/8*inch;

  axle_od=axle_id+2;

  cross_h=0.130*inch; // 2;
  cross_w=0.035*inch; // 1.5;
  cross_d=tube_id-0.12*inch; // 3;
  cross_h_offset=0.036*inch;

  union() {
    difference() {
      // main cylinder, tread rings and spokes
      union() {
        // main cylinder
        cylinder(d=tube_od,h=tube_h);
        // lower tread ring
        translate([0,0,ring1_height]) 
          intersection() {
            cylinder(d=ring_d,h=ring_h);
            // continuous or intermittent?
            if( intermittent_rings ) {
              union() {
                for( angle=[0:spoke_angle*2:360-2*spoke_angle]) {
                  rotate([0,0,angle])
                    linear_extrude(height=ring_h)
                     polygon([[0,0],[ring_d,0],[ring_d,ring_d],[0,0]]);
                }
              }
            }
          }
        // upper tread ring
        translate([0,0,ring2_height]) 
          intersection() {
            cylinder(d=ring_d,h=ring_h);
            // continuous or intermittent?
            if( intermittent_rings ) {
              union() {
                // top ring is offset so that intermittent rings are
                // either one side or the other
                for( angle=[45:spoke_angle*2:360-spoke_angle]) {
                  rotate([0,0,angle])
                    linear_extrude(height=ring_h)
                      polygon([[0,0],[ring_d,0],[ring_d,ring_d],[0,0]]);
                }
              }
            }
          }
        // tread spokes
        for( angle=[0:spoke_angle:360-spoke_angle]) {
          linear_extrude(height=tube_h)
            rotate([0,0,angle])
              translate([0,tube_od/2,0])
                polygon([
                  [-spoke_w2/2,-0.1],
                  [spoke_w2/2,-0.1],
                  [spoke_w1/2,(ring_d-tube_od)/2],
                  [-spoke_w1/2,(ring_d-tube_od)/2],
                  [-spoke_w2/2,-0.1]
                ]);           
        }
      }
      // remove bottom recess
      translate([0,0,-eps])
        cylinder(d=tube_id,h=recess_h+eps);
      // remove bottom cross material
      translate([0,0,recess_h-eps])
        difference() {
          cylinder(d=cross_d,h=cross_h+eps);
          cylinder(d=axle_od,h=cross_h+eps);
          translate([0,0,cross_h/2+cross_h_offset])
            union() {
              cube([cross_d,cross_w,cross_h],center=true);
              cube([cross_w,cross_d,cross_h],center=true);
            }
        }
      // remove top recess
      translate([0,0,tube_h-recess_h])
        cylinder(d=tube_id,h=recess_h+eps);
      // remove top cross material
      translate([0,0,tube_h-recess_h-cross_h])
        difference() {
          cylinder(d=cross_d,h=cross_h+eps);
          cylinder(d=axle_od,h=cross_h+eps);
          translate([0,0,cross_h/2-cross_h_offset])
            union() {
              cube([cross_d,cross_w,cross_h],center=true);
              cube([cross_w,cross_d,cross_h],center=true);
            }
        }
      // remove axle
      cylinder(d=axle_id,h=tube_h);
    }
    // add in 19 tooth gear rings
    translate([0,0,tube_h-recess_h-eps])
      linear_extrude(height=gear_h+eps)
        intersection() {
          import("B006_19teeth_interior.dxf",convexity=10);
          circle(r=tube_od/2);
        }
    translate([0,0,recess_h-gear_h])
      linear_extrude(height=gear_h+eps)
        intersection() {
          import("B006_19teeth_interior.dxf",convexity=10);
          circle(r=tube_od/2);
        }
  }
}

B006_sprocket(intermittent_rings);
