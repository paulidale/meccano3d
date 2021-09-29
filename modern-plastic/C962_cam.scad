$fn=32;

//
// Meccano constants
//
inch=25.4;
axle_d=0.166*inch;           // size for standard round Meccano axle
triaxle_round_d=0.172*inch;  // sized to fit a standard Meccano triaxle rod
triaxle_flats_d=3.76;        // ... YMMV

//
// cam: produce a cam as used in the 2015 F1 race car set
//
// centered: true to put the cam centered on the boss height,
// false to put the cam on the bottom (default: true)
//
module cam(centered=true) {

  // cam constants
  cam_major_d=20.0;
  cam_minor_d=14.2;
  cam_thick=2.5;
  boss_d=7.5;
  boss_h=6.0;

  difference() {
    union() {
      translate([0,0,centered?(boss_h-cam_thick)/2:0])
        linear_extrude(height=cam_thick)
          resize([cam_major_d,cam_minor_d])
            circle(d=cam_minor_d);
      cylinder(r=boss_d/2,h=boss_h);
    }
    intersection() {
      cylinder(r=triaxle_round_d/2,h=boss_h);
      // a circle with 3 sides is... you guessed it, a triangle!
      linear_extrude(height=boss_h) 
        circle(triaxle_flats_d,$fn=3);
    }
  }
}

cam();
