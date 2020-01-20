// minimal gusset for 3D printing

include <params.scad>;

d = Bolt_d; // hole diameter
g = Gusset_g;   // gauge, on gusset plate
e = Gusset_e;          // end distance, next to W 
e2 = 30;         // other end distance
n = Bolt_n;           // no of lines of bolts
s = Bolt_s;          // bolt spacing

w = WF_w + 2*Plate_t;   // web thickness
gw = w + 2*L_d + 10;  // gusset width next to W
gt = Gusset_t;             // gusset thickness 
gl = e + (n-1)*s + e2;  // gusset length short leg.

angle = 35;           // angle of cut on end

render() {
    pts = [[0,0],[gw,0],[gw,gl],[0,gl+gw*tan(angle)]];
    difference() {
        translate([0,-gw/2,0]) 
            rotate([0,90,0]) 
                rotate([0,0,90])
                    linear_extrude(height=gt) polygon(pts);
    
    
        for (i = [0:n-1]) {        // the holes
            translate([0,-g/2,e+i*s]) {
                rotate([0,90,0]) { 
                    cylinder(h=100,d=d,center=true); }}
            translate([0,g/2,e+i*s]) {
                rotate([0,90,0]) { 
                    cylinder(h=100,d=d,center=true); }}
        }
    }
}
    