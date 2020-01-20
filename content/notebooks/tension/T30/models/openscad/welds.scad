include <params.scad>;

module weld(D,L) {
    pts = [[0,0],[D,0],[0,D]];
    linear_extrude(L) polygon(pts);
}

render() {
    weld(TP_D,TP_lw);
    translate([2*TP_D,0,0]) weld(TP_D,TP_lw);
    translate([4*TP_D,0,0]) weld(TP_D,TP_lw);
    translate([6*TP_D,0,0]) weld(TP_D,TP_lw);
    translate([8*TP_D,0,0]) weld(CP_D,CP_lw);
    translate([10*TP_D,0,0]) weld(CP_D,CP_lw);
    translate([12*TP_D,0,0]) weld(CP_D,CP_lw);
    translate([14*TP_D,0,0]) weld(CP_D,CP_lw);
}