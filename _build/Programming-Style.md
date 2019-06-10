---
redirect_from:
  - "programming-style"
interact_link: content/Programming-Style.ipynb
kernel_name: python3
has_widgets: false
title: 'Programming Style'
prev_page:
  url: /steel_1
  title: 'Steel Design'
next_page:
  url: /tension/tension
  title: 'Tension Members'
comment: "***PROGRAMMATICALLY GENERATED, DO NOT EDIT. SEE ORIGINAL FILES IN /content***"
---

## Programming Style

This book is intended to teach 3rd year Civil Engineering students about the design
of structural steel components.

It is not intended to teach Python programming, though it is hoped that eventally
they will be able to make small modifications to any of the notebooks and see the effect.

But the important part is that the Python not get in the way of understanding the engineering.

The base documents from which the students are working will almost
always use single character identifiers to refer to various physical quantities.  Therefore
there will be a lot of overloading.  For example, _t_ is always a thickness, but context will
tell what thickness it is referring to at any particular instant.

I think it important that the Python code mimic this as closely as is practical.

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
from Designer import Part, extract
import pint                  # setup to use the module for computing with units
ureg = pint.UnitRegistry()
mm = ureg['mm']
kN = ureg['kN']
MPa = ureg['MPa']
ureg.default_format = '~P'
```
</div>

</div>

### Typical Data Definition
I think we can agree that we will not use simple global variables to refer to various
physical quantities.  In a more complex problem than shown here, we would have
```t1```, ```t2```, ```t3``` or ```t_angle```, ```t_gusset```, ```t_plate```, etc.
to refer to the various thicknesses.  It becomes unwieldy and makes the code less re-usable.

So the first step is to use normal Python objects, and use attribute values to store the data.

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
Steel = Part( "Material for Angles",
            grade = "CSA G40.21 350W",
            Fy = 350*MPa,      # yield strength
            Fu = 450*MPa,      # ultimate strength
            )

AngleB7 = Part( "Brace B-7",
            size = "L152x102x16",
            d = 152*mm,        # width of longest leg
            b = 102*mm,        # width of shortest leg
            t = 15.9*mm,       # thickness
            A = 3780*mm*mm,    # gross cross-sectional area
            hd = 24*mm,        # bolt hole diameter allowance
            nbolts = 4,        # number of bolts in direction of load
            )
```
</div>

</div>

### Alternative 1:
We just refer to attributes of the objects using the normal Python dot notation.
Nothing special.

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
An = AngleB7.A - AngleB7.hd*AngleB7.t
if AngleB7.nbolts >= 4:         # CSA S16-14 12.3.3.2 b)
    Ane = 0.8*An                #                        i)
else:
    Ane = 0.6*An                #                        ii)
Tr = 0.9*Ane*Steel.Fu
Tr.to(kN)
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">



<div markdown="0" class="output output_html">
1101.0816000000002 kN
</div>


</div>
</div>
</div>

**Pros:**
* bog-standard Python, no additional libraries/concepts required.  Students should be able to 
understand all the Python bits after their first course.
* small number of global variables (2, in this case), with smaller chance of them being stepped
on in the notebook.
* very explicit.  there is no doubt what the _t_ belongs to in the first line.

**Cons:**
* harder to understand with all those extra (and usually extraneous) identifiers in the expressions.  As expressions get more complex, this gets worse.

### Alternative 2:
Extract the required attribute values into global variables at the start of each cell.
We can arrange some special functionality so that this can be made more compact (obviously,
the indexing operator returns a tuple of the values of the attributes given as the "index").
The values can even be renamed if that is wise or convenient.

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
Ag,hd,t,n = AngleB7['A,hd,t,nbolts']
Fu = Steel.Fu

An = Ag - hd*t
if n >= 4:                    # CSA S16-14 12.3.3.2 b)
    Ane = 0.8*An
else:
    Ane = 0.6*An
Tr = 0.9*Ane*Fu
Tr.to(kN)
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">



