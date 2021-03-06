// My utility functions

// Put it in your openscad library path and use with:
// include<utils.scad>


fudge = 0.01;

// Some default screw characteristics - for M3 screws
defScrewRad=3.5/2;
defScrewDepth=10;
defScrewHeadRad=6/2;
defScrewHeadDepth=3.5;

defLayer=0.3; // default layer thickness
tolerance=0.5;

/** Calculates length of hypotenuse according to pythagoras theorum */
function pythag(x, y)=sqrt(x*x+y*y);

// Copyright 2011 Nophead (of RepRap fame)
// Using this holes should come out approximately right when printed
module polyhole2d(r) {
    n = max(round(4 * r),3);
    rotate([0,0,180]) circle(r = r / cos (180 / n), $fn = n);
}
module polyhole(r, h) {
    linear_extrude(height = h) polyhole2d(r);
}

module test_polyhole(){
    difference() {
	cube(size = [100,27,3]);
        union() {
    	    for(i = [1:10]) {
                translate([(i * i + i)/2 + 3 * i , 8,-1])
                polyhole(h = 5, r = i/2);
                
                assign(d = i + 0.5)
                translate([(d * d + d)/2 + 3 * d, 19,-1])
                polyhole(h = 5, r = d/2);
    	    }
        }
    }
}



/** 
 * Displays the current build volume of my mendel
 */
module mendelBuildVolume() {
    %translate([-90, -80, 0]) cube([90+101,160,55]);
    %translate([-73, -80, 0]) cube([73+93,160,125]);
}

/**
 * Make an object suitable for creating a hole for a countersink screw.
 * @param r1 screw (narrowest) radius
 * @param r2 head (widest) radius
 * @param h1 depth of head to start of countersink
 * @param h2 depth of screw from start of countersink to end (i.e. total length = h1+h2)
 */
module countersink(r1=defScrewHeadRad, r2=defScrewRad, h1=defScrewHeadDepth, h2=defScrewDepth) {
    sinkheight=r1-r2;
    polyhole(r = r1, h = h1 + fudge);
    translate([0, 0, h1]) cylinder(r1 = r1, r2 = r2, h = sinkheight + fudge);
    translate([0, 0, h1 + sinkheight]) polyhole(r = r2, h = h2 - sinkheight);
}

/**
 * Make an object suitable for creating a hole for a regular screw.
 * @param r1 head (narrowest) radius
 * @param r2 screw (widest) radius
 * @param h1 depth of screw 
 * @param h2 depth of screw head (i.e. total length = h1+h2)
 */
module bolthole(r1=defScrewHeadRad, r2=defScrewRad, h1=defScrewHeadDepth, h2=defScrewDepth) {
    polyhole(r = r1, h = h1 + fudge);
    translate([0, 0, h1]) polyhole(r = r2, h = h2);
}

/**
 * Make a single mounting standoff.
 * @param r1 head (narrowest) radius
 * @param r2 screw (widest) radius
 * @param r3 standoff thickness
 * @param h1 depth of screw
 * @param h2 depth of screw head to end (i.e. total length = h1+h2)
 */
module standoffneg(r1 = defScrewHeadRad, r2 = defScrewRad, r3 = 1.5, h1 = defScrewHeadDepth, h2 = defScrewDepth) {
    difference() {
        translate([0,0,-fudge]) bolthole(r1 = r1, r2 = r2, h1 = h1 + fudge, h2 = h2 + fudge);
        translate([0, 0, h1]) cylinder(r = r1 + r3, h = defLayer);
    }
    //cylinder(r = r3, h = h1 + h2);
}

module standoffpos(r1 = defScrewHeadRad, r2 = defScrewRad, r3 = 1.5, h1 = defScrewHeadDepth, h2 = defScrewDepth) {
    cylinder(r = r1 + r3, h = h1);
    translate([0, 0, h1]) cylinder(r1 = r1 + r3, r2 = r2 + r3,  h = h2);
}

/**
 * Make a set of standoffs for mounting a board.
 * @param r1 head (narrowest) radius
 * @param r2 screw (widest) radius
 * @param r3 standoff thickness
 * @param h1 depth of screw
 * @param h2 depth of screw head to end (i.e. total length = h1+h2)
 * @param x distance to centers in x axis
 * @param y distance to centers in y axis
 */
