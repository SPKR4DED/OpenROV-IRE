/* 
Soar Brushless motor three blade propeller
12/15/14


Uses module to create the three parts in the same script
*/

/*****************Parameters***************/

//basecap
res=90; // cylinder resolution

basecapR1=26.5/2; //matches diameter of propeller motor=26.5
basecapR2=10;
basecapBase=2;
basecapAl=6.4;// 5.8 measured
basecapRem=0.8; //inner radius of Al adapter wing corners
basecapAlRin=19.1/2; //diameter of Al adapter 19
basecapRemOffset=4.5;
baseCube=8;
baseCubeHei=5;
clearanceHole=5.5/2; //M5 bolt 5.5mm for clearance

retainThick=2;
retainWallHei=2;

//topcap

topcapR2=basecapR2;
topcapBase=2; //m5 by 19mm bolt, 7mm for threading into nosecone, 2mm basecap, 10mm blade, 2mm on topcap 
topCube=baseCube;
topCubeHei=baseCubeHei;
topBoltHei=1;
topcapR1=16/2;// base diameter of threaded nose cone

//blade
bladeCylOut=basecapR2;
bladeCylHei=10;
bladeCube=baseCube+.2; //.2 is for slight over extrude
bladeCylIn=bladeCylOut-retainThick-.2;//.2 for slight overextrude
bladeCylInHei=retainWallHei-.2;
propRad=31;  //radius of propeller 31mm for brushless
bladeTwist=7; //twist of blade from hub to outerrim, twist is the is the difference of bladeTwist and startAngle, follows left hand rule
startAngle=25;
avgAngle=(startAngle+(startAngle-bladeTwist/2))/2; 
nSlices=20; //20 has been good for printing
bladeScale=3.3; //amount of growth of blade moving out from the hub
bladeThick=1.3; //thickness of fin, 1.3mm had been strong enough
bladeWidth=4; // starting blade width at origin

/**********end parameters*************/




/*****uncomment the part you would like to render***/

//basecap();
topcap();
//3blade();




/*********module for basecap**************/

module basecap (){
//cone
difference(){
union(){
	intersection(){
	// base section that fits over Aluminum adapter
	translate([0,0,-basecapAl])
	cylinder(r1=basecapR1, r2=(2*basecapR1+basecapR2)/3, h=basecapAl, $fn=res);
for ( i = [0 : 2] )
{
    rotate( i * 360 / 3, [0, 0, 1])
translate([basecapRemOffset,basecapRemOffset,-basecapAl])
minkowski(){
	cylinder(r=basecapRem, h=basecapAl/2, $fn=res);
	cube([basecapR1, basecapR1, basecapAl/2]);
}//end of minkowski
}// end of for loop
}	// end of intersection making tabs to fit around Al adapter
//ring for wrapping around AL base
difference(){
translate([0,0,-basecapAl])
cylinder(r1=basecapR1, r2=(2*basecapR1+basecapR2)/3, h=basecapAl, $fn=res);
translate([0,0,-basecapAl-.01])
cylinder(r=basecapAlRin, h=basecapAl+.02, $fn=res);
}

//create taper to retaining ring
		cylinder(r1=(2*basecapR1+basecapR2)/3, r2=basecapR2, h=basecapBase, $fn=res);

//blade retaining ring
difference(){
translate([0,0,basecapBase])
cylinder(r=basecapR2, h=retainWallHei, $fn=res);
translate([0,0,basecapBase-.01])
cylinder(r=basecapR2-retainThick, h=retainWallHei+.02, $fn=res);
}
//lockcube
translate([0,0,basecapBase])
linear_extrude(height = baseCubeHei, convexity = 10)
polygon(points=[[basecapR2*sin(30),basecapR2*cos(30)],[-basecapR2,0],[basecapR2*sin(30),-basecapR2*cos(30)]]);
} // end union

//bolthole
translate([0,0,-basecapAl-.01])
cylinder(r=clearanceHole, h=basecapBase+baseCubeHei+basecapAl+.02, $fn=res);
} // end difference 
}//end of modulus basecap

/*********module for topcap**************/

module topcap (){

difference(){
union(){
	
//base cone
		cylinder(r1=topcapR1, r2=topcapR2, h=topcapBase, $fn=res);
//retaining ring		
difference(){
translate([0,0,topcapBase])
cylinder(r=topcapR2, h=retainWallHei, $fn=res);
translate([0,0,topcapBase-.01])
cylinder(r=topcapR2-retainThick, h=retainWallHei+.02, $fn=res);
}
//locking cube
translate([0,0,topcapBase])
linear_extrude(height = topCubeHei, convexity = 10)
polygon(points=[[topcapR2*sin(30),topcapR2*cos(30)],[-topcapR2,0],[topcapR2*sin(30),-topcapR2*cos(30)]]);
}//end union
//bolt hole
translate([0,0,-.01])
cylinder(r=clearanceHole, h=topcapBase+topCubeHei+.02, $fn=res);
}
}//end of modulus topcap

/****** module for 3blade*************/

module 3blade () {
difference(){
	union(){
	//creates inner cylinder that locks into end and top cap
	cylinder(r=bladeCylIn, h=bladeCylHei, $fn=res);
	//creates middle hub
	translate([0,0,bladeCylInHei])
	cylinder(r=bladeCylOut, h=bladeCylHei-2*bladeCylInHei, $fn=res);

//create the propeller blades
	intersection(){
		translate([0,0,bladeCylHei/2])
		rotate([90,90-startAngle,90]) 
		linear_extrude(height=propRad, convexity=10, twist=bladeTwist, slices=nSlices, scale=[1,bladeScale])
		scale([.8*bladeThick/bladeWidth,1,1]) 
		circle(r = bladeWidth,$fn=res); //blade profile is a scaled circle


	cylinder(h=bladeCylHei, r=propRad, $fn=res);
	}//end intersection - intersection between this cylinder and the blades gives the blades the rounded ends

}//end of union of cylinder and fin blade

	//makes it a partial base to interlock
	translate([-2*bladeCylOut+bladeCylOut*sin(30)+.2,-bladeCylOut-.1,-.10])
	cube([2*bladeCylOut,bladeCylOut*2+.2,bladeCylHei+.2]);

}//end of difference
}// end of 3blade module