<div markdown="0" class="output output_html">
1101.0816000000002 kN
</div>


</div>
</div>
</div>

**Pros:**
* fairly compact and explicit extraction of the values needed for this cell.
* not a lot of conceptual overhead.  Students should be able to work past this with little trouble.
* variables can be renamed to better suit the problem.

**Cons:**
* Values become global variables that can accidently step on existing ones, or pollute the
following cells by defining symbols, such as _t_, that shouldn't be defined later.
* Overloads the indexing functionality, which is not standard Python, and  some people
may find that weird or hard to understand.
* Their is obviously more than one way to extract the attribute values - again a bit
more conceptual overhead.

### Alternative 3
Much the same concept as Alternative 2 above, except we provided and 'extract' function 
that more explicitly gets the attribute values.  We made this a function rather than a method
so that we could extract from multiple objects.

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
Ag,hd,t,n,Fu = extract('A,hd,t,nbolts,Fu',AngleB7,Steel)

An = Ag - hd*t
if n >= 4:                    # CSA S16-14 12.3.3.2 b)
    Ane = 0.8*An
else:
    Ane = 0.6*An
Tr = 0.9*Ane*Fu
Tr.to(kN)
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">



<div markdown="0" class="output output_html">
1101.0816000000002 kN
</div>


</div>
</div>
</div>

**Pros:**
* much the same as Alternative 2, plus:
* more traditional Python.  May be easier for neophytes to understand.
* ability to get some inheritance.  For example, ```Steel``` is to give the properties of all
angles, except ```Fu``` could be transparently over-ridden by ```AngleB7``` - a sort of inheritance.

**Cons:**
* pretty much the same as Alternative 2.

### Alternative 4
Make the ```Part``` objects be context managers.  They inject all their attribute values
into the global namespace at the beginning of the block, and undo all those changes
at the end of the block.  Could even make them produce warnings if values are over-ridden
(for example, if ```t``` was aleady defined before the beginning of the block) 
(don't currently do that).

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
with Steel,AngleB7:
    An = A - hd*t
    if nbolts >= 4:           # CSA S16-14 12.3.3.2 b)
        Ane = 0.8*An
    else:
        Ane = 0.6*An
    Tr = 0.9*Ane*Fu
Tr.to(kN) 
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">



<div markdown="0" class="output output_html">
1101.0816000000002 kN
</div>


</div>
</div>
</div>

**Pros:**
* by far the most compact and least textual overhead.
* scope of some variables is limited.  The value of ```t``` used in this block disappears at
the end of the block. This may be **HUGELY** good. (Although new variables like ```Ane```
are still permanently injected into the global namespace).
* as the objects in the ```with``` statement are processed left-to-right, we get
an automatic inheritance mechanism (```Angle87``` over-rides the same named attributes
from ```Steel```).  This can also be a bad thing, of course.

**Cons:**
* fair bit of conceptual overhead to understanding this.  It is probably 'advanced' Python.
Students will probably not see this in a first course taught to engineers.
* cannot rename the variables - must use the attribute names defined in the object (this _may_
actually be a good thing).
* source of values is not explicit.  For example, where does _t_ come from? From reading just this,
you cannot tell whether it is ```Steel.t``` or ```AngleB7.t```.

### Alternative 5
Have all computations done in a function, where the parameter list names the local values.  Then you can write a little utility that automatically extracts the values from the objects:

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
def fun1(Ag,hd,t,n,Fu):
    An = Ag - hd*t
    if nbolts >= 4:           # CSA S16-14 12.3.3.2 b)
        Ane = 0.8*An
    else:
        Ane = 0.6*An
    Tr = 0.9*Ane*Fu
    return Tr.to(kN)

# call(fun1,(Steel,AngleB7),n='nbolts',Ag='A')   # or something like this
```
</div>

</div>

**Pros:**
* explicitly limited scope of variables, including newly created ones like ```Ane```.

**Cons:**
* I don't like it.
