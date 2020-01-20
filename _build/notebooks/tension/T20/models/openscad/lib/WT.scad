module WT(b,t,d,w,l=300,k=undef,r1=undef) {
    k = k==undef ? 2.1*t : k;  // the k distance is tabulated in the W tables
    r = k - t;     // radius of stem to flange fillet.
    r1 = r1==undef ? t/4 : r1;    // radius of fillet inside of flange tips
    pts = [[w/2,0],
                [w/2,d-t-r],
                [w/2+r,d-t],
                [b/2-r1,d-t],
                [b/2,d-t+r1],
                [b/2,d],
                [-b/2,d],
                [-b/2,d-t],
                [-b/2,d-t+r1],
                [-b/2+r1,d-t],
                [-w/2-r,d-t],
                [-w/2,d-t-r],
                [-w/2,0]];
    linear_extrude(height=l) {
        difference() {
            union() {
                polygon(pts);
                translate([b/2-r1,d-t+r1,0]) { circle(r=r1); }
                translate([-b/2+r1,d-t+r1,0]) { circle(r=r1); }
            }
            translate([w/2+r,d-t-r,0]) {circle(r=r);}
            translate([-w/2-r,d-t-r,0]) {circle(r=r);}
        }
    }
}

render()  {
    WT(257,21.7,182,13,k=44,l=500);  // WT180x61
}

