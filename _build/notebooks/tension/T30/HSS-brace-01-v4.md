---
redirect_from:
  - "/notebooks/tension/t30/hss-brace-01-v4"
interact_link: content/notebooks/tension/T30/HSS-brace-01-v4.ipynb
kernel_name: python3
has_widgets: false
title: 'T30 v4: HSS Brace'
prev_page:
  url: /notebooks/tension/T30/HSS-brace-01-v3.html
  title: 'T30 v3: HSS Brace'
next_page:
  url: /notebooks/Programming-Style.html
  title: 'Programming Style'
comment: "***PROGRAMMATICALLY GENERATED, DO NOT EDIT. SEE ORIGINAL FILES IN /content***"
---

# Example T30 v3: HSS Brace Analysis
The photo shows the end details of a typical brace in a 4-storey steel structure.  This was photographed in Ottawa, in September, 2015.

This notebook shows the computations necessary to compute the factored tension resistance, $T_r$, for a similar brace.  **Note**, all of the dimensions and properties were invented by the author of this notebook; no attempt has been made to have an accurate model of the real structure.

![Brace End Details](/images/tension/T30/brace.jpg)

![Overall Sketch](/images/tension/T30/brace-sketch.svg)

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
from Designer import DesignNotes, SST, makePart
import math
sind = lambda deg: math.sin(math.radians(deg))  # return sin of angle expressed in degrees
cosd = lambda deg: math.cos(math.radians(deg))  # return cos of angle expressed in degrees
```
</div>

</div>

**Setup the units system**

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
import pint                  # setup to use the module for computing with units
ureg = pint.UnitRegistry()
mm = ureg['mm']              # define symbols for the units used below
inch = ureg['inch']
kN = ureg['kN']
MPa = ureg['MPa']
ureg.default_format = '~P'
```
</div>

</div>

The various $\phi$ values used below:

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
phiw = 0.67    # S16-14 13.1
phiu = 0.75
phib = 0.80
phibr = 0.80
phi = 0.90
```
</div>

</div>

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
notes = DesignNotes('Tr',title='Typical HSS Cross Brace',units=kN,trace=True)

# useful abbreviations:
REQ = notes.require       # a requirement
CHK = notes.check         # a check
REC = notes.record        # record calculation details
```
</div>

</div>

## Design Parameters
Most of the design parameters from the above figure are defined here.  A few are augmented or defined below where there are more detailed figures available.

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
@makePart
class Bolts:
    'Bolts'   # bolt group is the same on the tongue plate and on the gusset plate.
    grade = 'ASTM A325'
    size = '3/4"'
    Fu = 825*MPa
    d = (3/4*inch).to(mm)
    hole_type = 'punched'
    hd = 22*mm            # hole diameter
    ha = hd + 2*mm        # hole allowance
    threads_intercepted = True
    nlines = 2            # a line is perpendicular to load
    nperline = 3          # number of bolts in each line
    g = 75*mm             # gauge (perpendicular to load)
    s = 75*mm             # spacing (parallel to load)

@makePart
class Welds:
    'Welds'
    grade = 'E49xx'
    Xu = 490*MPa
    matching = True

@makePart
class Plates:
    'Plates'
    grade = 'CSA G40.21 350W'
    Fy = 350*MPa
    Fu = 450*MPa

@makePart
class HSS:
    'HSS Column'
    grade = 'CSA G40.21 350W'
    size = 'HS127x127x13'
    Fy = 350*MPa
    Fu = 450*MPa
    
D,T,A = SST.section(HSS.size,'D,T,A')
HSS.set( D = D*mm,
         T = T*mm,
         A = A*mm*mm,
       )

@makePart
class CoverPlate:
    'Cover Plate'
    T = 10*mm
    W = 60*mm
    Lw = 90*mm      # length of weld from net section to end of HSS
    D = 6*mm        # size of weld from on HSS.
CoverPlate.inherit(Plates)
   
@makePart
class TonguePlate:
    'Tongue Plate'
    T = 20*mm
    W = 280*mm
    L = 260*mm
    e = 40*mm
TonguePlate.inherit(Plates)

@makePart
class GussetPlate: 
    'Gusset Plate'
    W2 = 110*mm
    e = 40*mm    # end distance
    D = 8*mm     # plate to column weld size
    theta = 45.         
GussetPlate.inherit('T,W',TonguePlate).inherit(Plates)
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">


