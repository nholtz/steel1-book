// Global Parameters for Dimon brace

// The HSS is a HSS 127x127x13 G40.20

HSS_d = 127.0;
HSS_b = 127.0;
HSS_t = 12.7;
HSS_l = 250.0;    //length of HSS for model

// The tongue plate (welded into slot in HSS)

TP_t = 20.0;
// TP_w = 280.0;  // width of plate
TP_w = 250.0;
TP_l = 250.0;   // total length
TP_lw = 100.0;  // length of welded portion

// cover plate (welded on HSS)

CP_t = 10;
CP_w = 60;
CP_l = 200;
CP_setback = 10;
CP_lw = CP_l;

// welds

TP_D = 8;
CP_D = 6;

// Bolts

BOLT_d = 20;    // diameter
BOLT_hd = BOLT_d + 2;    // hole diameter
// BOLT_s = 75;             // longitudinal spacing (pitch)
// BOLT_g = 75;             // transverse spacing (gauge)
BOLT_s = 70;             // longitudinal spacing (pitch)
BOLT_g = 70;             // transverse spacing (gauge)
BOLT_NG = 3;             // number of gauge lines (across)
BOLT_NT = 2;             // number of transverse lines
// BOLT_e = 40;		 // end distance
BOLT_e = 35;		 // end distance

// Gusset plate

GP_w = TP_w;
GP_t = TP_t;
// GP_w2 = 110;
GP_w2 = 70;
GP_theta = 45;
GP_l1 = GP_w2 + GP_w*cos(GP_theta);   // dist out to furthest pt
GP_l = GP_l1*tan(GP_theta) + GP_w*sin(GP_theta);
// GP_gap = 10;		// gap to tongue plate
GP_gap = 5;		// gap to tongue plate

// Lap Plate

LP_t = 10;
LP_w = 230;
LP_l = 2*(BOLT_NT-1)*BOLT_s + 4*BOLT_e + GP_gap;


// misc.

$fn = 60;       // number of sides for poly approx to circles
