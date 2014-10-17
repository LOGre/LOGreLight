/*
An AA cell measures 49.2�50.5 mm (1.94�1.99 in) in length, including the button terminal�
and 13.5�14.5 mm (0.53�0.57 in) in diameter. 
The positive terminal button should be a minimum 1 mm high and a maximum 5.5 mm in diameter, 
the flat negative terminal should be a minimum diameter of 7 mm.[1]

*/

$fn = 60;


// to be modified :
AAcellHeight = 49.5;
AAcellOD = 13.5;
AACellPosPlugHeight = 1;
AACellPosPlugDiameter = 5.5;
contactOffset = 2;
clearance = 0.5;
wallWidth = 2;
coilOD = 12;
coilID = 5;
coilHeight = 15;//4;
switchHeight = 4;
switchWidth = 6.1;
switchPinX = switchWidth/2;
switchPinHeight = 2.5;
wireOD = 1.5; // Includes clearance
ledPinDistance = 2.54;
ledPinOD = 0.5;



// Adaptation code
cellHeight = AAcellHeight;
cellOD = AAcellOD;
cellPosPlugHeight = AACellPosPlugHeight;
cellPosPlugOD = AACellPosPlugDiameter;
cellHeightFull = AAcellHeight+cellPosPlugHeight;


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
  difference() {
    // Main body
    hull() {
      // Battery holder
      cylinder( r=(cellOD+clearance*2+wallWidth*2)/2, h=(cellHeightFull+contactOffset*2+wallWidth*2) );
      // Coil holder
      translate( [0, 0, cellHeightFull+contactOffset*2+wallWidth*2] )
        cylinder( r=(coilOD+clearance*2+wallWidth*2)/2, h=(coilHeight+clearance*2+wallWidth) );
      // Switch holder
      translate( [-(switchWidth+clearance*2)/2, -(switchWidth+clearance*2)/2, -switchHeight/2] )
        cube( [switchWidth+clearance*2, switchWidth+clearance*2, switchHeight/2 ] );
      // Flat surface for printing - Might not required
      translate( [-cellOD/1.25/2, -cellOD/2-wallWidth-clearance, 0] )
        cube( [cellOD/1.25, cellOD, cellHeightFull+wallWidth*2+contactOffset*2] );
      translate( [-coilOD/1.25/2, -cellOD/2-wallWidth-clearance, cellHeightFull+wallWidth*2+contactOffset*2-wallWidth] )
        cube( [coilOD/1.25, coilOD, coilHeight+wallWidth+clearance*2] );
    }
    // Remove - battery
    translate( [0, 0, wallWidth] )
      cylinder( r=(cellOD+clearance*2)/2, h=(cellHeightFull+contactOffset*2) );
    // Remove - battery insertion
    translate( [-cellOD, cellOD*0.3, wallWidth+contactOffset] )
      cube( [cellOD*2, cellOD*2, cellHeightFull+clearance*2] );
    for ( i = [wallWidth+contactOffset : (wallWidth+contactOffset+cellHeightFull+wallWidth+contactOffset)/4 : cellHeightFull+wallWidth+contactOffset] ) {
      translate( [-cellOD, 0, i] )
      cube( [cellOD*2, cellOD*2, cellHeightFull/8] );
    }
    // Remove - coil
    translate( [0, 0, cellHeightFull+contactOffset*2+wallWidth*2] )
      cylinder( r=(coilOD+clearance*2)/2, h=(coilHeight+clearance*2) );
    // Remove - coil insertion
    translate( [-(coilOD+clearance*2)/2, 0, cellHeightFull+contactOffset*2+wallWidth*2] )
      cube( [coilOD+clearance*2, coilOD*2, coilHeight+clearance*2] );
    // Remove - switch
    translate( [-(switchWidth+clearance*2)/2, -(switchWidth+clearance*2)/2, -switchHeight] )
        cube( [switchWidth+clearance*2, switchWidth+clearance*2, switchHeight ] );
    // Remove - switch pins/wires
    for ( x = [-switchPinX , switchPinX ] ) {
      for ( y = [-switchWidth/2, switchWidth/2 ] ) {
        translate( [x, y, -1] )
          cylinder( r=1, h=wallWidth+2 );
      }
    }
    // Remove - Wires between coil and battery
    for ( x = [0 , cellPosPlugOD/2+0.5 ] ) {
      translate( [x, 0, cellHeightFull+wallWidth+contactOffset*2-1] )
        rotate( [-30, 0, 0] ) cylinder( r=wireOD/2, h=wallWidth+2 );
    }
    // Remove - LED pins
    for ( x = [-ledPinDistance/2, ledPinDistance/2 ] ) {
      translate( [x-(ledPinOD+clearance)/2, -(ledPinOD+clearance)/2, cellHeightFull+contactOffset*2+wallWidth*2+clearance*2+coilHeight-1] )
        cube( [ledPinOD+clearance, coilOD+wallWidth, wallWidth+2] );
    }
    // Remove - Avoid to break it /!\ Have to find a better idea...
    translate( [-ledPinDistance/2, coilOD/3, cellHeightFull+contactOffset*2+wallWidth*2+clearance*2+coilHeight-1] ) 
      cube( [ledPinDistance, coilOD, wallWidth+2] );
    // Better look, but dirty...
    translate( [-(coilOD+clearance*2)/2, (coilOD+wallWidth)/2.5, cellHeightFull+contactOffset*2+wallWidth*2+clearance*2+coilHeight-1] )
      cube( [coilOD+clearance*2, coilOD*2, wallWidth+2] );
  }
}


color( "white" )
  translate( [0, 0, cellHeightFull+contactOffset*2+wallWidth*3+clearance*3+coilHeight ] )
    ledCree5mm();
color( "lightblue" )
  translate( [0, 0, switchPinHeight] ) rotate( [180,0,0] ) switch();
color( "brown" )
  translate( [0, 0, cellHeightFull+contactOffset*2+wallWidth*2+clearance] )
    coil();
color( "lightgrey" )
  translate( [0, 0, contactOffset+wallWidth] )
    battery( cellOD, cellHeightFull, cellPosPlugOD, cellPosPlugHeight);
  
batteryHolder();

