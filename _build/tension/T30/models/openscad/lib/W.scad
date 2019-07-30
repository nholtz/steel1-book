module W(d,b,t,w,l=300,k=undef,r2=undef) {
    k = k==undef ? 2.25*t : k; 
    r1 = k - t;     // radius of web to flange fillet.
    r2 = r2==undef ? t/4 : r2;    // radius of inside flange tip fillet
    b2 = b/2;
    d2 = d/2;
    w2 = w/2;
    pts = [ [-b2,-d2],   // 0 - top left flange tip
                [-b2,-d2+(t-r2)],   // 1
                [-b2+r2,-d2+t],
                [-w2-r1,-d2+t],  // 3
                [-w2,-d2+t+r1],
                [-w2,d2-t-r1],      // 5
                [-w2-r1,d2-t],
                [-b2+r2,d2-t],     // 7
                [-b2,d2-(t-r2)],
                [-b2,d2],             // 9
                [b2,d2],             // 10
                [b2,d2-(t-r2)],
                [b2-r2,d2-t],     // 12
                [w2+r1,d2-t],
                [w2,d2-t-r1],      // 14
                [w2,-d2+t+r1],
                [w2+r1,-d2+t],  // 16
                [b2-r2,-d2+t],
                [b2,-d2+(t-r2)],   // 18
                [b2,-d2]   // 19 - top right flange tip
               ];
    linear_extrude(height=l) {
        difference() {
            union() {
                polygon(pts);
                translate([-b2+r2,-d2+t-r2,0]) { circle(r=r2); }
                translate([b2-r2,-d2+t-r2,0]) { circle(r=r2); }
                translate([-b2+r2,d2-t+r2,0]) { circle(r=r2); }
                translate([b2-r2,d2-t+r2,0]) { circle(r=r2); }
            }
            translate([-w2-r1,-d2+t+r1,0]) {circle(r=r1);}
            translate([w2+r1,-d2+t+r1,0]) {circle(r=r1);}
            translate([-w2-r1,d2-t-r1,0]) {circle(r=r1);}
            translate([w2+r1,d2-t-r1,0]) {circle(r=r1);}
        }
    }
}

render()  {
    W(354,205,16.8,9.4,k=39,l=1000);  // W360x79
}

