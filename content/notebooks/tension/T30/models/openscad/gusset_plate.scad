include <params.scad>;

echo(GP_w,GP_w2,GP_l1,GP_l);

render() {
    pts = [[0,0],
    	   [GP_l1/sin(GP_theta),0],
	   [GP_w2*sin(GP_theta),GP_l*sin(GP_theta)],
	   [0,GP_w]];
    difference() { // change to intersection to see only tip
        difference() {
            linear_extrude(GP_t) polygon(pts);
            for (i = [0:BOLT_NT-1]) {        // the holes
                x = BOLT_e + i*BOLT_s;
                for (j = [0:BOLT_NG-1]) {
                    y = GP_w/2 - (BOLT_NG-1)*BOLT_g/2 + j*BOLT_g;
                    translate([x,y,-1]) cylinder(d=BOLT_hd,h=GP_t+2);
                }
            }
        }
        // mask out the tip, otherwise too large to print
        translate([180,0,-1]) linear_extrude(50)
            polygon([[0,0],[200,0],[200,200],[0,200],[0,100],[10,90],[-10,70],[0,60]]);
    }

}