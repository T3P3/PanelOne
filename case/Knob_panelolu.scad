//=======================================================================================  
//Disable $fn and $fa
$fn=0;
$fa=0.01;

//Use only $fs
//fine
//$fs=0.25;

//coarse
$fs=1;

shaft_dia=6.7;
shaft_h=6;
//rotate axes
X=[1,0,0];
Y=[0,1,0];
Z=[0,0,1];
//=======================================================================================  
module torus(outerRadius, innerRadius)
  {
  r=(outerRadius-innerRadius)/2;
  rotate_extrude() translate([innerRadius+r,0,0]) circle(r);
  }
//=======================================================================================  
ridges=47; //prime :)
module ridge(outerRadius, innerRadius)
  {
  for(i=[1:ridges])
    {
    rotate((i)*(360/ridges),Z)
      translate([outerRadius-0.1,0,0.5])
        rotate(-90,Z)
          linear_extrude(height = 5.5)
            polygon(points=[[-0.5,0],[0,1],[0.5,0]], paths=[[0,1,2]]);
    }
  }
//=======================================================================================  
//38 nominal outside
module knob(radius=15.5)
  {
  difference()
    {
    union()
      {
      //main body 
      translate([0,0,0])
			cylinder(r=radius,h=6);
      //step down
      translate([0,0,6-0.1])
        	cylinder(r=radius-2,h=1.6);
        //smoothiness
      translate([0,0,6-0.5])
        torus(outerRadius=radius,innerRadius=radius-4);
      //base of ridge
      translate([0,0,0])
        	cylinder(r=radius+0.3,h=1);
      }

    //Remove hole for shaft
   difference()
      {
      //shaft
		translate([0,0,-0.1])
      cylinder(r=shaft_dia/2,h=shaft_h); // Travel measured 0.35mm (data sheet says 0.2 to 0.9)
   //   cutout flat
      translate([-shaft_dia/2+(4.5/6)*shaft_dia,-4,0])//
		cube([shaft_dia/2,shaft_dia+1,shaft_h+1]);
      }
    //Remove fingercup (only if the radius is large enough to warrant it)
	if(radius>11)
    translate([radius-6.5,0,1+6+3])
      scale([1,1,0.75])
        sphere(r=5.5);
    }
  }
//=======================================================================================  
module encoder()
  {
  //encoder body measures 16.15 across corners
  //12.5 X 13.25 Y
  //measures 6.21 high
  translate([-12.4/2,-13.2/2,0])cube([12.4,13.2,6.5]);
  //bearing sleeve
  cylinder(r=6.9/2,h=11);
  difference()
    {
    //shaft
    cylinder(r=6/2,h=20); // Travel measured 0.35mm (data sheet says 0.2 to 0.9)
    //cutout flat
    translate([4.5-6/2,-4,13])cube([4,8,8]);
    }
  }
//=======================================================================================  
//build,  copies
module knob_assembly(radius=15.5)
{
      knob(radius);
      ridge(outerRadius=radius,innerRadius=radius-4);

}
//=======================================================================================

knob_assembly(10);