{:.output_data_text}
```
<Designer.Part at 0x7f9bc4fc8fd0>
```


</div>
</div>
</div>

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
Bolts('g,s,Fu,d').show()
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
_doc = A Portion of Bolts 
d    = 19.05 mm
Fu   = 825   MPa
g    = 75    mm
s    = 75    mm
```
</div>
</div>
</div>

## Bolting and Welding Details

TBD: Here we should check all spacings, edge distances, etc.

## Gusset Plate
![Gusset Plate Details](/images/tension/T30/gusset-details.svg)

### Gusset to HSS Weld

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
with GussetPlate('W,W2,theta,D'),Welds('Xu'):
    L1 = W2+W*cosd(theta)
    L = (L1/sind(theta))*cosd(theta) + W*sind(theta)

    Mw = 1.0                  
    Aw = 2*L*.707*D
    Vr = 0.67*phiw*Aw*Xu*(1+sind(theta)**1.5)*Mw     # S16-14: 13.13.2.2

    REC(Vr,'Gusset to HSS Weld','W,W2,L1,L,D,theta,Aw,Mw,phiw,Vr')
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_data_text}
```
    Gusset to HSS Weld: Tr = 2008 kN
       (W=280mm, W2=110mm, L1=308.0mm, L=506.0mm, D=8mm, theta=45.0, Aw=5724mm², Mw=1.0, phiw=0.67, Vr=2008000MPa·mm²)
```

</div>
</div>
</div>

### Gusset Block Shear
Because the gusset must be the same thickness as the tongue, and as the edges align so they are the
same width (mostly), the block shear strengths determined here should be the same.  So this section is not
really necessary.  The tongue does have one more pattern (Pattern 3)) that is judged not applicable
here because of the increased width of the gusset.
#### Block Shear Case 1)

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
with Bolts('nlines,nperline,g,s,ha'),GussetPlate('W,e,T,Fy,Fu'):
    An = T*((nperline-1)*g - (nperline-1)*ha)
    Agv = 2*T*((nlines-1)*s + e)
    Ut = 1.0
    Vr = phiu*(Ut*An*Fu + 0.6*Agv*(Fy+Fu)/2.)     # S16-14: 13.2 a) ii) & 13.11
    REC(Vr,'Gusset Block Shear Case 1)','Ut,An,Agv,Fy,Fu,Vr')
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_data_text}
```
    Gusset Block Shear Case 1): Tr = 1516 kN
       (Ut=1.0, An=2040mm², Agv=4600mm², Fy=350MPa, Fu=450MPa, Vr=1516000MPa·mm²)
```

</div>
</div>
</div>

#### Block Shear Case 2)

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
with Bolts('nlines,nperline,g,s,ha'),GussetPlate('W,e,T,Fy,Fu'):
    edge = (W - (nperline-1)*g)/2.
    An = (((nperline-1)*g+edge)-(nperline-0.5)*ha)*T
    Agv = T*((nlines-1)*s + e)
    Ut = 0.8
    Vr = phiu*(Ut*An*Fu + 0.6*Agv*(Fy+Fu)/2.)    # S16-14: 13.2 a) ii) & 13.11
    REC(Vr,'Gusset Block Shear Case 2)','edge,Ut,An,Agv,Vr')
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_data_text}
```
    Gusset Block Shear Case 2): Tr = 1251 kN
       (edge=65.0mm, Ut=0.8, An=3100mm², Agv=2300mm², Vr=1251000MPa·mm²)
```

</div>
</div>
</div>

#### Tearout

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
with Bolts('nlines,nperline,s'),GussetPlate('e,T,Fy,Fu'):    
    Agv = T*((nlines-1)*s + e) * nperline * 2
    Vr = phiu * 0.6*Agv*(Fy+Fu)/2.               # S16-14: 13.2 a) ii) & 13.11
    REC(Vr,'Gusset tearout','Agv,Vr')
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_data_text}
```
    Gusset tearout: Tr = 2484 kN
       (Agv=13800mm², Vr=2484000MPa·mm²)