module standoffspos(r1 = defScrewHeadRad, r2 = defScrewRad, r3 = 1.5, h1 = defScrewHeadDepth, h2 = defScrewDepth, x = 20, y = 20) {
    for (xi = [-0.5:0.5]) {
        for (yi = [-0.5:0.5]) {
            translate([xi * x, yi * y, 0]) {
                cylinder(r = r1 + r3, h = h1);
                translate([0, 0, h1]) cylinder(r1 = r1 + r3, r2 = r2 + r3,  h = h2);
            }
        }
    }
}
/**
 * Make a set of standoffs for mounting a board.
 * @param r1 head (narrowest) radius
 * @param r2 screw (widest) radius
 * @param r3 standoff thickness
 * @param h1 depth of screw
 * @param h2 depth of screw head to end (i.e. total length = h1+h2)
 * @param x distance to centers in x axis
 * @param y distance to centers in y axis
 */
module standoffsneg(r1=defScrewHeadRad, r2=defScrewRad, r3 = 1.5, h1=defScrewHeadDepth, h2=defScrewDepth, x = 20, y = 20) {
    for (xi = [-0.5:0.5]) {
        for (yi = [-0.5:0.5]) {
            translate([xi * x, yi * y, 0]) standoffneg(r1 = r1, r2 = r2, r3 = r3, h1 = h1, h2 = h2, l = defLayer);
        }
    }
}
module standoffs(r1=defScrewHeadRad, r2=defScrewRad, r3 = 1.5, h1=defScrewHeadDepth, h2=defScrewDepth, l = 0.3, x = 20, y = 20) {
    difference() {
        standoffspos(r1 = r1, r2 = r2, r3 = r3, h1 = h1, h2 = h2, x = x, y = y);
        standoffsneg(r1 = r1, r2 = r2, r3 = r3, h1 = h1, h2 = h2, x = x, y = y);
    }
}

/**
 * Make a slot with rounded ends.
 * @param r radius of slot
 * @param l length of slot
 */
module slot2d(r = 3, l = 20) {
    hull() {
        translate([-l / 2, 0, 0]) circle(r = r);
        translate([l / 2, 0, 0]) circle(r = r);
    }
    //cube([l, 2 * r, h], center = true);
}

/**
 * Make a slot with rounded ends.
 * @param r radius of slot
 * @param h height of slot
 * @param l length of slot
 */
module slot(r = 3, h = 5, l = 20) {
    translate([0, 0, -h/2]) linear_extrude(height = h) slot2d(r, l);
    //cube([l, 2 * r, h], center = true);
}

/**
 * Make a cube which has corners rounded in x and y
 * @param size vector containing cube dimensions
 * @param r radius of rounding
 * @param center whether to center the cube
 */
module roundedcube(size, r = 1, center = false) {
    //#cube(size, center = center);
    if (center == false) {
        linear_extrude(height = size[2]) roundedsquare(size, r, center = false);
    } else {
        translate([0, 0, -size[2] / 2]) linear_extrude(height = size[2]) roundedsquare(size, r, center = true);
    }
}

/**
 * Make a cube which has corners rounded in x, y, and z
 * @param size vector containing cube dimensions
 * @param r radius of rounding
 * @param center whether to center the cube
 */
module roundedcube3(size, r = 1, center = false) {
    //#cube(size, center = center);
    minkowski() {
        if (center == false) {
            translate([r, r, r]) cube([size[0] - 2 * r, size[1] - 2 * r, size[2] - 2 * r], center = false);
        } else {
            cube([size[0] - 2 * r, size[1] - 2 * r, size[2] - 2 * r], center = true);
        }
        sphere(r = r);
    }
    /* Doesn't handle center
    hull() {
        for (x = [0:1]) {
            for (y = [0:1]) {
                for (z = [0:1]) {
                    translate([r + (size[0] - 2 * r) * x, r + (size[1] - 2 * r) * y, r + (size[2] - 2 * r) * z]) sphere(r = r);
                }
            }
        }
    }
    */
}
/**
 * Make a square which has rounded corners
 * @param size vector containing cube dimensions
 * @param r radius of rounding
 * @param center whether to center the cube
 */
module roundedsquare(size, r = 1, center = false) {
    //#square(size, center = center);
    minkowski() {
        if (center == false) {
            translate([r, r]) square([size[0] - 2 * r, size[1] - 2 * r], center = false);
        } else {
            square([size[0] - 2 * r, size[1] - 2 * r], center = true);
        }
        circle(r = r);
    }
}

