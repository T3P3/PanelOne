// PanelOne case v0.1
//
// based on the Panelolu2 case:
// thingiverse:http://www.thingiverse.com/thing:25617
//
// For more information:
// http://blog.think3dprint3d.com/2014/04/OpenSCAD-PanelOne-case-design.html
//
// by Tony Lock
// GNU GPL v3
// Apr 2014

use <knob_panelolu.scad>

///////////////////////////////////////////////////////////
//front, back or Assembly
///////////////////////////////////////////////////////////
side=3; //1 = front, -1 = back  2=printing layout -2 Electronics module 3 mounts 0=assembly model
///////////////////////////////////////////////////////////

m3_diameter = 3.6;
m3_nut_diameter = 5.3;
m3_nut_diameter_bigger=((m3_nut_diameter / 2) / cos (180 / 6))*2;
////////////////////////////////////////////////////////////////////
clearance=0.8;
wall_width=1.6; //minimum wall width //should be a multiple of your extruded dia
layer_height=0.2;

//LCD screen
lcd_scrn_x=99;
lcd_scrn_y=40.5;
lcd_scrn_z=9.4;

lcd_board_x=99;
lcd_board_y=61;
lcd_board_z=1.6; //does not include metal tabs on base

lcd_hole_d=3.6;
lcd_hole_offset=(lcd_hole_d/2)+1;

//board edge to center of first connector hole
lcd_connect_x=10.2;  
lcd_connect_y=58.4;

//PanelOne circuit board
pl_x=136;
pl_y=lcd_board_y;
pl_z=4; //excluding click Encoder and SD card and cable headers, but including the soldered bottoms of the through hole connectors
pl_mounting_hole_dia=3.4;
pl_mounting_hole_x=133.6;
pl_mounting_hole1_y=3.4; //only bothering with 2 holes at this point
pl_mounting_hole2_y=58.4;

//rotary encoder
click_encoder_x=13.2;
click_encoder_y=12.6;
click_encoder_z=6;
click_encoder_shaft_dia=6.9+clearance;
click_encoder_shaft_y=12.2;
click_encoder_knob_dia=24;
click_encoder_offset_x=112.2;
click_encoder_offset_y=23.8;//moved down 7mm in version 2.0a of PanelOne


//contrast and brightness holes
cb_dia=4; //hole diameter for adjustmenet screw
cb_y=15;
con_offset_x=107.2;
con_offset_y=9.1; //moved down 7mm in version 2.0a of PanelOne
con_offset_z=pl_z;
bri_offset_x=117.1;
bri_offset_y=9.1;//moved down 7mm in version 2.0a of PanelOne
bri_offset_z=con_offset_z;

//headers
//lcd connection header
lcd_y_x=(16*2.54)+2.54;
lcd_y_y=2.54;
lcd_y_z=3; //this is the gap between the circuit board caused by the plastic spaces on 2.54mm headers
lcd_y_offset_x=lcd_connect_x;  
lcd_y_offset_y=lcd_connect_y;
lcd_y_offset_z=pl_z;

//IDC headers, use the clearance required for the plug
//these are much bigger on z than the actual headers for clearance
idc_y_x=16; //not all will be within case
idc_y_y=37.9;
idc_y_z=6.39+2.5;
idc1_offset_x=128.4; 
idc1_offset_y=18.1; 
idc1_offset_z=1.61;


//SD card slot
SD_slot_x=24.5+clearance; //wider for clearance
SD_slot_y=29.5;
SD_slot_z=4;
SD_slot_offset_x=100.5-clearance/2;
SD_slot_offset_y=39.5;
SD_slot_offset_z=pl_z;

//case variables
shell_split_z = pl_z+SD_slot_z-0.01; //board split in the top of the slots
shell_width=wall_width+clearance;
shell_top = pl_z+click_encoder_z+2;

//mount variables
mount_x=(lcd_hole_offset+shell_width)*2;
mount_z=4;
mount_a=19;
mount_b=49;
mount_c=62.9;
mount_angle=41.87;




//////////////////////////////////////////////////////////////////////////////////////////
// front
if (side==1)
{
	front();
}

// back
else if(side==-1)
{
		back();
}
//Printing plate
else if(side==2)
{
	translate([shell_width,pl_y*2+shell_width*4,shell_top+shell_width])
		rotate([180,0,0])
			front();
	translate([shell_width,shell_width,shell_width])
		back();
	translate([pl_y*0.5,pl_y*1.5+shell_width*2,shell_width])
	knob_assembly(click_encoder_knob_dia/2);
}
else if(side==-2)
{
	LCD_assembly();
}
//mounts
else if(side==3)
{
	mount();
	translate([10,10,0])
		mount();
}	

