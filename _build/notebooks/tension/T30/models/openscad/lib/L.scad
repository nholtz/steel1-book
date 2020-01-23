module L(d,b,t,l=300,k=undef,r2=undef) {
    k = k==undef ? 2.1*t : k;  // not tabulated for angles
    r1 = k - t;     // radius of leg to leg fillet.
    r2 = r2==undef ? t/3 : r2;    // radius of leg tip fillet
    pts = [[0,0],   // heel at origin
                [b,0],   // leg in x-dir
                [b,t-r2],
                [b-r2,t],
                [t+r1,t],
                [t,t+r1],
                [t,d-r2],
                [t-r2,d],
                [0,d]];
    linear_extrude(height=l) {
        difference() {
            union() {
                polygon(pts);
                translate([t-r2,d-r2,0]) { circle(r=r2); }
                translate([b-r2,t-r2,0]) { circle(r=r2); }
            }
            translate([t+r1,t+r1,0]) {circle(r=r1);}
        }
    }
}

render()  {
    L(203,152,25.4,l=500);  // L203x152x25
}

