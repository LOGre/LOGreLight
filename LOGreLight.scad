/*
An AA cell measures 49.2�50.5 mm (1.94�1.99 in) in length, including the button terminal�
and 13.5�14.5 mm (0.53�0.57 in) in diameter. 
The positive terminal button should be a minimum 1 mm high and a maximum 5.5 mm in diameter, 
the flat negative terminal should be a minimum diameter of 7 mm.[1]


/!\ Use NetFabb to repare STL before printed, I did not have time to correct it yet

*/

$fn = 60;


// to be modified :
AAcellHeight = 49.5;
AAcellOD = 13.5;
AACellPosPlugHeight = 1;
AACellPosPlugDiameter = 5.5;
contactOffset = 2.5;
clearance = 0.5;
wallWidth = 2;
springElementWidth = 1.5;
springDepth = 6;
extraSpring = 2.7; // Dirty !!
coilOD = 12;
coilID = 5;
coilHeight = 25+springDepth; //15;//4;
wireOD = 1.6; // Includes clearance
ledPinDistance = 2.54;
ledPinOD = 0.5;
nozzleSize = 0.4;
layerHeight = 0.2;


brassFastenerOD = 8;
brassFastenerHeight = 1;
brassFastenerPinHeight = 3;
brassFastenerPinLength = 26;

ledOD1 = 5;
ledOD2 = 5.9;
ledHeight = 7.6;





// Adaptation code
cellHeight = AAcellHeight;
cellOD = AAcellOD;
cellPosPlugHeight = AACellPosPlugHeight;
cellPosPlugOD = AACellPosPlugDiameter;
cellHeightFull = AAcellHeight+cellPosPlugHeight;

springThickness = nozzleSize;
springHeight = (cellOD+clearance*2)*3/4;
batteryHolderOD = cellOD+clearance*2+wallWidth*2;
batteryHolderHeight = cellHeightFull+contactOffset*2+wallWidth*2;
batteryWirePlusOffset = 5.5; // dirty, to be changed. Need just some time to calculate it
coilHolderOD = coilOD+clearance*2+wallWidth*2;
coilHolderHeight = coilHeight+clearance*2+wallWidth;
ledHolderOD = ledOD1+clearance*2+wallWidth*2;
ledHolderHeight = ledHeight/2-clearance*2; // dirty
flatSurfaceWidth = cellOD/1.25;

module ledCree5mm() {
  difference() {
    union() {
      cylinder( r=5/2, h=7.6-5/2 );
      translate( [0, 0, 7.6-5/2] ) sphere( r=5/2 );
      cylinder( r=5.5/2, h=1 );
      for ( x = [-ledPinDistance/2, ledPinDistance/2 ] ) {
        translate( [x, 0, -(5+x)] ) cylinder( r=ledPinOD/2, h=(5+x) );
      }
    }
    translate( [-5/2-10, -5, -1] ) cube( [10, 10, 10] );
  }
}

module coil() {
  difference() {
    cylinder( r=coilOD/2, h=coilHeight );
    cylinder( r=coilID/2, h=coilHeight+2 );
  }
}

module switch() {
  union() {
    translate( [0, 0, switchHeight+switchPinHeight] )
      cylinder( r=0.75, h=2 );
    translate( [-switchWidth/2,-switchWidth/2,switchPinHeight] )
      cube( [switchWidth, switchWidth, switchHeight] );
    for ( x = [-switchPinX , switchPinX ] ) {
      for ( y = [-switchWidth/2, switchWidth/2 ] ) {
        translate( [x, y, 0] )
          cylinder( r=0.1, h=switchPinHeight );
      }
    }
  }
}

module battery( battery_diameter, battery_height, positive_diameter, positive_height ) {
  union() {
    cylinder( r=battery_diameter/2, h=cellHeight );
    translate( [0, 0, cellHeight] ) cylinder( r=positive_diameter/2, h=positive_height );
  }
}