//assembly
else
{
	color("blue") back();
	color("blue") front();
	LCD_assembly();
	color("orange") translate([click_encoder_offset_x,click_encoder_offset_y,wall_width+click_encoder_shaft_y+click_encoder_z-2])
		knob_assembly(click_encoder_knob_dia/2);
	for(i=[mount_x,pl_x+mount_x/2]){
		translate([i-shell_width,29.3-shell_width,-32.7-shell_width])
			rotate([0,-90,0])
				rotate([0,0,-mount_angle])
				mount();
	}
}
//////////////////////////////////////////////////////////////////////////////////////////

module mount()
{
	difference(){
		union(){
			linear_extrude(height=mount_x)
				polygon([[mount_c-mount_a,-mount_z],
						[mount_c-mount_a-mount_z,-mount_z],
						[mount_c-mount_a-mount_z,-mount_z/2],
						[-mount_z/2,mount_b-mount_z],
						[-mount_a,mount_b-mount_z],
						[-mount_a,mount_b],
						[0,mount_b],
						[mount_c-mount_a,0]]);

			for(i=[(lcd_hole_offset-pl_mounting_hole2_y)/2,(pl_mounting_hole2_y-lcd_hole_offset)/2]){
				translate([21.30,16.73,mount_x])
					rotate([0,90,mount_angle])
						translate([0,i,0])
							cube([mount_x,mount_x,1.6]);
			}
		}
		//shave off a bit of the mount brackets
		translate([mount_c-mount_a-mount_z-3,-mount_z-8.5,-2])
				cube([10,10,mount_x+4]);
		//case holes
		for(i=[(lcd_hole_offset-pl_mounting_hole2_y)/2,(pl_mounting_hole2_y-lcd_hole_offset)/2])
		translate([17.4,20.5,mount_x/2])
			rotate([0,90,mount_angle])
				translate([0,i,0]){
					cylinder(r=lcd_hole_d/2, h=mount_z*4, $fn=20);
					cylinder(r=m3_nut_diameter_bigger/2+layer_height*2, h=3.5, $fn=6);
				}
		//frame mounting holes
		translate([-11.5,35,mount_x/2])
			rotate([0,90,90])
				cylinder(r=lcd_hole_d/2, h=mount_z*4, $fn=20);
	}
}


module back() {
	side=8; //for the supports
	difference(){
		union(){
			difference(){
				translate([-shell_width,-shell_width,-shell_width])
				roundedRect([pl_x+shell_width*2,pl_y+shell_width*2,shell_split_z+shell_width], 2.5);
				translate([-clearance,-clearance,-clearance])
					cube([pl_x+clearance*2,pl_y+clearance*2,shell_split_z+clearance+0.01]);
				LCD_assembly();
			}
			//corner supports
			for(i=[-wall_width,pl_y-side+wall_width]){
				translate([-wall_width,i,-shell_width])
					cube([side,side,8.75]);
				translate([pl_x-side+wall_width,i,-shell_width])
					cube([side,side,4.35]);
			}
			//additional support
			translate([lcd_board_x-side-10,-wall_width,-shell_width])
				cube([side,side/2,8.75]);
		}
		case_screw_holes(false,0);
	}
	
}
module front() {
	side=8; //for the supports
	difference(){
		union(){
			difference(){
				translate([-shell_width,-shell_width,shell_split_z])
					roundedRect([pl_x+shell_width*2,pl_y+shell_width*2,shell_top-shell_split_z+shell_width],2.5);
				translate([-clearance,-clearance,shell_split_z-0.01])
					cube([pl_x+clearance*2,pl_y+clearance*2,shell_top-shell_split_z+clearance]);
				LCD_assembly();
			}
			//corner supports
			for(i=[-wall_width,pl_x-side+wall_width])
				for(j=[-wall_width,pl_y-side+wall_width]){
					translate([i,j,shell_split_z])
						cube([side,side,shell_top-shell_split_z+wall_width]);
				}
			//additional supports
			//for(i=[-wall_width,pl_y-side/2+wall_width]){
			//	translate([lcd_board_x-side,i,shell_split_z])
			//	cube([side,side/2,shell_top-shell_split_z+wall_width]);
			//}
		}
		case_screw_holes(false,shell_top+shell_width);
	}
}

module LCD_assembly() {
	translate([0,0,lcd_y_offset_z+lcd_y_z])
		lcd();
		pl_board();
   //lcd connection header
	color("black")
		translate([lcd_y_offset_x,lcd_y_offset_y,lcd_y_offset_z])
			cube([lcd_y_x,lcd_y_y,lcd_y_z]);
}