```

</div>
</div>
</div>

## Lap Plates (2)
### Lap Plate Details
Consider the thickness of both plates together when computing the resistance.
As the plate is symmetric, we only have to investigate one end.

![Lap Plate Details](/images/tension/T30/lap-plate-details.svg)

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
@makePart
class LapPlates:
    'Lap Plates'
    W = 230*mm
    L = 315*mm
    T = 10*mm*2.      # thickness, include 2 plates
    e = 40*mm         # could be different than gusset
LapPlates.inherit(Plates)
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">


{:.output_data_text}
```
<Designer.Part at 0x7f9bc5009518>
```


</div>
</div>
</div>

### Lap Plates: Gross Section Yield

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
with LapPlates('W,T,Fy'):
    Ag = W*T
    Tr = phi*Ag*Fy          # S16-14: 13.2 a) i)
    REC(Tr,'Lap Plates, Gross Yield','W,T,Ag,Fy,phi')
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_data_text}
```
    Lap Plates, Gross Yield: Tr = 1449 kN
       (W=230mm, T=20.0mm, Ag=4600mm², Fy=350MPa, phi=0.9)
```

</div>
</div>
</div>

### Lap Plates: Net Section Fracture

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
with LapPlates('W,T,Fu'),Bolts('nperline,ha'):
    wn = W - nperline*ha
    Ane = An = wn*T
    Tr = phiu*Ane*Fu          # S16-14: 13.2 a) iii)
    REC(Tr,'Lap Plates, Net Fracture','W,T,ha,wn,phiu,Ane,Fu')
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_data_text}
```
    Lap Plates, Net Fracture: Tr = 1066 kN
       (W=230mm, T=20.0mm, ha=24mm, wn=158mm, phiu=0.75, Ane=3160mm², Fu=450MPa)
```

</div>
</div>
</div>

### Lap Plates: Block Shear
#### Block Shear Case 1)

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
with LapPlates('T,e,W,Fy,Fu'),Bolts('ha,nperline,nlines,s,g'):
    An = ((nperline-1)*g - (nperline-1)*ha)*T
    Agv = (e + (nlines-1)*s)*T*2
    Ut = 1.0
    Vr = phiu*(Ut*An*Fu + 0.6*Agv*(Fy+Fu)/2.)        # S16-14: 13.2 a) ii) & 13.11
    REC(Vr,'Lap Plates, Block Shear Case 1)','An,Agv,Ut,Fy,Fu,Vr')
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_data_text}
```
    Lap Plates, Block Shear Case 1): Tr = 1516 kN
       (An=2040mm², Agv=4600mm², Ut=1.0, Fy=350MPa, Fu=450MPa, Vr=1516000MPa·mm²)
```

</div>
</div>
</div>

#### Case 2)

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
with LapPlates('T,e,W,Fy,Fu'),Bolts('ha,nperline,nlines,s,g'):
    edge = (W - (nperline-1)*g)/2.0
    An = (W - (edge-ha/2) - nperline*ha)*T
    Agv = (e + (nlines-1)*s)*T
    Ut = 0.8
    Vr = phiu*(Ut*An*Fu + 0.6*Agv*(Fy+Fu)/2.)       # S16-14: 13.2 a) ii) & 13.11
    REC(Vr,'Lap Plates, Block Shear Case 2)','W,T,edge,An,Agv,Ut,Vr')
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_data_text}
```
    Lap Plates, Block Shear Case 2): Tr = 1116 kN
       (W=230mm, T=20.0mm, edge=40.0mm, An=2600mm², Agv=2300mm², Ut=0.8, Vr=1116000MPa·mm²)
```

</div>
</div>
</div>

#### Case 3)

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
with LapPlates('T,e,W,Fy,Fu'),Bolts('ha,nperline,nlines,s,g'):
    An = (W - nperline*ha - (g-ha))*T
    Agv = (e + (nlines-1)*s)*T * 2.
    Ut = 0.6
    Vr = phiu*(Ut*An*Fu + 0.6*Agv*(Fy+Fu)/2.)        # S16-14: 13.2 a) ii) & 13.11
    REC(Vr,'Lap Plates, Block Shear Case 3)','An,Agv,Ut,Vr')
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_data_text}
```
    Lap Plates, Block Shear Case 3): Tr = 1261 kN
       (An=2140mm², Agv=4600mm², Ut=0.6, Vr=1261000MPa·mm²)
```

</div>
</div>
</div>

#### Tearout

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
with LapPlates('T,e,W,Fy,Fu'),Bolts('ha,nperline,nlines,s,g'):
    An = 0*mm*mm
    Agv = (e + (nlines-1)*s)*T*2*nperline
    Ut = 1
    Vr = phiu*(Ut*An*Fu + 0.6*Agv*(Fy+Fu)/2.)        # S16-14: 13.2 a) ii) & 13.11
    REC(Vr,'Lap Plates, tearout','Agv,Vr')
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_data_text}
```
    Lap Plates, tearout: Tr = 2484 kN
       (Agv=13800mm², Vr=2484000MPa·mm²)