module batteryHolder() {
  union() {
    difference() {
      // Main body
      hull() {
        // Battery holder
        cylinder( r=batteryHolderOD/2, h=batteryHolderHeight );
        // Coil holder
        translate( [0, 0, batteryHolderHeight] )
          cylinder( r=coilHolderOD/2, h=coilHolderHeight );
        // Led holder
        translate( [0, 0, batteryHolderHeight+coilHolderHeight] )
          cylinder( r=ledHolderOD/2, h=ledHolderHeight );
        // Flat surface for printing - Might be not required
        translate( [-flatSurfaceWidth/2, -cellOD/2-wallWidth-clearance, 0] )
          cube( [flatSurfaceWidth, cellOD, batteryHolderHeight] );
        translate( [-flatSurfaceWidth/2, -cellOD/2-wallWidth-clearance, batteryHolderHeight] )
          cube( [flatSurfaceWidth, cellOD, coilHeight+wallWidth+clearance*2] );
      }
			// Remove - Battery extraction
			translate( [-cellOD*0.5/2, -cellOD/2-wallWidth*2, wallWidth*4] )
				cube( [cellOD*0.5, wallWidth*4, cellHeight*0.8] );
      // Remove - battery
      translate( [0, 0, wallWidth] )
        cylinder( r=(cellOD+clearance*2)/2, h=(cellHeightFull+contactOffset*2) );
      // Remove - battery insertion
      translate( [-cellOD, cellOD*0.3, wallWidth+contactOffset] )
        cube( [cellOD*2, cellOD*2, cellHeightFull+clearance*2] );
      for ( i = [wallWidth+contactOffset : batteryHolderHeight/4 : cellHeightFull+wallWidth+contactOffset] ) {
        translate( [-cellOD, 0, i] )
          cube( [cellOD*2, cellOD*2, cellHeightFull/8] );
      }
      // Remove - coil
      translate( [0, 0, batteryHolderHeight] )
        cylinder( r=(coilOD+clearance*2)/2, h=(coilHeight+clearance*2) );
      // Remove - coil insertion
      translate( [-(coilOD+clearance*2)/2, 0, batteryHolderHeight] )
        cube( [coilOD+clearance*2, coilOD*2, coilHeight+clearance*2] );
      // Remove - Wires between coil and battery
      translate( [batteryWirePlusOffset-0.35, -brassFastenerPinHeight*1.5/2, batteryHolderHeight-wallWidth-1] )
				cube( [clearance*1.6, brassFastenerPinHeight*1.5, wallWidth+2] );
      // Remove - Holes for switch's wires
      translate( [0, 0, -1] ) cylinder( r=wireOD/2, h=wallWidth+2 );  // centered, cell's minus
      translate( [(-cellOD/2-wireOD/2)*cos(35), (-cellOD/2-wireOD/2)*sin(35), -1] )        // minus from bottom to coil
        cylinder( r=wireOD/2, h=batteryHolderHeight+clearance*2+springDepth+wallWidth*5+1 );
      translate( [(-cellOD/2-wireOD+wallWidth)*cos(35), (-cellOD/2-wireOD+wallWidth)*sin(35), wireOD/2+batteryHolderHeight+clearance*2+springDepth+wallWidth*2] ) // wider hole to "extract" minus' wire in coil holder
        cylinder( r=wireOD, h=wallWidth*3 );
      rotate( [90, 0, -55] )  cylinder( r=wireOD/2, h=cellOD/2+wireOD/2 );                    // "Wire incrustation"
      // Remove - LED
      translate( [0, 0, batteryHolderHeight+clearance*2+coilHeight-1] )
        cylinder( r=(ledOD1+clearance)/2, h=(coilHeight+clearance*2) );
      // Remove - place for the switch
      translate( [-(coilOD+clearance*2)/2+0.1, -cellOD/2-layerHeight, batteryHolderHeight-clearance*2] )
				cube( [coilOD+clearance*2+extraSpring, springHeight+layerHeight+clearance*2, springDepth+clearance*6] );
    }
    // Add the plastic switch, minus the metal
    difference() {
      // Create the spring
      translate( [-(coilOD+clearance*2)/2, springHeight-cellOD/2, batteryHolderHeight+clearance] ) 
        rotate( [90, 0, 0] ) generateWobble();
      // Remove switch's wire
			translate( [batteryWirePlusOffset-0.53, -brassFastenerPinHeight*1.5/2, batteryHolderHeight] )
        cube( [springElementWidth-nozzleSize, brassFastenerPinHeight*1.5, springDepth+1] );
      translate( [(-cellOD/2-wireOD/2)*cos(35), (-cellOD/2-wireOD/2)*sin(35), -1] )        // minus from bottom to coil
        cylinder( r=wireOD/2, h=batteryHolderHeight+clearance*2+springDepth+wallWidth*6+1 );
    }
    // Add support for wire, the other part of the switch
    difference() {
      translate( [-(coilOD+clearance*2)/2, springHeight/2-cellOD, batteryHolderHeight+clearance*2+springDepth+wallWidth] )
        cube( [coilOD+clearance*2, springHeight, wallWidth] );
      // Remove switch's wire
      translate( [batteryWirePlusOffset-3.7, -brassFastenerPinHeight*1.5/2, batteryHolderHeight+clearance*2+springDepth+wallWidth-1] )
        cube( [wireOD*0.8, coilOD, wallWidth+2] );
      translate( [(-cellOD/2-wireOD/2)*cos(35), (-cellOD/2-wireOD/2)*sin(35), -1] )        // minus from bottom to coil
        cylinder( r=wireOD/2, h=batteryHolderHeight+clearance*2+springDepth+wallWidth*6+1 );
    }
  }
}