//LCD screen
module lcd() {
	difference(){
		union(){
			color("OliveDrab")
				translate([0,0,0])
					cube([lcd_board_x,lcd_board_y,lcd_board_z]);
			color("DarkSlateGray")
				translate([(lcd_board_x-lcd_scrn_x)/2,(lcd_board_y-lcd_scrn_y)/2,lcd_board_z])
					cube([lcd_scrn_x,lcd_scrn_y,lcd_scrn_z]);
		}
		for(i=[lcd_hole_offset,lcd_board_x-lcd_hole_offset]){
			for(j=[lcd_hole_offset,lcd_board_y-lcd_hole_offset]){
				translate([i,j,lcd_board_z])
					cylinder(r=lcd_hole_d/2,h=lcd_board_z+3,$fn=12,center=true);
			}
		}
	}
}

//PanelOne circuit board simplified
module pl_board() {
	difference(){
		union(){
			color("lightgreen")
				cube([pl_x,pl_y,pl_z]);
			//click encoder
			color("darkgrey"){
				translate([click_encoder_offset_x,click_encoder_offset_y,pl_z+(click_encoder_z)/2])
					cube([click_encoder_x,click_encoder_y,click_encoder_z],center=true);
				translate([click_encoder_offset_x,click_encoder_offset_y,pl_z+click_encoder_z+(click_encoder_shaft_y)/2])
					cylinder(r=click_encoder_shaft_dia/2,h=click_encoder_shaft_y,center=true);
			//contrast and brightness pots
		  		translate([con_offset_x,con_offset_y,con_offset_z+cb_y/2])
					cylinder(r=cb_dia/2,h=cb_y,center=true);
		  		translate([bri_offset_x,bri_offset_y,bri_offset_z+cb_y/2])
					cylinder(r=cb_dia/2,h=cb_y,center=true);
			}		
		}
		//cutout (probably not needed)
		translate([-0.1,-0.1,-0.1]){
			cube([93,45,pl_z+2]);
			cube([6,lcd_board_y+1,pl_z+2]);
		}
		//mounting holes
		translate([pl_mounting_hole_x,pl_mounting_hole1_y,(pl_z+3)/2])
			cylinder(r=pl_mounting_hole_dia/2,h=pl_z+3,center=true);
		translate([pl_mounting_hole_x,pl_mounting_hole2_y,(pl_z+3)/2])
			cylinder(r=pl_mounting_hole_dia/2,h=pl_z+3,center=true);
	}
	//SD board 
	color("lightblue")	
		translate([SD_slot_offset_x,SD_slot_offset_y,SD_slot_offset_z]) 
			cube([SD_slot_x,SD_slot_y,SD_slot_z]);
   //IDC header
	color("darkgrey")
		translate([idc1_offset_x,idc1_offset_y,idc1_offset_z])
			cube([idc_y_x,idc_y_y,idc_y_z]);
}

//Nut trap functionality not used yet
module case_screw_holes(nut_trap=false,z_height=0, dia=lcd_hole_d) {
	for(i=[lcd_hole_offset,pl_mounting_hole_x])
	for(j=[lcd_hole_offset,pl_mounting_hole2_y]){
		if (nut_trap) {
			translate([i,j,z_height])
				cylinder(r=dia/2, h=shell_width*2, $fn=fn);
			translate([i,j,z_height])
				cylinder(r=m3_nut_diameter_bigger/2+layer_height*2, h=shell_width, $fn=6);
		} else {
				translate([i,j,z_height])
				cylinder(r=dia/2,h=shell_width*2+30,$fn=12,center=true);
		}
	}

}
//h= height of the support
//z= start z point of the supports
//side = length of side of cube
module corner_supports(h=5,z=0,side=5) {
	for(i=[-wall_width,pl_x-side+wall_width])
		for(j=[-wall_width,pl_y-side+wall_width]){
			translate([i,j,z])
				cube([side,side,h]);
	}

}


module roundedRect(size, radius,center=false) {
	x = size[0]; 
	y = size[1]; 
	z = size[2]; 
	
	radius_sharp=0.1;

	linear_extrude(height=z)
	{
	if(center==true) {
	hull() { 
		// place 4 circles in the corners, with the given radius 
		translate([(-x/2)+(radius/2), (-y/2)+(radius/2), 0]) circle(r=radius); 
		translate([(x/2)-(radius/2), (-y/2)+(radius/2), 0]) circle(r=radius); 
		translate([(-x/2)+(radius/2), (y/2)-(radius/2), 0]) circle(r=radius); 
		translate([(x/2)-(radius/2), (y/2)-(radius/2), 0]) circle(r=radius); 
		translate([0,0,0]);
	} 
	}
	else
	{
	hull() { 
		// place 4 circles in the corners, with the given radius 
		translate([(0)+(radius), (0)+(radius), 0]) circle(r=radius); 
		translate([(x)-(radius), (0)+(radius), 0]) circle(r=radius); 
		translate([(0)+(radius), (y)-(radius), 0]) circle(r=radius); 
		translate([(x)-(radius), (y)-(radius), 0]) circle(r=radius); 
		translate([0,0,0]);
	}
	}
	}
}



