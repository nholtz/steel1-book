include <params.scad>;

module weld(D,L) {
    pts = [[0,0],[D,0],[0,D]];
    linear_extrude(L) polygon(pts);
}

render() {
    S = 1.25;
    weld(CP_D*S,CP_lw);
    translate([1.5*CP_D*S,0,0]) weld(CP_D*S,CP_lw);
    translate([3.0*CP_D*S,0,0]) weld(CP_D*S,CP_lw);
    translate([4.5*CP_D*S,0,0]) weld(CP_D*S,CP_lw);
}