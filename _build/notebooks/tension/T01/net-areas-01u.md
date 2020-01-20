---
redirect_from:
  - "/notebooks/tension/t01/net-areas-01u"
interact_link: content/notebooks/tension/T01/net-areas-01u.ipynb
kernel_name: python3
has_widgets: false
title: 'T01 v2: Net Areas (notebook with units)'
prev_page:
  url: /notebooks/tension/example_problems_01.html
  title: 'Example Problems'
next_page:
  url: /notebooks/tension/T10/lap-splice-01.html
  title: 'T10: Lap Splice'
comment: "***PROGRAMMATICALLY GENERATED, DO NOT EDIT. SEE ORIGINAL FILES IN /content***"
---

# Example T01u: Net Areas of Plates with Staggered Holes

Determine the net areas to be used when finding the factored tension resistance of the following
plate lap joint.  The net areas may be different for the central (20 mm) and side (10 mm) plates, so determine both.

![Lap PLate Connection](../../../images/tension/T01/lap-plates-1.svg)

**Lap Plate Connection**

Please note that this  type of hole pattern rarely occurs in practice -- 
practical patterns are more regular and 'grid-like'.  This example illustrates:
* how failure paths depend on the direction of the load relative to the hole group.
* the calculations necessary to determine a net cross-sectional area for each potential failure path.

The  figure shows an irregular bolt pattern in a lap tension splice.  To determine the
net areas of the plates, we must examine every possible failure path that has the
following attributes:

* it separates each plate into 2 complete parts.
* it is of minimum length for that path.
* there are no bolts or holes completely on the loaded side of the path; all of the bolt bearing areas are on the side opposite the load.

We then determine the area from the path with minimum width.

In this example, we will assume M20 bolts in punched holes, and thus the hole
allowance to be used is $d = 20~\mathrm{mm}+2~\mathrm{mm}+2~\mathrm{mm} = 24~\mathrm{mm}$.


#### Compute with units

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
import pint                   # setup to use the module for computing with units
ureg = pint.UnitRegistry()
mm = ureg['mm']
ureg.default_format = '~P'

# if you do not want to use units, simply uncomment the following line:
# mm = 1
```
</div>

</div>

## The 10mm Plates (outer plates)

The  shows the paths appropriate for investigating the strength of the outside (10mm) plates.
For this case, the loaded side of the connection is toward the right side, and so there are
no complete holes on that side of any path.

![Failure Paths for Net Area Calculations, Outside (10mm) plates](../../../images/tension/T01/paths-1i.svg "Failure Paths for Net Area Calculations, Outside (10mm) plates")

**Failure Paths for Net Area Calculations, Outside (10mm) plates**

### Define the Data:

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
d = (20 + 2 + 2) * mm       # hole allowance: bolt dia. + 2mm clearance + 2mm for punching
s1 = 50 * mm
s2 = 55 * mm
s3 = 50 * mm
g1,g2,g3,g4,g5 = (35,50,45,50,30) * mm
t1 = 10 * mm                # thickness of one outside plate
t2 = 20 * mm                # thickness of inside plate
wg = g1+g2+g3+g4+g5
print('wg =',wg)                         # gross width of plate
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
wg = 210 mm
```
</div>
</div>
</div>

In the following, we will compute the net width, $w_n$, for each failure path, then use the minimum so computed to determine the cross-sectional area.

### Path 1-1:
For path 1-1, it is only necessary to deduct the allowance for one hole from the gross width.
In general, if no path segments are inclined to the load:

$w_n = w_g - \sum d$

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
wn_11 = wg - d
wn_11
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">



<div markdown="0" class="output output_html">
186 mm
</div>


</div>
</div>
</div>

### Path 2-2:
For paths with segments inclined to the load, we subtract all hole allowances, $d$, then
add the $s^2/4g$ correction term for each inclined segment:

$w_n = w_g - \sum d + \sum{s^2\over 4g}$

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
wn_22 = wg - 2*d + s3**2/(4*g3)
wn_22
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">



<div markdown="0" class="output output_html">
175.88888888888889 mm
</div>


</div>
</div>
</div>

### Path 3-3:

$w_n = w - \sum d + \sum{s^2\over 4g}$

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
wn_33 = wg - 3*d + s3**2/(4*g3) + s2**2/(4*g2)
wn_33
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">



<div markdown="0" class="output output_html">
167.01388888888889 mm
</div>


</div>
</div>
</div>

### Paths 1-4, 2-4 and 3-4:

Adding the fourth bolt to each of the above paths will reduce the net width by $24~\mathrm{mm}$
for the hole, then
increase it by $(s2+s3)^2/(4 g4)$ for the inclined segment.  Paths that include this hole will not govern if the term for the inclined segment is less than 24.  However, given that these variable values might change, its probably safest to compute them all.

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
delta = (s2+s3)**2/(4*g4) - d    # the amount wn increases by including the hole on path 4
wn_14 = wn_11 + delta
wn_24 = wn_22 + delta
wn_34 = wn_33 + delta
delta, wn_14, wn_24, wn_34
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">


{:.output_data_text}
```
(31.125 mm, 217.125 mm, 207.01388888888889 mm, 198.13888888888889 mm)
```


</div>
</div>
</div>

### Summary

The path with the smallest $w_n$ governs,
so $A_n$ for the pair of 10 mm plates is:

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
wn = min(wn_11,wn_22,wn_33,wn_14,wn_24,wn_34)
wn
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">



<div markdown="0" class="output output_html">
167.01388888888889 mm
</div>


</div>
</div>
</div>

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
An = wn * t1*2    # because there are 2 thicknesses of 10 mm plate
An
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">



<div markdown="0" class="output output_html">
3340.277777777778 mm<sup>2</sup>
</div>


</div>
</div>
</div>

## 20mm Plate (Inner Plate)

The following figure  shows the possible failure paths for calculating the strength of the 20mm plate.
For this case, the loaded side is toward the left.

![Failure Paths for Net Area Calculations, Inside (20mm) plate](../../../images/tension/T01/paths-2i.svg)

**Failure Paths for Net Area Calculations, Inside (20mm) plate**

### Path 1-1:

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
wn_11 = wg - d
wn_11
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">



<div markdown="0" class="output output_html">
186 mm
</div>


</div>
</div>
</div>

### Path 2-2:

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
wn_22 = wg - 2*d + s1**2/(4*g2)
wn_22
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">



<div markdown="0" class="output output_html">
174.5 mm
</div>


</div>
</div>
</div>

### Path 2-3:

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
wn_23 = wg - 3*d + s1**2/(4*g2) + s1**2/(4*(g3+g4))
wn_23
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">



<div markdown="0" class="output output_html">
157.07894736842104 mm
</div>


</div>
</div>
</div>

### Path 1-3:

By inspection this should not govern, as path 1-1 is longer than 2-2, therefore 1-3 will be longer than 2-3.

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
wn_13 = wg - 2*d + s1**2/(4*(g3+g4))
wn_13
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">



<div markdown="0" class="output output_html">
168.57894736842104 mm
</div>


</div>
</div>
</div>

### Summary

The shortest path (minimum $w_n$) governs, and so the net area, $A_n$, of the 20 mm plate is:

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
wn = min(wn_11,wn_22,wn_23,wn_13)
wn
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">



<div markdown="0" class="output output_html">
157.07894736842104 mm
</div>


</div>
</div>
</div>

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
An = wn * t2
An
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">



<div markdown="0" class="output output_html">
3141.578947368421 mm<sup>2</sup>
</div>


</div>
</div>
</div>

The net area fracture strength of the plates will therefore be governed by the net area of the inner plate.
