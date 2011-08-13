Smooth line UIView
====================

The goal of this project is to create a UIView that can generate smooth lines from touch input in a reasonably fast manner without moving to a more complex framework like OpenGL. 

This view uses two methods of smoothing:

1. **Catmull Rom spline:** (Shows in red.) This seems to have the best results as far as curve smoothing. However it gets _really_ slow over a certain number of points. So I switch interpolation methods to the following for more complex curves…
2. **Bezier Interpolation:** (Shows in green.) This method is very fast and doesn't care how complex the path is. The view uses some math to calculate the control points. The results aren't as good as the Catmull Rom but _much_ faster and with more complex shapes the differences are hard to notice.

### TODO

* Still need to find the best threshold to switch to Bezier from Catmull Rom.

### Examples

* ![alt text](Examples/examples/1.jpg "Drawing")
* ![alt text](Examples/examples/3.jpg "Writing")