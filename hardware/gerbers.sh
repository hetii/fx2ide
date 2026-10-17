#!/bin/bash

# PCB Thickness: 1.6mm
rm -rf kicad/*-jlcpcb* gerbers/

panelize(){
pcb=$1
flatpak run --command=sh org.kicad.KiCad python -m kikit.ui panelize \
  --layout 'grid; rows: 1; cols: 2; space: 2mm' \
  --tabs 'fixed; width: 3mm; vcount: 1' \
  --cuts none \
  --framing 'frame; width: 5mm; space: 2mm' \
  --tooling '4hole; hoffset: 5mm; voffset: 2.5mm; size: 2mm' \
  --fiducials '4fid; hoffset: 10mm; voffset: 3.85mm; coppersize: 1mm; opening: 2mm' \
  --post 'millradius: 1mm' -p :jlcVcuts kicad/${pcb}.kicad_pcb kicad/${pcb}-jlcpcb.kicad_pcb
}

fab(){
panelize ${1}
flatpak run --command=sh org.kicad.KiCad python -m kikit.ui fab \
  jlcpcb kicad/${1}-jlcpcb.kicad_pcb gerbers
  mv gerbers/gerbers.zip gerbers/${1}-jlcpcb.zip
  rm -rf gerbers/gerber/
}

fab fx2ide