```

</div>
</div>
</div>

## Tongue Plate
### Tongue Plate Details
![Tongue Plate Details](/images/tension/T30/tongue-plate-details.svg)

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
TonguePlate.set(
        D = 8*mm,       # weld size
        c = 45*mm,      # dist end of weld to 1st bolt line     
        )
L,c,e = TonguePlate['L,c,e']
TonguePlate.set(
      Lw = L - (c + (Bolts.nlines-1)*Bolts.s + e),
      Dh = SST.section(HSS.size,'D')*mm,
     )
```
</div>

</div>

### Tongue Plate: Bolted End
#### Gross Section Yield

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
with TonguePlate('W,T,Fy'):
    Ag = W*T
    Tr = phi*Ag*Fy                # S16-14: 13.2 a) i)
    REC(Tr,'Tongue Plate, Gross Yield','W,T,Ag,Fy')
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_data_text}
```
    Tongue Plate, Gross Yield: Tr = 1764 kN
       (W=280mm, T=20mm, Ag=5600mm², Fy=350MPa)
```

</div>
</div>
</div>

#### Net Section Fracture

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
with TonguePlate('W,T,Fu'),Bolts('ha,nperline'):
    wn = W - nperline*ha
    Ane = An = wn*T
    Tr = phiu*Ane*Fu              # S16-14: 13.2 a) iii)
    REC(Tr,'Tongue Plate, Bolted End, Net Section Fracture','W,T,wn,Ane,Fu')
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_data_text}
```
    Tongue Plate, Bolted End, Net Section Fracture: Tr = 1404 kN
       (W=280mm, T=20mm, wn=208mm, Ane=4160mm², Fu=450MPa)
```

</div>
</div>
</div>

#### Block Shear, Case 1)

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
with TonguePlate('T,e,W,Fy,Fu'),Bolts('ha,nperline,nlines,s,g'):
    An = ((nperline-1)*g - (nperline-1)*ha)*T
    Agv = (e + (nlines-1)*s)*T*2
    Ut = 1.0
    Vr = phiu*(Ut*An*Fu + 0.6*Agv*(Fy+Fu)/2.)     # S16-14: 13.2 a) ii) & 13.11
    REC(Vr,'Tongue Plate, Block Shear Case 1)','An,Agv,Ut,Fy,Fu,Vr')
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_data_text}
```
    Tongue Plate, Block Shear Case 1): Tr = 1516 kN
       (An=2040mm², Agv=4600mm², Ut=1.0, Fy=350MPa, Fu=450MPa, Vr=1516000MPa·mm²)
```

</div>
</div>
</div>

#### Block Shear, Case 2)

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
with TonguePlate('T,e,W,Fy,Fu'),Bolts('ha,nperline,nlines,s,g'):
    edge = (W - (nperline-1)*g)/2.0
    An = (W - (edge-ha/2.) - nperline*ha)*T
    Agv = (e + (nlines-1)*s)*T
    Ut = 0.8
    Vr = phiu*(Ut*An*Fu + 0.6*Agv*(Fy+Fu)/2.)      # S16-14: 13.2 a) ii) & 13.11
    REC(Vr,'Tongue Plate, Block Shear Case 2)','edge,An,Agv,Ut,Vr')
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_data_text}
```
    Tongue Plate, Block Shear Case 2): Tr = 1251 kN
       (edge=65.0mm, An=3100mm², Agv=2300mm², Ut=0.8, Vr=1251000MPa·mm²)
```

</div>
</div>
</div>

#### Block Shear, Case 3)

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
with TonguePlate('T,e,W,Fy,Fu'),Bolts('ha,nperline,nlines,s,g'):
    An = (W - nperline*ha - (g-ha))*T
    Agv = (e + (nlines-1)*s)*T * 2.
    Ut = 0.6
    Vr = phiu*(Ut*An*Fu + 0.6*Agv*(Fy+Fu)/2.)       # S16-14: 13.2 a) ii) & 13.11
    REC(Vr,'Tongue Plate, Block Shear Case 3)','An,Agv,Ut,Vr')
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_data_text}
```
    Tongue Plate, Block Shear Case 3): Tr = 1464 kN
       (An=3140mm², Agv=4600mm², Ut=0.6, Vr=1464000MPa·mm²)
```

