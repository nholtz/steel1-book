include <params.scad>;

d = Bolt_d;     // hole diameter
g = WF_g;    // gauge, across 
e = Bolt_e;    // end distance
s = Bolt_s;   // pitch
n = Bolt_n;     // number of transverse lines of bolts-

B = WF_b;    // The W Shape
T = WF_t;
D = WF_d;
W = WF_w;
K = WF_k;
L = WF_L;   // length of W
rcut = WF_cut_radius;   // radius of flange cut
bcut = WF_flange_cut;   // width cut from each flange
angle = acos((rcut-bcut)/rcut);
H = WF_start_cut + rcut*sin(angle);    // height at which flange is fully cut

use <lib/W.scad>

render() {
     difference() {
        W(D,B,T,W,k=K,l=L);
        for (i = [0:n-1]) {        // the holes
            translate([0,-g/2,e+i*s]) {
                rotate([0,90,0]) { 
                    cylinder(h=100,d=d,center=true); }}
            translate([0,g/2,e+i*s]) {
                rotate([0,90,0]) { 
                    cylinder(h=100,d=d,center=true); }}
        }
        translate([B/2-bcut+rcut,0,H])  // the flange cuts
            rotate([90,0,0]) 
                cylinder(h=1.1*D,d=2*rcut,center=true,$fn=120);
        translate([-B/2+bcut-rcut,0,H]) 
            rotate([90,0,0]) 
                cylinder(h=1.1*D,d=2*rcut,center=true,$fn=120);
        dx = bcut+10;
        dy = D+10;
        dz = L-H+10;
        translate([dx/2+B/2-bcut,0,dz/2+H])
            cube(size=[dx,dy,dz],center=true);
        translate([-dx/2-B/2+bcut,0,dz/2+H])
            cube(size=[dx,dy,dz],center=true);
    }
}