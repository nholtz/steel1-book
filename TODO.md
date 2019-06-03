# Notes for the Future

## Other example problems

* get examples from ca-steel-design/Steel-1, particularly 'Tension-Members/Single-Bolted-Angle'

## Changes to S16

* If we properly tag code (and markdown) cells with S16 references,
  we might be able to develop tools to help with updates when a new version
  comes out. 
  
  For example:

        ## S16-14: 13.2 b) ii)
        Tr2 = phiu*Anet*Fu
        Tr3 = 0.6*phiu*Anes*Fu    # S16-14: 13.2 b) iii)
  
* This would be useful for design notebooks as well as teaching notebooks.

* Tools to:
  * Scan for all sections referenced
  * Locate cells that use a changed section
  * Update tags for new S16 (for unchanged sections)
  * Ease hand editing for changed sections
  
* Use git to manage changes (from S16-09 to S16-14, for eg)

* Use S16-09 to S16-14 as a test case.

* Should we use cell metadata for this?  Might be the only way to tag text cells (markdown cells).
