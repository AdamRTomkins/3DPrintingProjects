// Parts for wine/mead making siphon
// by Len Trigg <lenbok@gmail.com>


include<utils.scad>


tubeRad = 9.5 / 2;  // Radius of siphon tube. Measure this.

module siphoncap() {
    height = 15;   // Height of attachment: taller means less able to fully empty the flagon
    padding = 3;   // Width of space through which fluid can flow
    thickness = 1.4; // Thickness of printed walls

    innerRad = tubeRad + padding;
    outerRad = innerRad + thickness;

    difference() {
        cylinder(r = outerRad, h = height);
        difference() {
            translate([0, 0, thickness]) cylinder(r = tubeRad + padding, h = 20);
            for (r = [0, 120, 240]) {
                rotate([0,0,r]) {
                    translate([-thickness/2, -innerRad, thickness]) cube([thickness, innerRad, padding]);
                    translate([-thickness/2, -innerRad, thickness]) cube([thickness, padding, height]);
                }
            }
        }
    }
}

module siphonclip() {
    thickness = 3.5;
    clipthickness = 5;
    tubeheight = 30;
    clipheight = tubeheight +20;
    outerRad = tubeRad + thickness;
    clipRad = 6.75;
    clipOuterRad = clipRad + clipthickness;
    outerHeight = outerRad * 2;
    translate([tubeRad + thickness * 2 / 3, 0, outerRad]) rotate([-90,0,0]) linear_extrude(height = tubeheight) difference() {
        ring(r = outerRad, thickness = thickness);
        translate([0, -thickness/2, -fudge]) square([tubeRad * 2, thickness]);
    }
    linear_extrude(height=outerHeight) {
        translate([-clipthickness, 0]) square([clipthickness, clipheight]);
        translate([-clipthickness/2, 0]) circle(r=clipthickness/2,$fn=4);
        translate([-clipthickness-clipRad, clipheight]) difference() {
            wedge(r=clipRad+clipthickness, a=200);
            wedge(r=clipRad);
        }
        
        rotate([0,0,0]) translate([-clipOuterRad - clipRad * sin(70), clipheight - clipRad * cos(70)]) rotate([0,0,200]) square([clipthickness, clipheight - 15]); // The 15 here needs manual adjustment if you change other parameters

        translate([-clipthickness-tolerance-clipOuterRad*1.5, 10.3]) rotate([0,0,-70]) difference() { // The z of this translate needs manual adjustment
            wedge(r=clipOuterRad*1.5, a=90);
            wedge(r=clipOuterRad*1.5-clipthickness);
        }
}
}

siphonclip();


