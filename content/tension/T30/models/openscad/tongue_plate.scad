include <params.scad>;

render() {
    difference() {
        cube([TP_l,TP_w,TP_t]);
        for (i = [0:BOLT_NT-1]) {        // the holes
            x = BOLT_e + i*BOLT_s;
            for (j = [0:BOLT_NG-1]) {
                y = TP_w/2 - (BOLT_NG-1)*BOLT_g/2 + j*BOLT_g;
                translate([x,y,-1]) cylinder(d=BOLT_hd,h=TP_t+2);
            }
        }
    }
}
