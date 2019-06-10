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

This document is an attempt to show alternative Python programming styles, and to compare them.

The base documents from which the students are working will almost
always use single character identifiers to refer to various physical quantities.  Therefore
there will be a lot of overloading.  For example, _t_ is always a thickness, but context will
tell what thickness it is referring to at any particular instant.

I think it important that the Python code mimic this as closely as is practical. 
But the important part is that the Python not get in the way of understanding the engineering.


### Problem Characteristics

Problems are mostly to compute strengths of specialized physical objects made of structural steel.  These are the general characteristics:
* The simplist problems will have 5 to 10 parameters (usually single numbers specifying a dimension
of a part, or a material characteristics, or an option, etc.).  The most complex problems may have up to 30 or 40 or so parameters.
* In the most complex problems, these parameters may be spread over 5 or 10 different physical parts and a couple of different materials.  Multiple parts could have dimensions that are 
typically referred to using the same name, for example _thickness_, and denoted using the same symbol, _t_.
* Calculations involve fairly small amounts of logic to calculate a specific quantity. Usually that
logic is easily expressible in no more than 5 lines of Python.
* Simple problems may have 5 sets of these calculations; complex problems may have 30 or 40.
* The notebook structure is ideal for this, with one calculation set per cell.
* This is all to support what we call "design" - determining the proper sizes of an object
for structural safety.  In all but the simplese cases, this is trial and error: choose a set
of parameters, calculate a strength; if not right, change something and do it all over.
* Mostly, the calculations are specified by very specific and precise rules and formulae that cover many common 
cases.  In our case, the document is the [CSA S16-14 Design of Steel Structures](https://www.scc.ca/en/standardsdb/standards/27714), supplemented with lecture material.

Below we will perform one typical set of calculations to determine tension strength
with respect to a complete fracture of the cross-section (there are other failure modes).
We will show a number of different ways of structuring the Python to do this, and
discuss the relative merits of each.

**My favorite is currently Alternative 4 - using the 'with' statement.**

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

So the first step is to use normal Python  objects, and use 
attribute values to store the data.  These are essentially just a way of providing multiple
namespaces (i.e., association this instance of _t_ with the correct object).

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
An = AngleB7.A - AngleB7.hd*AngleB7.t  # net x-sect area is gross minus allowance for one hole
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
* harder to read with all those extra (and usually extraneous) identifiers in the expressions.  As expressions get more complex, this gets worse.
* detracts from re-useability of the code.  If this is copied to serve another part, it
will have to be edited (and defining functions to do the calculations is problematic as well - adds
more conceptual overhead).

### Alternative 2:
Extract the required attribute values into global variables at the start of each cell.
We can arrange some special object functionality so that this can be done more compactly (obviously,
the indexing operator returns a tuple of the values of the attributes given as the "index").
The values can even be renamed if that is wise or convenient.

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
Ag,hd,t,n = AngleB7['A,hd,t,nbolts']
Fu = Steel.Fu

An = Ag - hd*t                # net x-sect area is gross minus allowance for one hole
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
* There is obviously more than one way to extract the attribute values - again a bit
more conceptual overhead.

### Alternative 3
Much the same concept as Alternative 2 above, except we provide an 'extract' function 
that more explicitly gets the attribute values.  We made this a function rather than a method
so that we could more easily extract from multiple objects.

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
Ag,hd,t,n,Fu = extract('A,hd,t,nbolts,Fu',AngleB7,Steel)

An = Ag - hd*t                # net x-sect area is gross minus allowance for one hole
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
    An = A - hd*t             # net x-sect area is gross minus allowance for one hole
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
    An = Ag - hd*t       # net x-sect area is gross minus allowance for one hole
    if n >= 4:           # CSA S16-14 12.3.3.2 b)
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
