// P74 Plastic Meccano chain link
//
// V1.0 Sun, April 14 2019 WH
//
eps=0.04;
$fn=36;
inch=25.4;
pitch = 0.375*inch;
XN=6;
  
module P74() {
  
//   hole_dia = 0.122*inch;
//   axle_dia = 0.115*inch;
   hole_dia = 0.130*inch;
   axle_dia = 0.110*inch;
   axle_lng = 0.393*inch;
   link_dia = 0.147*inch;
   major_width = 0.393*inch;
//   thickness = 0.061*inch;
   thickness = 0.055*inch;
   major_gap = major_width-2*thickness;
   minor_width = 0.266*inch;
//   minor_width = 0.25*inch;
   minor_gap = minor_width-2*thickness;
   height = 0.244*inch;
   pitch = 0.375*inch;
   length = pitch+height;
	
	echo(major_width,minor_width,thickness);

   module side() {
      
      mid = major_width/4 - minor_width/4 + thickness/2;
      x = sqrt(thickness*thickness/2);

      translate([-height/2,0,0])
      linear_extrude(height=height)
         polygon(
            points=[
            [0,0],
            [0,thickness],
            [length/2-mid-x+thickness,thickness],
            [length/2+mid-x,thickness+(major_width-minor_width)/2],
            [length,thickness+(major_width-minor_width)/2],
            [length,(major_width-minor_width)/2],
            [length/2+mid+x-thickness,(major_width-minor_width)/2],
            [length/2-mid+x,0]
         ]
      );
   }

   difference() {
      intersection() {
         // round ended hull
         hull() {
            cylinder(h=major_width,d=height,center=true);
           translate([pitch,0,0])
              cylinder(h=major_width,d=height,center=true);
         }
         // sides
         union() {
            translate([0,height/2,0])
               rotate([90,0,0])
                  translate([0,-major_width/2,0])
                     side();
            translate([0,-height/2,0])
               rotate([-90,0,0])
                  translate([0,-major_width/2,0])
                     side();
         }
      }
      // - link holes
      cylinder(h=major_width+2*eps,d=hole_dia,center=true);
   }
   // + outer link axle
   translate([pitch,0,0])
      cylinder(h=axle_lng,d=axle_dia,center=true);
   // + inner link axle
   translate([pitch,0,0])
      cylinder(h=minor_gap+2*eps,d=link_dia,center=true);
}

//rotate([0,0,0])
for (i=[1:XN]){
	translate([i*pitch,0,0])
		rotate([90,0,180])
			P74();
}