</div>
</div>
</div>

#### Block Shear, Tearout

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
with TonguePlate('T,e,W,Fy,Fu'),Bolts('ha,nperline,nlines,s,g'):
    An = 0*mm*mm
    Agv = (e + (nlines-1)*s)*T*2*nperline
    Ut = 1
    Vr = phiu*(Ut*An*Fu + 0.6*Agv*(Fy+Fu)/2.)       # S16-14: 13.2 a) ii) & 13.11
    REC(Vr,'Tongue Plate tearout','Agv,Vr')
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_data_text}
```
    Tongue Plate tearout: Tr = 2484 kN
       (Agv=13800mm², Vr=2484000MPa·mm²)
```

</div>
</div>
</div>

### Tongue Plate: Welded End
#### Shear Lag - Effective Net Area

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
with TonguePlate('W,w2=Dh,L=Lw,T,Fu'):
    if L >= 2*w2:             # S16-14: 12.3.3.3 b)
        An2 = 1.00*w2*T
    elif L >= w2:
        An2 = 0.5*w2*T + 0.25*L*T
    else:
        An2 = 0.75*L*T

    w3 = (W-w2)/2.            # S16-14: 12.3.3.3 c)
    xbar = w3/2.
    if L >= w3:
        An3 = (1.-xbar/L)*w3*T
    else:
        An3 = 0.50*L*T
    Ane = An2 + An3 + An3     # S16-14: 12.3.3.3 
    Tr = phiu*Ane*Fu
    REC(Tr,'Tongue Plate, Welded End, Net Section Fracture','w2,w3,An2,An3,Ane')
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_data_text}
```
    Tongue Plate, Welded End, Net Section Fracture: Tr = 1144 kN
       (w2=127.0mm, w3=76.5mm, An2=1500mm², An3=944.8mm², Ane=3390mm²)
```

</div>
</div>
</div>

## Fasteners
### Bolts
#### Shear

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
with Bolts('d,Fu,threads_intercepted,s,nlines,nperline'):
    n = nlines*nperline             # no. of bolts
    m = 2                           # no. of faying surfaces
    Ab = 3.14159*d*d/4.
    Vr = 0.6*phib*n*m*Ab*Fu         # S16-14: 13.12.1.2 c)
    L = (nlines-1)*s
    if L >= 760*mm:
        Vr = (0.5/0.6)*Vr
    if threads_intercepted:
        Vr = 0.7*Vr
    REC(Vr,'Bolts in Shear','n,m,d,Ab,Fu,Vr')
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_data_text}
```
    Bolts in Shear: Tr = 948.1 kN
       (n=6, m=2, d=19.05mm, Ab=285.0mm², Fu=825MPa, Vr=948100MPa·mm²)
```

</div>
</div>
</div>

#### Bearing

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
with Bolts('d,nlines,nperline'),TonguePlate('Fu'):
    n = nlines*nperline
    t = min(GussetPlate.T,TonguePlate.T,2*LapPlates.T)
    Br = 3*phibr*n*t*d*Fu          # S16-14: 13.12.1.2 a)
    REC(Br,'Bolts in Bearing','n,t,d,Fu')
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_data_text}
```
    Bolts in Bearing: Tr = 2469 kN
       (n=6, t=20mm, d=19.05mm, Fu=450MPa)
```

</div>
</div>
</div>

### Welds - HSS to Tongue Plate

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
with TonguePlate('L=Lw,D'),Welds('Xu,matching'):
    Aw = 4.*L*D*0.707
    Vr = 0.67*phiw*Aw*Xu           # S16-14: 13.13.2.2
    if matching:
        REC(Vr,'Fillet Weld (HSS to Plate)','D,L,Aw,Xu')
    else:
        raise Exception('Non matching electrodes')
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_data_text}
```
    Fillet Weld (HSS to Plate): Tr = 497.6 kN    <<<--- GOVERNS
       (D=8mm, L=100mm, Aw=2262mm², Xu=490MPa)
```

</div>
</div>
</div>

## HSS + Cover Plate
![HSS Details](/images/tension/T30/hss-details.svg)

