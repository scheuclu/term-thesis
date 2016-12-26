#### import the simple module from the paraview
from paraview.simple import *
#### disable automatic camera reset on 'Show'
paraview.simple._DisableFirstRenderCameraReset()

# find source
fullstructure = GetActiveSource()

numiter=int(raw_input("Please enter the iteration index, you want to plot\n"))
print "you entered", numiter, "\n"

scalefac=float(raw_input("Please enter the scale factor for warping\n"))
print "you entered", scalefac, "\n"

# create a new 'Threshold'
numsubs=int(fullstructure.CellData.GetArray("SUB_ID").GetRange(0)[1])




simplelist = []
for x in range(1, numsubs+1):
    threshold1 = Threshold(Input=fullstructure)
    threshold1.Scalars = ['CELLS', 'SUB_ID']
    threshold1.ThresholdRange = [x, x]

    # get active view
    renderView1 = GetActiveViewOrCreate('RenderView')
    # uncomment following to set a specific view size
    # renderView1.ViewSize = [1563, 1141]

    # hide data in view
    Hide(fullstructure, renderView1)

    # create a new 'Cell Data to Point Data'
    cellDatatoPointData1 = CellDatatoPointData(Input=threshold1)
    # hide data in view
    Hide(cellDatatoPointData1, renderView1)

    # hide data in view
    Hide(threshold1, renderView1)


    # create a new 'Warp By Vector'
    warpByVector0 = WarpByVector(Input=cellDatatoPointData1)
    print ['POINTS', 'displacement_SUBID'+str(x)+'_ITER'+str(numiter)]
    warpByVector0.Vectors = ['POINTS', 'displacement_SUBID'+str(x)+'_ITER'+str(numiter)]
    warpByVector0.ScaleFactor = scalefac
    simplelist.append(warpByVector0)
    RenameSource('SUB_'+str(x)+'_warp_iter', warpByVector0)

    
    RenameSource('SUB_'+str(x)+' selection', threshold1)
    RenameSource('SUB_'+str(x)+' convert', cellDatatoPointData1)


appendDatasets1 = AppendDatasets(Input=simplelist)

Hide(fullstructure, renderView1)

# show data in view
appendDatasets1Display = Show(appendDatasets1, renderView1)
appendDatasets1Display.ColorArrayName = ['POINTS', 'SUB_ID']
RenameSource('Warp_iter_'+str(numiter), appendDatasets1)


#### uncomment the following to render all views
RenderAllViews()
# alternatively, if you want to write images, you can use SaveScreenshot(...).