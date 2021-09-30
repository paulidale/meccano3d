// Meccano spur gear maker
//
// v1.0 - Apr 2, 2018 - initial release SWH
// v1.1 - Apr 18, 2018 - code clean up and gear outline updates SWH
//
// Here's the 5 things you (may) need to set
//
// teeth: desired number of teeth
// gear_thickness: how many mm thick the gear disc should be
// dxf_path: the directory where the gear outline DXF files are
// boss_height: how many mm high above the gear the boss should extend.
// standard,triflat,twoflat: set exactly 1 of these 3 to true (others
// to false) to get either a standard axle hole, a triflat axle hole,
// or a two flat axle hole for the 28BYJ-48 stepper motor.
//
// It should go without saying that in order for this to work, a DXF
// outline file must exist to match the number of teeth you've chosen!
//
// The parameters for the gear outline maker at
// <http://hessmer.org/gears/InvoluteSpurGearBuilder.html>
// are:
//
// Circular pitch: 2.09990666845 for 38DP gears,
//                 2.127905424 for 37.5DP gear (15t,25t,50t,60t and the like)
// Pressure angle: 20
// Clearance: 0.25
// Backlash: 0.05
// Profile shift: 0
// Wheel 1 tooth count: desired # of teeth
// Wheel 1 Center Hole diameter: 0
// Wheel 2 tooth count: whatever you like (I pick something that will mesh at standard centres)
// Wheel 2 Center Hole diameter:: 0
// Show: Wheel 1 only
// Rotation steps per tooth angle: 10
// Number of segments: 30
//
// Depending on your printer's accuracy and tolerances, you may have to fiddle
// with Clearance and Backlash to get the gear to mesh properly. I did!
//
// imperial/metric constants
//
inch = 25.4;
half_inch = inch/2;
quarter_inch = inch/4;
//
$fn=32;                 // let's have nice round circles by default
eps=0.04;               // tiny number to eliminate coincident faces
//
// parametric values
// ------------------------------------------------------------
//
teeth = 57;             // 15, 19, 25, 38, 50, 57, 95, 114, 121, 133
                        // if you want other values, you'll have to
                        // create your own gear outline at
                        // http://hessmer.org/gears/InvoluteSpurGearBuilder.html
gear_thickness = inch/8;
boss_height = inch/8;   // set to zero for no boss
boss_dia = 3/8*inch;

standard = false;       // ONLY SET ONE OF THESE THREE TO TRUE
triflat = true;         // THE OTHER TWO MUST BE FALSE
twoflat = false;        //

triaxle_round_dia = 0.172*inch;// sized to fit a standard Meccano triaxle rod
triaxle_flats_dia = 3.76;      // ... YMMV
axle_dia = 0.167*inch;         // sized to pass a standard Meccano axle rod

twoflats_round_dia = 5.34;	     // for 28BYJ-48 stepper motors
twoflats_flat_dia = 3.34;      // (see Amazon or eBay to buy)
//
// ------------------------------------------------------------
//

// Make the gear
if ( teeth < 57 ) {
    spur_gear(teeth);                    // no ring of holes
} else if ( teeth < 95 ) {
    spur_gear(teeth,1);                  // 1 ring of holes
} else {
    spur_gear(teeth,2);                  // 2 rings of holes and slots
}

// ------------------------------------------------------------
//
// tube: create a cylinder of the given length and diameter
// at the point [x,y,z]
//
module tube (length, diameter, x=0, y=0, z=0) {
    translate([x,y,z-eps])
      cylinder(h=length+2*eps, r=diameter/2);
}

// ------------------------------------------------------------
//
// axle: create an axle with a particular cross section at [x,y,z]
//
// This is the function you'd modify to change the axle hole cross section.
// It's currently set up to create either tri-flat or round axle holes.
//
module axle(zlength, x=0, y=0, z=0) {
    if( twoflat ) {
        intersection() {
            tube(zlength,twoflats_round_dia,x,y,z);
            translate([x,y,z-eps])
                linear_extrude(height=zlength+2*eps)
                   square([twoflats_round_dia,twoflats_flat_dia],center=true);
        }
    } else if( triflat ) {
        intersection() {
            tube(zlength,triaxle_round_dia,x,y,z);
            // a circle with 3 sides is... you guessed, a triangle!
            translate([x,y,z-eps]) 
                linear_extrude(height=zlength+2*eps) 
                    circle(triaxle_flats_dia,$fn=3);
        }
    } else {
        tube(zlength,axle_dia,x,y,z);
    }
}

// ------------------------------------------------------------
//
// do_rings: add either a single ring of holes or two rings
// with alternating holes and slots extending between the rings
//
// hole_ring_angle is best set to something that divides 360 evenly
//
module do_rings( hole_ring_angle, rings ) {
    hole_ring1_radius = half_inch;   // 1st ring at 0.5" radius
    hole_ring2_radius = inch;        // 2nd ring at 1.0" radius
    hole_ring_dia = 0.172 * inch;    // sized for Meccano
    for( angle=[0:hole_ring_angle:360-hole_ring_angle]) {
        rotate([0,0,angle])
            tube(gear_thickness,hole_ring_dia,hole_ring1_radius,0,0);
        if( rings == 2 ) {
            rotate([0,0,angle]) 
                tube(gear_thickness,hole_ring_dia,hole_ring2_radius);
            rotate([0,0,angle+hole_ring_angle/2]) hull() {
                tube(gear_thickness,hole_ring_dia,hole_ring1_radius);
                tube(gear_thickness,hole_ring_dia,hole_ring2_radius);
            }
        }
    }
}

// ------------------------------------------------------------
//
// create a spur gear
//
// inputs:
//
// teeth: 15, 19, 25, 38, 50, 57, 95, 114, 121, 133
// rings: 0, 1, 2 (no holes, 1 ring of 8 holes, 2 rings of 4 holes and 4 slots)
// holes: number of holes (or holes+slots) in each ring. defaults to 8
//
module spur_gear(teeth,rings=0,num_holes=8) {
    gear_outline = str("Gear_outline_files/",teeth,"teeth.dxf");
    collar_width = 1; // a little angled collar between the boss and disc to add strength
    difference() {
        union() {
            linear_extrude(height=gear_thickness)
                import(gear_outline,convexity=10);
            if( boss_height>0 ) {
                tube(boss_height-eps, boss_dia, 0, 0, gear_thickness);
                if( boss_height>=collar_width ) {
                    translate([0,0,gear_thickness-eps])
                        cylinder(h=collar_width+eps,d1=boss_dia+2*collar_width,d2=boss_dia);
                }
            }
        }

        axle(boss_height+gear_thickness);

        if( rings > 0 ) {
            if ( rings == 1 ) {
                do_rings(360/num_holes,1);
            } else if ( rings == 2 ) {
                do_rings(720/num_holes,2);
            }
        }
    }
}
