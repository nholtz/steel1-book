// Angle type 2 - 2 required.

include <params.scad>;

d = Bolt_d;     // hole diameter
gl = L_dg;    // gauge, on long leg  (D leg)
gs = L_bg;   // gauge, on short leg (B leg)
e = Bolt_e;    // end distance
s = Bolt_s;   // pitch
gap = Bolt_e + Gusset_e + Gusset_gap;   // between innermost bolts
n = Bolt_n;     // number of transverse lines of bolts

B = L_b;    // The Angle
T = L_t;
D = L_d;
L = 2*e+2*((n-1)*s)+gap;    // length of L

use <lib/L.scad>

render() {
    difference() {
        L(D,B,T,l=L);
        
        for (i = [0:n-1]) {        // the holes
            translate([gs,0,L-(e+i*s)]) {
                rotate([90,0,0]) { 
                    cylinder(h=100,d=d,center=true); }}
            translate([0,gl,(e+i*s)]) {
                rotate([0,90,0]) { 
                    cylinder(h=100,d=d,center=true); }}
       }
   }
}