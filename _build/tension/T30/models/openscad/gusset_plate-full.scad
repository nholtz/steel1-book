// additional plate to glue on to make up for sgorter w2

include <params.scad>;

module gplate(w2) {
    GP_w2 = w2;
    GP_l1 = GP_w2 + GP_w*cos(GP_theta);   // dist out to furthest pt
    GP_l = GP_l1*tan(GP_theta) + GP_w*sin(GP_theta);
    pts = [[0,0],
    	   [GP_l1/sin(GP_theta),0],
	       [GP_w2*sin(GP_theta),GP_l*sin(GP_theta)],
	       [0,GP_w]];
    linear_extrude(GP_t) polygon(pts);
}


echo(GP_w,GP_w2,GP_l1,GP_l);

render() {
    difference() {
        gplate(110);
        gplate(GP_w2);
    }
}