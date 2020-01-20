module HSSsolid(d,b,r) {
    d2 = d/2;
    b2 = b/2;
    pts = [ [b2,d2-r],     // upper right corner
            [b2-r,d2],
            [-(b2-r),d2],  // upper left
            [-b2,d2-r],
            [-b2,-(d2-r)],  // lower left
            [-(b2-r),-d2],
            [b2-r,-d2],     // lower right
            [b2,-(d2-r)]];
    union() {
        polygon(pts);
        translate([b2-r,d2-r,0]) circle(r=r,$fn=60);
        translate([-(b2-r),d2-r,0]) circle(r=r,$fn=60);
        translate([-(b2-r),-(d2-r),0]) circle(r=r,$fn=60);
        translate([b2-r,-(d2-r),0]) circle(r=r,$fn=60);
    }
}


module HSS(d,b,t,l=300,r1=undef,r2=undef) {    
    r1 = r1 == undef ? 2*t : r1;
    r2 = r2 == undef ? r1-t : r2;
    
    linear_extrude(height=l) {
        difference() {
            HSSsolid(d,b,r1);
            HSSsolid(d-2*t,b-2*t,r2);
        }
    }
}

module HSS_round(od,t,l=300) {
    difference() {
        cylinder(d=od,h=l,$fn=60);
        cylinder(d=od-2*t,h=l,$fn=60);
    }
}

render() {
    HSS(152.4,101.6,12.7); // HSS 152x102x13  (G40)
    translate([0,0,-300]) HSS_round(168.3,12.7); // HSS 168x13
}
    