/**
 * Make a wedge of a circle
 * @param r radius of rounding
 * @param a angle of wedge, between 0 and 360
 */
module wedge(r = 7, a = 225) {
    if (a <= 180) {
        difference() {
            circle(r = r);
            translate([-fudge, -r-fudge]) square([r*2+0.1, r*2+0.1], center=true);
            rotate([0,0,a]) translate([-fudge, r+fudge]) square([r*2+0.1, r*2+0.1], center=true);
        }
    }
    if (a > 180) {
        difference() {
            circle(r = r);
            rotate([0,0,a]) wedge(r = r +0.1, a = 360 - a);
        }
    }
}

/**
 * Make a thin-walled box section tube.
 * @param size outside dimensions
 * @param thickness wall thickness
 */
module box2d(size = [10, 5], thickness = 1) {
    difference() {
        square(size);
        translate([thickness, thickness]) square([size[0] - thickness * 2, size[1] - thickness * 2]);
    }
}
/**
 * Make a thin-walled box section tube.
 * @param size outside dimensions
 * @param thickness wall thickness
 */
module box(size = [10, 5, 5], thickness = 1) {
    linear_extrude(height = size[2]) box2d([size[0],size[1]], thickness);
}

/**
 * Make a thin-walled circle.
 * @param r outside radius
 * @param thickness wall thickness
 */
module ring(r = 5, thickness = 1) {
    difference() {
        circle(r);
        polyhole2d(r - thickness);
    }
}

/**
 * Make a thin-walled cylindrical tube.
 * @param r outside radius
 * @param h height of tube
 * @param thickness wall thickness
 */
module tube(r = 5, h = 5, thickness = 1) {
    linear_extrude(height = h) ring(r, thickness);
}

/**
 * Make clips for making a lid fit on a box (use as either positive or negative)
 * @param size x,y dimensions of box
 * @param cliplength length of the clip
 * @param thickness wall thickness
 */
module boxclips(size, cliplength, clipdepth = 3) {
    basex=size[0];
    basey=size[1];
    for (y = [0, basey]) {
        translate([basex/2, y, clipdepth/2]) rotate([45,0,0]) cube([cliplength, clipdepth*0.7, clipdepth*0.7], center=true);
    }
    for (x = [0, basex]) {
        translate([x, basey/2, clipdepth/2]) rotate([0,45,0]) cube([clipdepth*0.7, cliplength, clipdepth*0.7], center=true);
    }
}

/**
 * Make a base which takes a clip on lid
 * @param size outer dimensions of the base
 * @param cliplength length of clips
 * @param clipdepth how deep the clip grips (should be less than Z of size)
 * @param r radius for corner rounding
 */ 
module clipbase(size, cliplength = 10, clipdepth = 3, r = 5) {
    difference() {
        roundedcube(size, r = r);
        boxclips(size, cliplength = cliplength + tolerance * 2, clipdepth = clipdepth);
    }
}

/**
 * Make a lid which clips on to the above base. Uses tolerance to adjust dimensions
 * @param size inner dimensions of the box (not counting base z)
 * @param thickness wall thickness
 * @param cliplength length of clips
 * @param clipdepth how deep the clip grips (should be less than Z of base size)
 * @param r radius for corner rounding
 */ 
module cliplid(size, thickness = 3, cliplength = 10, clipdepth = 3, r = 5) {
    difference() {
        translate([-thickness, -thickness]) roundedcube([size[0] + 2 * thickness, size[1] + 2 * thickness, size[2] + thickness], r = r);
        translate([-tolerance, -tolerance, -fudge]) roundedcube([size[0] + tolerance * 2, size[1] + tolerance * 2, size[2]], r = r);
    }
    translate([-tolerance, -tolerance, 0]) boxclips([size[0] + tolerance * 2, size[1] + tolerance * 2], cliplength = cliplength, clipdepth = clipdepth);
}


module utildemo() {
    translate([5,5]) roundedcube(size=[40,20,10], r=3);
    translate([5,-25,0]) roundedsquare(size=[40,20], r=3);
    translate([-20,5,0]) slot();
    translate([-20,15,0]) wedge();
    translate([-10,-15,0]) bolthole();
    translate([-20,-15,0]) countersink();
    translate([-10,-25,0]) box2d();
    translate([-20,-25,0]) ring();
    translate([-10,-35,0]) box();
    translate([-20,-35,0]) tube();
    translate([-55,-30,0]) standoffs();
}
//utildemo();
//test_polyhole();
