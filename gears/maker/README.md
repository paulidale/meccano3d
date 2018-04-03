# Meccano gear maker

Create Meccano compatible gears from 19 to 133 teeth, to fit round or triflat axles, with or without a boss.

First time setup: edit the OpenSCAD file and change the dxf_path variable to match the directory where you unzipped the DXF files.

Making a gear: edit the parametric values in the source to create the gear you want, render the model, export it to an STL file, slice and print. Repeat as required.

I make no claims to be an OpenSCAD expert. This is primarly an attempt to get the ball rolling by making some Meccano related OpenSCAD stuff available. Some folk might glean some insight from it; conversely someone might tell me all the things I've done wrong and I might learn something from it! Either way, it's a win.

As is usual with open source code, no warranty is expressed or implied.

Wayne Hortensius
April 2, 2018


Wayne also wrote on Spanner:

For anyone else wanting to create additional gear outlines, here's the
settings that I changed in the gear builder:

Circular pitch:
For the 38 DP gears, it's 2.09990666845 (25.4*pi/38)
For the 37.5 DP gears, it's 2.127905424 (25.4*pi/37.5)

I've used 0.01 for both clearance and backlash (but that may be
something that you'll have to tweak for your particular printer setup),
and 10 for rotation steps per tooth angle. I did have to reduce that to
7 or so for the 133 tooth gear or the builder crashed and burned.
Everything else I left at the defaults; so far, so good. Visually, the
printed gears appear to be dead on when superimposed on a metal
original.

In case you're wondering, the 114 tooth outline produces a 3" gear that
matches 4 #129 rack segments. And the 121 tooth outline is for the
main slew gear in the recent tower crane set.