### Net Section Fracture

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
with HSS('D,th=T,A,Fyh=Fy,Fuh=Fu'),CoverPlate('tp=T,wp=W,Fyp=Fy,Fup=Fu'),TonguePlate('tt=T,Lw'):
    Fy = min(Fyh,Fyp)     # use min properties of plate & HSS (conservative)
    Fu = min(Fuh,Fup)

    h = D/2. - th - tt/2.  # height of vertical leg
    xbar = (2.*h*th*h/2. + D*th*(h+th/2.) + wp*tp*(h+th+tp/2.))/(2*h*th + D*th + wp*tp)
    Ag = A + 2*wp*tp       # gross area of HSS + cover plates
    An = Ag - 2.*tt*th     # net area, remove slots cut for tongue
    if xbar/Lw > 0.1:                 # S16-14: 12.3.3.4
        Ane = (1.1 - xbar/Lw)*An
    else:
        Ane = An
    Tr = phiu*Ane*Fu                # S16-14: 13.2 a) iii)
    REC(Tr,'HSS Net Section Fracture','xbar,Lw,D,th,A,Ag,An,Ane,Fu');
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_data_text}
```
    HSS Net Section Fracture: Tr = 1422 kN
       (xbar=40.71mm, Lw=100mm, D=127.0mm, th=12.7mm, A=5390mm², Ag=6590mm², An=6082mm², Ane=4214mm², Fu=450MPa)
```

</div>
</div>
</div>

### Gross Section Yield
Of HSS _without_ coverplate.

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
with HSS('A,Fy'):
    Ag = A
    Tr = phi*Ag*Fy          # S16-14: 13.2 a) i)
    REC(Tr,'HSS Gross Section Yield','Ag,Fy');
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_data_text}
```
    HSS Gross Section Yield: Tr = 1698 kN
       (Ag=5390mm², Fy=350MPa)
```

</div>
</div>
</div>

## Cover Plate to HSS Weld
Ensure that the length of the weld can develop the full strength of the cover plate, between
the slot end (@ minimum x-sect area) and end of HSS.

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
with CoverPlate('T,W,L=Lw,D,Fy,Fu'),Welds('Xu'),CoverPlate('Fy,Fu'):
    Aw = 0.707*D*L*2.
    Vr = (0.67*phiw*Aw*Xu*1*1).to(kN)            # S16-14: 13.13.2.2, weld strength, to one side
    Tr = (phi*(T*W)*Fy).to(kN)                   # S16-14: 13.2 a) i) gross section yield, of cover Plate

    CHK(Vr>=Tr,'Coverplate weld strength, gross yield','L,D,Aw,Vr,Tr')

    An = W*T                             # S16-14: 12.3.3.3 b)
    if L >= 2*W:                         # Ane of plate
        An2 = W*T
    elif L >= W:
        An2 = 0.5*W*T + 0.25*L*T
    else:
        An2 = 0.75*L*T
    Ane = An2
    Tr = (phiu*An2*Fu).to(kN)         # S16-14: 13.2 a) iii)
    CHK(Vr>=Tr,'Coverplate weld strength, net fracture','L,W,An2,Ane,Vr,Tr');
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
    Coverplate weld strength, gross yield?  NG! *****
      (L=90mm, D=6mm, Aw=763.6mm², Vr=168.0kN, Tr=189.0kN)
    Coverplate weld strength, net fracture?  NG! *****
      (L=90mm, W=60mm, An2=525.0mm², Ane=525.0mm², Vr=168.0kN, Tr=177.2kN)
```
</div>
</div>
</div>

## To Do
* Alterrnate method for cover plate wld check: Compute Tr with and without cover plate.  Diff is the reqd force
in the cover plate. Ensure welds can develop that.
* Check that gusset plate doesn't cause undue flexural problems in the flange of the HSS column member.

## Bolting Details

### Lap Plates

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
with LapPlates('W,T,L,e'),Bolts('s,g,nlines,nperline,d'):

    minedge = 32*mm                # S16-14: 22.3.2 Table 6, 3/4" bolt, sheared edge
    maxedge = min(150*mm,12.*T)    # S16-14: 22.3.3
    minend = 32*mm                 # S16-14: 22.3.4
    minpitch = 2.7*d               # S16-14: 22.3.1

    edge = (W - (nperline-1)*g)/2.
    CHK(edge>=minedge,'Bolt min edge distance, lap plate','edge,minedge',)
    CHK(edge<=maxedge,'Bolt max edge distance, lap plate','edge,maxedge',)
    CHK(e>=minend,'Bolt min end distance, lap plate','e,minend',)
    CHK(s>=minpitch and g>=minpitch,'Bolt spacing, lap plate','s,g,minpitch')
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
    Bolt min edge distance, lap plate?  OK 
      (edge=40.0mm, minedge=32mm)
    Bolt max edge distance, lap plate?  OK 
      (edge=40.0mm, maxedge=150mm)
    Bolt min end distance, lap plate?  OK 
      (e=40mm, minend=32mm)
    Bolt spacing, lap plate?  OK 
      (s=75mm, g=75mm, minpitch=51.43mm)
```
</div>
</div>
</div>

