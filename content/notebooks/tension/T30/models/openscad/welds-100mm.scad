include <params.scad>;

module weld(D,L) {
    pts = [[0,0],[D,0],[0,D]];
    linear_extrude(L) polygon(pts);
}

render() {
    S = 1.25;
    weld(TP_D*S,TP_lw);
    translate([1.5*TP_D*S,0,0]) weld(TP_D*S,TP_lw);
    translate([3.0*TP_D*S,0,0]) weld(TP_D*S,TP_lw);
    translate([4.5*TP_D*S,0,0]) weld(TP_D*S,TP_lw);
}