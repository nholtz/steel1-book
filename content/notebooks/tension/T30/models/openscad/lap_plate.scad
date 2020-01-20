include <params.scad>;

render() {
    difference() {
        cube([LP_l,LP_w,LP_t]);
        for (i = [0:BOLT_NT-1]) {        // the holes
            x = BOLT_e + i*BOLT_s;
            x2 = LP_l - x;
            for (j = [0:BOLT_NG-1]) {
                y = LP_w/2 - (BOLT_NG-1)*BOLT_g/2 + j*BOLT_g;
                translate([x,y,-1]) cylinder(d=BOLT_hd,h=LP_t+2);
                translate([x2,y,-1]) cylinder(d=BOLT_hd,h=LP_t+2);
            }
        }
    }
}
