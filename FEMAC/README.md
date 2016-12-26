![Image](./doc/logo_viridis.png)

# FEMAC- Finite Elements Matlab Code

Provides core Finite Elements functionality that other projects can be built upon.
___
## Features
### Current

 - Structural Mechanics formulation
 - St. Venant Kirchoff material implemented
 - Quad4 and Tri3 Elements supported, but further elements can be easily added
 - Linear elasticity
 - GMSH Input
 - VTK Output
 - Full simulation- pre- and postprocessing-control via .dat-file
 - Arbitrary Dirichlet and Neumann Conditions possible(e.g. line conditions)
 - File Selection via GUI
 - L2-Error calculator
 - Separation of pre-processing, main calculation and post-processing
 - FETI
   - Solvers
     - FETI2
     - FETIS
   - Features
     - combined and single-substructure output
     - output of iteration steps possible

### Planned
 - Support for dynamic problems
 - Non-linear formulation
 - Non-conforming meshes
 - MPCG for FETI
___
### Examples

##### Basic Example
A very basic exapmple is provided in
```m
$ >> ./examples/core/inmanual_outmatlab.m
```
It gives insight into the internam geometry representation and condition specification.
Elements and Conditions are created and managed manually.

##### Other Examples
Further, full-featured examples are provided in the ./examples folder

___
### Usage

The repository provides 4 basic routines:
 - femac_pre.m
 - femac_main.m
 - femac_post.m
 - femac.m

#### femac_pre.m
Reads the mesh-file, generates all Discretization object and writes the results to the .dis-file in binary format.
```m
$ >> femac_pre(<dat-file path>)
```

#### femac_main.m
Starts the calculation from a pre-genearated binary .dis-file.
When the primary solution has been obtained, the results are written to the .res-file
```m
$ >> femac_main(<dat-file path>)
```

#### femac_post.m
Starts the calculation from a pre-genearated binary .res-file.
When the primary solution has been read from the file, the post-processing is started.
```m
$ >> femac_post(<dat-file path>)
```

#### femac.m
Starts the calculation directly from the .msh-file.
Basically calls femac_pre.m, femac_main.m and femac_post.m subsequently on the same .dat-file.
```m
$ >> femac(<dat-file path>)
```
If the user provides no arguments, a GUI-window opens in order to select a .dat-file
see ./examples/core/patchtest.m for a full-featured dat-file.
Have a look into ./examples for valid .dat-files
___
### Version
0.9