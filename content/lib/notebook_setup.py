import pint

ureg = pint.UnitRegistry()
mm = ureg['mm']
m = ureg['m']
kN = ureg['kN']
N = ureg['N']
MPa = ureg['MPa']
inch = ureg['inch']
ureg.default_format = '~P'