module generateWobble() {
  moduleLength = springElementWidth*2;
  length = coilOD+clearance*2+extraSpring;
  
  union() {
    // Add some plastic to achieve length
    translate( [length-length%moduleLength, 0, 0] )
      cube( [length%moduleLength, springThickness, springHeight] );
    // For loop on one centered element
    for ( i = [0 : moduleLength : length-moduleLength] ) {
      translate( [i, 0, 0] ) difference() {
        cube( [springElementWidth*2, springDepth, springHeight] );
        translate( [-springElementWidth+(springElementWidth-springThickness)/2, springThickness, -1] )
          cube( [springElementWidth, springDepth-springThickness+1, springHeight+2] );
        translate( [springElementWidth*1.5+springThickness*0.5, springThickness, -1] )
          cube( [springElementWidth+1, springDepth-springThickness+1, springHeight+2] );
        translate( [(springElementWidth+springThickness)/2, -1, -1] )
          cube( [springElementWidth-springThickness, springDepth-springThickness+1, springHeight+2] );
        
      }
    }
  }
}

/*
color( "white" )
  translate( [0, 0, cellHeightFull+contactOffset*2+wallWidth*3+clearance*3+coilHeight ] )
    ledCree5mm();
color( "brown" )
  translate( [0, 0, cellHeightFull+contactOffset*2+wallWidth*2+clearance] )
    coil();
color( "lightgrey" )
  translate( [0, 0, contactOffset+wallWidth] )
    battery( cellOD, cellHeightFull, cellPosPlugOD, cellPosPlugHeight);
  */

//difference() {
  batteryHolder();
  //translate([-50,-50,-1]) cube([100,100,61] );
// }

// generateWobble();


























      // Remove - LED pins
      /*for ( x = [-ledPinDistance/2, ledPinDistance/2 ] ) {
        translate( [x-(ledPinOD+clearance)/2, -(ledPinOD+clearance)/2, cellHeightFull+contactOffset*2+wallWidth*2+clearance*2+coilHeight-1] )
          cube( [ledPinOD+clearance, coilOD+wallWidth, wallWidth+] );
      }*/
	