### Tongue Plate

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
# TODO
```
</div>

</div>

### Gusset Plate

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
# TODO
```
</div>

</div>

## Welding Details

### HSS to Tongue

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
# TODO
```
</div>

</div>

### Cover PLate to HSS

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
# TODO
```
</div>

</div>

## Summary

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
notes.summary()
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```

Summary of DesignNotes for Tr: Typical HSS Cross Brace
======================================================

Checks:
-------
    Coverplate weld strength, gross yield?    NG! *****
      (L=90mm, D=6mm, Aw=763.6mm², Vr=168.0kN, Tr=189.0kN)
    Coverplate weld strength, net fracture?   NG! *****
      (L=90mm, W=60mm, An2=525.0mm², Ane=525.0mm², Vr=168.0kN, Tr=177.2kN)
    Bolt min edge distance, lap plate?        OK 
      (edge=40.0mm, minedge=32mm)
    Bolt max edge distance, lap plate?        OK 
      (edge=40.0mm, maxedge=150mm)
    Bolt min end distance, lap plate?         OK 
      (e=40mm, minend=32mm)
    Bolt spacing, lap plate?                  OK 
      (s=75mm, g=75mm, minpitch=51.43mm)

Values of Tr:
-------------
    Gusset to HSS Weld:                             Tr = 2010 kN
    Gusset Block Shear Case 1):                     Tr = 1520 kN
    Gusset Block Shear Case 2):                     Tr = 1250 kN
    Gusset tearout:                                 Tr = 2480 kN
    Lap Plates, Gross Yield:                        Tr = 1450 kN
    Lap Plates, Net Fracture:                       Tr = 1070 kN
    Lap Plates, Block Shear Case 1):                Tr = 1520 kN
    Lap Plates, Block Shear Case 2):                Tr = 1120 kN
    Lap Plates, Block Shear Case 3):                Tr = 1260 kN
    Lap Plates, tearout:                            Tr = 2480 kN
    Tongue Plate, Gross Yield:                      Tr = 1760 kN
    Tongue Plate, Bolted End, Net Section Fracture: Tr = 1400 kN
    Tongue Plate, Block Shear Case 1):              Tr = 1520 kN
    Tongue Plate, Block Shear Case 2):              Tr = 1250 kN
    Tongue Plate, Block Shear Case 3):              Tr = 1460 kN
    Tongue Plate tearout:                           Tr = 2480 kN
    Tongue Plate, Welded End, Net Section Fracture: Tr = 1140 kN
    Bolts in Shear:                                 Tr = 948 kN
    Bolts in Bearing:                               Tr = 2470 kN
    Fillet Weld (HSS to Plate):                     Tr = 498 kN    <<<--- GOVERNS
    HSS Net Section Fracture:                       Tr = 1420 kN
    HSS Gross Section Yield:                        Tr = 1700 kN

    Governing Value:
    ----------------
       Tr = 498 kN
```
</div>
</div>
</div>

## Notes

* The factored resistance of this component is low, governed by the weld of the HSS to the tongue plate.  Its capacity is 498 kN, almost 1/2 of the next lowest item (the shear strength of the bolts).
* To increase the overall strength, the first thing to do would be to increase length of that weld from 100mm to something considerably larger. 200mm of weld would require increasing the length of tongue from 280mm to 380mm but would double that strength at very small cost.
* The cover plate welding to the HSS may be inadequate as it is shown. Increasing the length of the HSS to tongue weld will leave space for more weld on the cover plate, up to 190mm on one side of the minimum cross-section, which should be more than enough.
* Increasing the HSS to tongue plate weld length may also increase $T_r$ for _Tongue Plate, Welded End, Net Section Fracture_ and _HSS Net Section Fracture_.
