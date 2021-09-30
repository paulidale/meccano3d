//
// Part #564 Insulating Spacer
//
// After printing, tap with 5/32 BSW tap. Yes, the threads
// could be printed, but wouldn't be nearly as accurate as
// doing it with a tap.
//
// v1.0 WH May 28 2018
//
$fa=1.0;
$fs=0.5;
inch=25.4;
eps=0.05;

height=0.492*inch;
outer_r=0.370/2*inch;
hole_r=0.125/2*inch;

difference() {
  cylinder(h=height,r=outer_r);
  translate([0,0,-eps])
    cylinder(h=height+2*eps,r=hole_r);
}