// reinforcing plate on web, 2 required.

include <params.scad>;

d = Bolt_d;     // hole diameter
g = WF_g;    // gauge, across 
e1 = Bolt_e - Plate_setback;    // end distance, at end of WF
s = Bolt_s;   // pitch
n = Bolt_n;     // number of transverse lines of bolts-

T = Plate_t;      // thickness of plate
W = Plate_W;    // width of plate
L = Plate_L;   // length of plate

render() {
    difference() {
        translate([0,0,L/2]) cube( [T,W,L], center=true );
        
        for (i = [0:n-1]) {        // the holes
            translate([0,-g/2,e1+i*s]) {
                rotate([0,90,0]) { 
                    cylinder(h=100,d=d,center=true); }}
            translate([0,g/2,e1+i*s]) {
                rotate([0,90,0]) { 
                    cylinder(h=100,d=d,center=true); }}
        }
    }
}