include <params.scad>;

use <lib/HSS.scad>;

render () {
    difference() {
        HSS(HSS_d,HSS_b,HSS_t,l=HSS_l);
        translate([-TP_t/2,-TP_w/2,-(TP_l-TP_lw)]) 
            cube([TP_t,TP_w,TP_l]);
    }
}
