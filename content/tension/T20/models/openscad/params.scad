// Global Parameters for the IKEA brace

// The Wide Flange is a W250x67

WF_b = 204;    // flange width
WF_t = 15.7;   // flange thickness
WF_d = 257;    // total depth
WF_w = 8.9;    // web thickness
WF_k = 36;     // "k" distance (outside of flange to toe of fillet)
// WF_L = undef;    // total length of W  (see below)

WF_cut_radius = 300;   // radius of flange cut
WF_flange_cut = 40;    // width cut from each flange
// WF_start_cut = undef;  // distance to start of flange cut (see below)
// WF_g = undef;          // bolt gauge  (see below)

// The angles are L102x76x13, short leg bolted to web, long leg outstanding

L_d = 102;     // leg size, out from web
L_b = 76.2;    // leg size, parallel to web
L_t = 12.7;    // leg thickness
L_dg = 65;     // gauge, out from web
L_bg = 45;     // gauge, parallel to web - for bolts through web


// Bolts
Bolt_d = 22;     // bolt hole diameter (actual, not allowance)
Bolt_e = 35;     // end distances
Bolt_n = 4;      // number of bolts each end of angle
Bolt_s = 75;     // bolt spacing

// Gusset Plate
Gusset_t = 25;     // gusset thickness
Gusset_e = Bolt_e;     // edge distance to first bolt
Gusset_gap = 5;       // between gusset plate and end of W
// Gusset_g = undef;    // gusset gauge - see below

// Web Plates (reinforcing)
Plate_t = 8;       // plate thickness
Plate_W = 175;     // plate width
Plate_setback = 10;   // setback from end of web for welding
Plate_L = (Bolt_n-1)*Bolt_s + Bolt_e + Bolt_e - Plate_setback;      // plate length

WF_L = 800;                   // length of W
WF_g = Gusset_t + 2*L_bg;      // gauge distance on WF web
Gusset_g = WF_w + 2*Plate_t + 2*L_dg;    // gauge distance on gusset plate
WF_start_cut = Plate_L + 0;   // start cutting flange this far from big end

WF_T = WF_d - WF_k*2;         // "T" distance - inside of fillet toes = d-2k
if( Plate_W+10 > WF_T ) {
    echo( "Web plate too wide.  Max is", WF_T-10 );
}
w = Gusset_t + L_b*2;         // out-to-out of angles
if( w > WF_T ) {
    echo( "Angles+gusset too wide.  Reduce by", w-WF_T, "Max angle leg is",(WF_T-Gusset_t)/2 );
}

// echo("WF_g =", WF_g, "(gauge on web and gusset)");