$ErrorActionPreference = "Continue"
$PrinterName = "TERMICA"
$Port = 5055
$BaseDir = "C:\GatoCalavera"
$LogDir = Join-Path $BaseDir "logs"
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
$LogFile = Join-Path $LogDir "print-service.log"
$LogoWidthBytes = 64
$LogoHeight = 218
$LogoRasterB64 = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA////////////////////////////////8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAH/////////////////////////////////+AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP//////////////////////////////////8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP///////////////////////////////////wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP////////////////////////////////////AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP////////////////////////////////////8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP//gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAH//wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAH/+AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAH/+AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD/8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP/4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD/4D////////////////////////////////+Af/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB/8H/////////////////////////////////8D/4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/8H//////////////////////////////////wP/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAf8H/gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAf/A/4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP+H+AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP8H/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAH/D+AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/g/4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB/j+AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD+H+AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/x+AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPw/wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAf4+AAAAAAAH//gAAPB4OA//////wAf/wAAAAAAA+H+AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP8fAAAAAAAP///AAP///4f/////+B///wAAAAAAHw/gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD+PgAAAAAAP///4AH////v//////h////AAAAAAA+H8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB/jwAAAAAAH8AB/gD4///7v////+4////4AAAAAAHh/gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAfx4AAAAAAD5//58B82+2P7/////vfP/+fAAAAAAA8P4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP48AAAAAAB7///vgPvfzv+/////7vf//54AAAAAAHh/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD+fAAAAAAA9///94D///77z////5/v///vAAAAAAB4fwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB/HgAAAAAAO////vAP///8ff///+/3///9wAAAAAAPD+AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAfzwAAAAAAHv///9wD///uPP////39////eAAAAAAB4/gAAAAAAAAAAAAAAAAAAAAAAYAAwAAAAAAAAAAAAAAAH48AOADgAB3////cA7//7jv////++////7gABwAcAeH4AAAAAAAAAAAAAAAAAAAAAAPgA+AAAAAAAAAAAAAAAD+eAHwB8AAd/wA//gO/3+47AD/gBvv+AP+4AA+APgDh/AAAAAAAAAAAAAAAAAAAAAAP+A/wAAAAAAAAAAAAAAA/ngD+A/gAHf7/3/wDv8/uOf/f//z7/f9/uAAfwH8A8fwAAAAAAAAAAAAAAAAAAAAAH/wf/AAAAAAAAAAAAAAAPx4B7we8AB3//9//A7+v/j//3//++/v//7gAPeD3gPD8AAAAAAAAAAAAAAAAAAADwD//f/4B4AAAAAAAAAAAAD88A8ePHgAd///c/4P/v/8f/9////v7//+4AHjx48B4/AAAAAAAAAAAAAAAAAAAB/x/////H/AAAAAAAAAAAAB/PAe73m8AHf/Hu2+H/7/3H4Hf/A/7+4P/uAD3e83geP4AAAAAAAAAAAAAAAAAAA/////////4AAAAAAAAAAAAfjwPffz3gB3/54eHh/+/9w8B3/wHu/uD/7gB77+e8Hh+AAAAAAAAAAAAAAAAAAAf/////////AAAAAAAAAAAAH44D37594Ad/8f//wd/t/cAAd/8ADv7g/+4Ae/fPvA4fgAAAAAAAAAAAAAAAAAAH/////////wAAAAAAAAAAAB+OAe/c+8AHf/D//4Hf/f3AAHf/AA7+4P/uAD37n3gOH4AAAAAAAAAAAAAAAAAAD///8AB///+AAAAAAAAAAAAfngD36feAB3/wPz8B393/wAB3/wAO/uD/7gAe/T7wDh+AAAAAAAAAAAAAABAAAB//8AAAAH//wAAA4AAAAAAAH54Ae/fvAAd/8AAAAd/d/+AAd/8ADv7g/+4AD3794A8fgAAAAAAAAAAAAAB8AP///wAAAAAH///4A/AAAAAAAB+eAD3/3gAHf/AAAAH/3f/gAHf/AA7+4P/uAAe/+8APH4AAAAAAAAAAAAAA/wH///gAAAAAAP///AfwAAAAAAA/ngAe/7wAB3/wAAAD/9/+4AB3/wAO/uD/7gAD3/eADx+AAAAAAAAAAAAAAP/B///AAAAAAAAf//wf+AAAAAAAP54AD394AAd/+H4/A//f/uAAd/8ADv7g/+4AAe/vAA8fgAAAAAAAAAAAAAH/4//+AAH///wAA//+f/gAAAAAAD+eAA9/eAAHf/n//4O//v7wAHf/AA7+4P/uAAHv7wAPH4AAAAAAAAAAAAAB//v/8AA/////4AD//v/8AAAAAAA/ngAe/7wAB3/z///Pv/7/eAB3/4AO/vH/7gAD3/eADx+AAAAAAAAAAAAAAf///8AD//////4AH////AAAAAAAP54APf/eAB9//8Hh/3++/34A9/vAP//73/+AB7/7wA8fgAAAAAAAAAAAAAP///8AH///////wAf///wAAAAAAD+eAHv37wAe//+eu/7/vv++Ae/74D3/f9/3gA9+/eAPH8AAAAAAAAAAAAAD///8AH//wAAf//AB///8AAAAAf//ngD36/eAHP//73/9/77/zwHP/eB7/7+/+8Ae/X7wDx///wAAAAAAAAAAA/v/+AP/8AAAAH/+AP/9/gAAAB///54B7937wB7/9//3v/+//94B7/vgPf9/3/eAPfu/eA8f///gAAAAAAAAAAPx/+AP/wAAAAAH/4B/8f4AAAD///+eA9++/eAPf/P39x7/v/+8Aff7wB7/+//vAHv337wPH////AAAAAAAAAAD8H/wP/gAAAAAAP/g/+D+AAAD////ngPff33gB3/4d/cP//9/uAB3/4AO/uD/7gB77++8Dx////8AAAAAAAAAA/A/+P/gAAAAAAA/+f/A/gAAD////54B7ve7wAd/+Hf3B///f7gAd/8ADv7g/+4APd73eA8f////wAAAAAAAAAPwH///AAAAAAAAB///gP4AAD////8eAPXj18AHf/B39w//d3+4AHf/AA7+4P/uAB68evgPD/////AAAAAAAAAD8Af//AAAAAAAAAH//wD+AAB//wAAHgB7we+AB3/wd/cO/39/uAB3/wAO/uD/7gAPeD3wDwAAA//4AAAAAAAAA/AD//AAB////wAAf/4A/gAA//gAAB4AP4D/AAd/8Hf3Dv9/f7gAd/8ADv7g/+4AB/Af4A8AAAA//gAAAAAAAAPwAf/AAP/////8AB/8AP4AA//AP//+AB8AfgAHf/B39w7/f//4AHf/AA7+4P/uAAPgD8AP///gD/8AAAAAAAAD8MD/4A///////8A/+DD+AAf/A////gAOADwAB3/wd/cO/39//AB3/wAO/uD/7gABwAeAD////gP/gAAAAAAAA/Dwf/B////////4f/Bw/gAP/B////4AAAAAAAd/8Hf3D////9wAd/8ADv7g/+4AAAAAAA/////A/8AAAAAAAAPw+D/7///////////g8P4AH/h////+AAAAAAAHf/B39x/////cAHf/AA7+4P/uAAAAAAAP////8D/gAAAAAAAD8Pwf////////////wfD+AD/h/wAAAAAAAAAAB3/wd/cd////3AB3/wAO/uD/7gAAAAAAAAAAB/wf8AAAAAAAB/D+D/////f//////4Pw/gB/w/gAAAAAAAAAAAd/+Hf3Hf///9wAd/8ADv7g/+4AAAAAAAAAAAD+D/gAAAAAAD/w/w/////5/v////8H8P/g/4fgAAAAAAAAAAAHf//39x3////8AHf/AA7+///uAAAAAAAAAAAAP4f8AAAAAAH/8P+H////+fj/////D/D/+P8fgAAAAAAAAAAAB3//9/cd/////gB3/wAO/v//7gAAAAAAAAAAAA/D/AAAAAAD//D/x/////j5/////h/w///+PwAAAAAAAAAAAAd/v+/3H/4AP+4Ad/8ADv9/3+4AAAAAAAAAAAAH4f4AAAAAA//w/+/////4cf////8/8P///HwAAAAAAAAAAAAHf///9z/9/9/uAHf/AA7/gD/uAAAAAAAAAAAAAfD/AAAAAAP/8P///////HH///////D///j4AAAAAAAAAAAAB/////c7/f//7gB3/wAO////7gAAAAAAAAAAAAD4fwAAAAAD//B///////xh///////x///x8AAAAAAAAAAAAAO////3O/3//+4Ad/8AD3///94AAAAAAAAAAAAAfD+AAAAAA//wf//////8A///////8f//8eAAAAAAAAAAAAAD3///9zv/gO/+AHf/AAd////cAAAAAAAAAAAAAD4/wAAAAAP/+H///////AP///////H//+PAAAAAAAAAAAAAAe/////7+8Dv/4H3/8AHv///vAAAAAAAAAAAAAAeH8AAAAAD/fh///////4D///////x/f/nwAAAAAAAAAAAAAH3//4/9z/B7nfB/zvgA8///ngAAAAAAAAAAAAADw/gAAAAA/n4f//////+B///////4fz/x4AAAAAAAAAAAAAA/AAB2+bN4c2TwcTZ4AHz//nwAAAAAAAAAAAAAA8P4AAAAAPx+H///////gf//////+H8/88AAAAAAAAAAAAAAH///////+H//8H//+AA////4AAAAAAAAAAAAAAHh+AAAAAD8fh///////4H///////j/H+PAAAAAAAAAAAAAAAf///////B//+A///AAH///8AAAAAAAAAAAAAAA8fwAAAAB+H4f//////+B///////4/g/ngAAAAAAAAAAAAAAB///f7//gP//AH//gAAf//8AAAAAAAAAAAAAAAPH8AAAAA/g/H///////gf//////+P4P54AAAAAAAAAAAAAAAAAAAwIDAAIAAAICAAAAAAgAAAAAAAAAAAAAAABw/AAAAA/wfx///////4P///////3/B/8AAAH//gAA/Px8ADw8AAAA+Px8A+PgB8fD4///+Hh//4AAB+Pj4AAAeP4AAAA/4H8f///////D///////9/wP/AAAP///AA////wD//wAAA////w//8B//7/////3////wAB////gAAHh+AAAAf+D/v+//////w//////7//+D/wAAH///4Af///+B//+AAAf///+f//g/////////////+AA////8AAA4fgAAAf/B///P/////8P/////8///wf+AAH8AA/APh4fHw+fHwAAPh4fH3j58PHx+PgAAD8fAAP4AfDw+PgAAPH4AAAH/wf//h//////D/////+H//8H/gAD5//54Dzp5OcOds8AADzp5MdzZvDm3fNn//++7P/+eAHnb6c4AADx/AAAA/4P//4P/////x//////A///g/4AA9///vA/d/vfD/nfAAA/9/vff57w9zv7j///v3H//7wB+5/e+AAA8fwAAAP+D//8B/////8f/////gP/74P+AAe///94H3//vw+//gAAH3//vz3/4Hf7/////39////eAPv///gAAPD8AAAD/B9//AH/////n/////wB/+fB/gAPf///uAd//74Dv7gAAAd//7wd/+B3/7////33////7gA7//3wAABw/AAAA/wfP/jA/////5/////wGf/nwf4ADv///7wHf/+4A7+4AAAHf/+4Hf7gd/8f///99/////cAO//9wAAAcPwAAAH8Pj/5wB////+f////4H3/w+H8AA7////cB3//uAO/uAAAB3//uB3+4Hf3H////3f////3ADv//8AAAHD8AAAB+D4/+fAH////v////wD8/8Pg/AAf////3Ad///wDv7gAAAd///gP/uB39x//////////9wA7///gAABw/AAAAfg8H/P4AH///7////AB/v/B4PwAHf+A/9wH///cA7+4AAAH///8Dv7gf/cf/gADu//AP/+AO//+4AAAcPwAAAHwfB/z/wAH//+///+AD/7/wfD8AB3+f7/cD/8/3AO/uAAAD/8/3A7+4P/3H/3//j//v+/7gDv5/uAAAHD8AAAB8Hgf8//gAP//v//8AP/+f8DwfAAd/v/f3A//f9wDv7gAAA7//9wO/+Dv9x/9//9//7/3+4B/+/7gAABw/AAAA/D4H+f//gA/////8B///n/A+H4AHf7/39wO/9/cA7+4AAAO/9/cDv/w7/8f/f//9/+/9/+Af/7+4AAAcPwAAAfw+D/n///AH////8B///5/wPh/AB3+4d/cDv/f3AO/uAAADv/f3A7/cO//H/3AA/f/uHf/gHf+/uAAAHD8AAAP4PA/5////Af///8D////f+B4P4Ad/uHf3g7+39wDv7gAAA7+39wO/3Dv7h/9wAPn/7h3/4B3/v7gAABw/AAAH+HwP+f///8D///+D////z/gfD/AHf7n3/8O/t/8A7+4AAAO/t/8D/9w7+4f/cABx/+4d/uAd/b/4AAAcPwAAD/h8D/n////wf///B////8/4Hw/4B3+5/zvjv7f/gO/uAAADv7f/gd/cP/uH/3AAAf/uHf7gHf2/3AAAHD8AAD/weB/z+f//+D///g///9/P+A8H/gd/uczJ47+3+4Dv7gAAA/+3/4Hf3H/7h/9wAAH/7h3+4B39/9wAABw/AAA/8Hgf8/g///wf//w///4fz/wPB/4Hf7n//+f/v/uA7+4AAAf/t/uB3/x3+4f/cAAB/+4d/uAd/f/cAAAcPwAAH/D4H/P4AP//D//4f//AH8/8D4f8B3+4///H/7/7gO/uAAAHf7/7gd/+d/+H/3AAAf/uHf7gP/3f3AAAHD8AAB/w+B/z+AAD/w//+P/wAB/P/A+H/Ad/uH//h3+7+4Dv7gAAB3/7+4Hf7nf/h/9wB4H/7h3+4Dv939wAABw/AAAf4PAf8/gAAH+H//D/gAAfz/wHh/wHf7gcDAd/+/uA7+4AAAd/+/uB3+53/wf/cAfB/+4d/+A7/9/cAAAcPwAAD+DwH/P4AAAfw//h/gAAH8/8B4P4B3+4AAAHf3v7gO/uAAAHf3v7gf/ud/cH/3//4f/v/f/gO//f/AAAHD8AAA/h8B/z+AAAD+P/4/gAAB/P/AeD+Ad/uAAAB397/8Dv7gAAB397+4D/7nf3B/9//uH/7/3/4Dv/3/4AABw/AAAH4fAf8fgAAAfj/+PwAAAfz/wHw/AHf7gAAAd/e//A7+4AAA//e//A7+7/9wf/f/zx/+/9/uA7+9/uAAAcPwAAB+HwH/n4AAAD8f/H4AAAH8/8B8PwB3+4AAAP/3v9wO/uAAAP/3v9wO/+//cH/4ADcf/gA/7gf/v/7gAAHD8AAAPh8B/5+AAAAfH/x8AAAB/P/AfD4Ad/uAAAHv97/eDv/wAAHv97/eDv9+/3D/////Hf////wPf7//8AABw/AAAD4eA/+fwAAAHx/8/AAAAfj/wDw+APf7wAAH//f/77//eAAH3/f/757/fv957///7j3////cP3++/3wAAcPwAAB+HgP/n8AAAA+f/PgAAAP4/8A8PwHv/eAAD9/33/f9/7wAD9//3/f9/37/e////957////3D7/vv++AAHD8AAA/B4B/4/AAAAPn/z4AAAD+P/APD+Bz/3gAA8//9/7+/+8AA8//9/7/f9+/7/f///ee////7x5//7/3gABw/AAAPweAf/PwAAAD5/88AAAA/n/wDwfge/94AAPv//f+/3/fAAPv+/f////fv9/7///3nv///94Pf/+/94AAcPwAAH8HgH/z+AAAA+P/PAAAAfx/8A8H8D3+8AAB7/v3/ee/3gAB7/v3/ee/3/++e///+49///+eD///v+8AAHD8AAD/B4B/8fgAAAPn/zwAAAH8f/APB/gd/uAAAPf79//Dv/wAAPf79//D3///vD/////Hf///fAO/37/uAABw/AAA/w+Af/n8AAAD5/88AAAD+P/wDwf4Hf7gAAB3+/f7g7+4AAB3+/f7gd////gf/gAPx//B/vgDv9+//AAAcPwAAf8PgH/4/AAAA+f/PAAAA/j/8A8H/B3+4AAAd/v3+4O/uAAAd/v3+4H/739wH/3/88f/v/7wA7/d//wAAHD8AAP/D4B/+P4AAAPn/z4AAAfw//APh/4d/uAAAHf7v/+Dv7gAAHf7v/+B/+9/cB/9//uH/77/8AO/3f/+AABw/AAB/w+Af/x/AAAH5/8+AAAP8f/wDwf8Hf7gAAB3+7v/w7+4AAB3/7//wO/vf3Af/f//h/++/3ADv93f7gAAcPwAAf8HgH/+P4AAB8//vwAAH+P/4A8H+B3+4HAwf//7/cO/uAAAf//7/cDv739wH/3AH4f/v/9wA7//3+4AAHD8AAD/B4B//j/gAA/P/58AAD/D/+APB/gd/uH//v//+/3Dv7gAAP/3+/3A7+9/cB/9wB8H/79/+Af//9/uAABw/AAAfweAP/8f+AAfn/+fwAB/x//gDwfwHf7j///v9/v9w7+4AADv9/v9wO////Af/cAMB/+/f7gH///f7gAAcPwAAD8HgD//j/4Af5//3/AB/4//4A8H4B3+5///7/gH/cO/uAAA7/gH/cDv///gH/3AAAf/v3+4B3/AH+4AAHD8AAA/B4A//8f/4/8/n8//P/8f/+APD+Ad/uczJ+////3Dv7gAAO////3A7/b+4B/9wAAH/7u/uAd////uAABw/AAAH4eAP//j////Pwfv///8P//gDw/AHf7n/O/v////w7+4AADv////wO/2/uAf/cAAB/+7v/wHf////wAAcPwAAA+HgB//8P///nwD9///+H//wA8PgB3+59//7////+O/uABg7////+B/9v7gH/3AAcf/u7/cB3////cAAHD8AAAPh8Af//h///z4APP///H//8AfD4Ad/uHf3u////7jv7gA+P/////gd/b+4B/9wAPn/7vf3Ad////3AABw/AAAH4fAH7/+H//58GB5//+H/+/AHw/AHf7h393////+47+8Af3////+4Hf2/uAf/cAD9/+53/4Hf///9wAAcPwAAB+HwA/f/8P/8eD4Pf/////fgB8PwB3+/9/d/////uO/v//93////uB3//7gH/3///f/ud/uD/////cAAHD8AAA/h8APz////+PB/B7/////n4AeD+Ad/v/f3d////7jv7//3d////7gd///4B/9//9//7n/7g/////3AABw/AAAP4PAD8f////Ph/4fP////5+AHg/gHf5/v93f4AH+47///53f4AH+4Hf5/8Af/f/+O/+47/8O/wAP9wAAcPwAAH/DwAfj////H4//D5////4/AB4f8B3/gH/d3+/+/uO/4AD93////uB3//3AH/4AA7//uO/3Dv9/9/8AAHD8AAB/w+AH4f///j8f/4/H///8PwA+H/Af////3d///v/jv///3d/f/v/gf//9wB///////7j/9w7///f/gABw/AAAf8PgB+B///h/H//H8///8D8APh/wDv///93f3/7/87///53/3/7/8Dv//cAf////d/+4d/cO/v/3+4AAcPwAAP/B4APwH//B/j//x/h//8B+ADwf+A7///+9/9wO/3O///99/9wO//A7//3AH////ff/uHf7jv7gd/uAAHD8AAD/weAD+AH8B/4//+P+B/wAfgA8H/gPf///u//cD/9zv///f//cDv9we//9wD////33/7h3+5/+4H/7gABw/AAAP+HwAfgAAA/+f//j/4AAAPwAfD/gB7///3+/3A//f7///5+/3A//ePv//eB/////f3+8d/v9/uB7+8AAcPwAAB/h8AH/+AAP/n//4/8AA//8AHw/wAPf//7/ud4e4//5////ud4e4/z3v9/w+4///79zvvc9/c7wf53gAHD8AAAP4PB///+AA/x//+P8AB////B4P4AD5//572beHs2eZv///2beHsmc518u8PNn//++7d7mzvu2cPds4ABw/AAAB/D7////4AD8P//j+AB////++H8AAfwAD8+fHh4+P58AAB8fHh4+PPjw8eB4+AAAPx8e+fH8+PDx8eAAcPwAAAPw//////gAfD+f4+AB//////h+AAB///+H//4P//////////4P//h////gf////////H/////wf//gAHD8AAAB8H/////8ADwfD8PAA//////wfAAAP///A//8B//7///////8D//4P///wD/////3//g//9//4D//wABw/AAAAfj/gB///gAOAAADgAf/f+D/+PwAAAf/+AHx8APj4PD///nx8APj4A+fnwAPj///4fHwDx8Hj4APDwAA8PwAAAH5/AAP+f8ABgAABwAH+P/AA/j8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPD8AAAB+P4AD/5/gAAAAAYAD+f/gAP4/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADx/AAAAfw+AAf//4AAAAAAAA///gAD4fwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA8fwAAAP8HwAD///AAAAAAAAf//wAB8H+AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOH4AAAD/h8AAf//wAAAAAAAH//8AAfD/gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHh+AAAA/4PgA///8AAAGAAAB///4APg/4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB4/gAAAP/D4B////BwABwABgf///wD4f+AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAcP4AAAD/wfD////w8DA8AAcH////B8H/gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPD8AAAB/8Hz/8P/8PBwPAYHD//j/8fD/8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADx/AAAAP/g//wB//jweDwPBw//wD//g//AAAAAAAgAAAAAAAAAAAAAQAQAIAIAEAEAAAIAAAAAAAAAAAAAAAAB4fwAAAA/8P/gAH/48Hg8DwcP/4AH/wf/4AAAADAcAAAAAAAAAHAYAMAOAGADADABgAwHAAAAAAAAABgGAAAAA+H4AAAAD/B/gAA/+PB4PA8HD/8AAf8H+eAAAAD4HgAAAAAAAADwPgf4P4P8H8H+D/A+DwAAAAAAAAA8DwAAAAPD+AAAAAP4/gAAP//weDwPB//+AAA/D/jwAAAD//////////////+H+D/D/B/h/g/w///////////////gAAAHg/gAAAAB+P8AAB//8Hg8Dw///gAAf4/4eAAAB///////////////w/AfAfgPgPwHwf//////////////4AAAD4fwAAAAAPz/AAAP///4PA////wAAP+f/HwAAAD4HgAAAAAAAADwPgPwHwH4D4B8B8A+D4AAAAAAAAA8H4AAAB8P4AAAAAD+D4AAD//////////4AAD4P/4+AAAAcBwAAAAAAAAAcBwD8BsB2A2A7AbgHAcAAAAAAAAAPA4AAAA+H+AAAAAA/gfAAAf9///////f+AAB8D/+HwAAABAIAAAAAAAAACAQAAAAAAAAAAAAAAACAAAAAAAAABgEAAAAfB/AAAAAAP8H4AAD/H//////H/AAA/B//w+AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPg/wAAAAAD/g/AAA/x4eL4PDz/wAAfg//+H4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPwf4AAAAAA/4H4AAH+eHg8Dw4/4AAPwf+/w/gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP4P8AAAAAAP/A/AAA/jh4PA8OP8AAH4H/n+D+AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP8H+AAAAAAD/4H4AAP8QeDwODH+AAD8D/4/wf8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAf8D/gAAAAAA//A/AAB/AHg8DgB/gAB+B/+P/B//+AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP//8B/wAAAAAAP/4H4AAf4A4PAwA/wAA/A//h/4H//wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD//8B/4AAAAAAB//A/AAD/AABgAAf4AAfgf/wP/gf/8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA//8A/8AAAAAAAD/4H4AAf4AAAAAP8AAPwP/gA/+Af/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP/wA/+AAAAAAAAH/A/gAD/gAAAAP+AAP4H/AAH/4ADwAD/gP+D4A+fz/4AfAAA8APv/8/j+fwf8A/AfB/A/AADgAB/+AAAAAAAAAP4H8AA/8AAAAP/AAH8D+AAA//wA8AB/8H/4+AfH8//gHwAAPgHx//Pwfn8P/gPwH4fwHwAA4AB//AAAAAAAAAD/A/gAH/wAAAP/gAD+B/gAAH//wPAA//j//HwHw+H/8B8AAB8B8f/x8Pw+H/8B4A/D4B4AAOAH//gAAAAAAAAA/4H+AA//gAAf/wAD/A/4AAAf//jwAf/4//x+D8Ph//AfAAAfA+H/8fj4Pj//A/APw+A/AADh///gAAAAAAAAAP/AfwAD//wD//4AB/Af8AAAB//48AH//f/8fh/D4f/4P4AAH4fh//D9+D4//4PwD+PgPwAA4f//wAAAAAAAAAB/4D/AAf/////4AB/gP/AAAAH/+PAB8H3wfH8fw+Hw+D+AAB/H4fgwf/A+Pg+H8A/z4D+AAOH//wAAAAAAAAAAf/Af8AB/////4AB/wH/wAAAAf/jwAfD98Dx/v8Ph8Pg/gAAfz+HwAH/gPj4fh/gP++B/gADh//gAAAAAAAAAAH/8B/wAP////4AB/wH/8AAAAA/48AHw/fA8f//D4fD4f8AAH//h/8A/4D4+H4f4D/vgf4AA4f/gAAAAAAAAAAB//gH/AAf///4AB/wD//AAAAAB+PAB8AHwPH//w+Hw+H/AAB//4f/AP8A+PgAP/A//4H/AAOH+AAAAAAAAAAAAP/8A/8AA///gAB/4B//gAAAAAfjwAfAB8Dx//8Ph8Ph74AAf/+H/wB/APj4AD/wP/+D7wADh+AAAAAAAAAAAAD//wD/4AA/8AAD/4B//4AAAAAH48AHwAfA8f//D4fD4++AAH//h/8AfwD4+AA88D//g++AA4fgAAAAAAAAAAAAP/+AP/wAAAAAH/4A//4AAAAAB+PAB8HnwPH33w+Hw+PngAB//4f/AP+A+Pg8fPg//4fPgAOH4AAAAAAAAAAAAAA/4A//wAAAAf/4A/4AAAAAAAfjwAfB98Dx998Ph8Pn/8AAfe+H4QH/gPj4fn/4Pv+H/4ADh+AAAAAAAAAAAAAAH/gB//8AAH//wA/8AAAAAAAH48AHwffA8fOfD4fD5//AAHzvh8BB/8D4+D7//D5/h//AA4fgAAAAAAAAAAAAAB/+AH///////wA//AAAAAAAB+PAB+v35fHzHw+H/+f/wAB8z4f/w/fA+P1+//w+P4//wAOH4AAAAAAAAAAAAAAf/4AP//////gA//gAAAAAAAfjwAf/8//x8B8Ph//v/+AAfA+H/8Pn4Pj//P/8Pj+P/+ADh+AAAAAAAAAAAAAAD//gAP////+AA//4AAAAAAAH48AD/+P/8fAfD4f/z4PgAHwPh//H4/D4f/34fj4fj4fgA4fgAAAAAAAAAAAAAA//+AAH///wAA//+AAAAAAAB+PAAf/B/+P4Px+P/5+D8AD8D8f/z8Hw/H/5+H5+D5+H8AOH4AAAAAAAAAAAAAAH//8AAAAAAAB///AAAAAAAAfjwAD/gP/D+H+fz/8/x/gA/h/v/8/j+fw/8/j/fw+/x/AHh+AAAAAAAAAAAAAAB///4AAAAAAD///wAAAAAAAH88AAPgA+AAAAAAAAAAAAAAAAAAAAAAAAB8AAAAAAAAAAB4/gAAAAAAAAAAAAAAP///4AAAAAP///4AAAAAAAB/PAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAeP4AAAAAAAAAAAAAABAH//8AAAB///AEAAAAAAAAPx4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHD8AAAAAAAAAAAAAAAAA////4D////gAAAAAAAAAD8eAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADw/AAAAAAAAAAAAAAAAAP/////////wAAAAAAAAAA/jwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB8fwAAAAAAAAAAAAAAAAB/////////8AAAAAAAAAAP48AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAeH8AAAAAAAAAAAAAAAAAP////////+AAAAAAAAAAB/HgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPD+AAAAAAAAAAAAAAAAAB/x/////H/AAAAAAAAAAAfx+AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHw/gAAAAAAAAAAAAAAAAAfAP////gHgAAAAAAAAAAD+PwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAH4fwAAAAAAAAAAAAAAAAAAAB/+P/wAIAAAAAAAAAAA/x/wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAf8P8AAAAAAAAAAAAAAAAAAAAP+A/4AAAAAAAAAAAAAH+H/////////////////////////////////////////8D+AAAAAAAAAAAAAAAAAAAAB+AD4AAAAAAAAAAAAAB/w/////////////////////////////////////////+D/gAAAAAAAAAAAAAAAAAAAAGAAMAAAAAAAAAAAAAAP+B////////////////////////////////////////8B/wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB/wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB/+AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB/+AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP////////////////////////////////////////////AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB////////////////////////////////////////////gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAH///////////////////////////////////////////gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA///////////////////////////////////////////wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD//////////////////////////////////////////wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAH/////////////////////////////////////////gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="

function Write-Log($msg) {
  $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
  Add-Content -Path $LogFile -Value "[$ts] $msg" -Encoding UTF8
}

function Clean-Text($texto) {
  if ($null -eq $texto) { return "" }
  $s = [string]$texto
  $s = $s.Normalize([Text.NormalizationForm]::FormD)
  $sb = New-Object Text.StringBuilder
  foreach ($ch in $s.ToCharArray()) {
    $cat = [Globalization.CharUnicodeInfo]::GetUnicodeCategory($ch)
    if ($cat -ne [Globalization.UnicodeCategory]::NonSpacingMark) { [void]$sb.Append($ch) }
  }
  $s = $sb.ToString()
  $s = $s -replace "₡", "CRC "
  $s = $s -replace "[^\x09\x0A\x0D\x20-\x7E]", ""
  return $s
}

function Linea() { return ("-" * 42) + "`n" }
function Centro($txt) {
  $t = Clean-Text $txt
  if ($t.Length -gt 42) { $t = $t.Substring(0,42) }
  $n = [Math]::Max(0, [Math]::Floor((42 - $t.Length) / 2))
  return (" " * $n) + $t + "`n"
}
function Col($a, $b) {
  $l = Clean-Text $a
  $r = Clean-Text $b
  if ($l.Length -gt 24) { $l = $l.Substring(0,24) }
  if ($r.Length -gt 17) { $r = $r.Substring(0,17) }
  $spaces = 42 - $l.Length - $r.Length
  if ($spaces -lt 1) { $spaces = 1 }
  return $l + (" " * $spaces) + $r + "`n"
}
function Money($n) {
  try {
    $num = [Math]::Round([decimal]$n, 2)
    return $num.ToString("#,##0.00", [Globalization.CultureInfo]::GetCultureInfo("en-US"))
  }
  catch { return "0.00" }
}
function Fecha() { return (Get-Date).ToString("dd/MM/yyyy hh:mm tt", [Globalization.CultureInfo]::GetCultureInfo("es-CR")) }

$RawPrinterCode = @"
using System;
using System.Runtime.InteropServices;
public class RawPrinterHelper {
  [StructLayout(LayoutKind.Sequential, CharSet=CharSet.Ansi)]
  public class DOCINFOA {
    [MarshalAs(UnmanagedType.LPStr)] public string pDocName;
    [MarshalAs(UnmanagedType.LPStr)] public string pOutputFile;
    [MarshalAs(UnmanagedType.LPStr)] public string pDataType;
  }
  [DllImport("winspool.Drv", EntryPoint="OpenPrinterA", SetLastError=true, CharSet=CharSet.Ansi, ExactSpelling=true, CallingConvention=CallingConvention.StdCall)]
  public static extern bool OpenPrinter(string szPrinter, out IntPtr hPrinter, IntPtr pd);
  [DllImport("winspool.Drv", EntryPoint="ClosePrinter", SetLastError=true, ExactSpelling=true, CallingConvention=CallingConvention.StdCall)]
  public static extern bool ClosePrinter(IntPtr hPrinter);
  [DllImport("winspool.Drv", EntryPoint="StartDocPrinterA", SetLastError=true, CharSet=CharSet.Ansi, ExactSpelling=true, CallingConvention=CallingConvention.StdCall)]
  public static extern bool StartDocPrinter(IntPtr hPrinter, Int32 level, [In, MarshalAs(UnmanagedType.LPStruct)] DOCINFOA di);
  [DllImport("winspool.Drv", EntryPoint="EndDocPrinter", SetLastError=true, ExactSpelling=true, CallingConvention=CallingConvention.StdCall)]
  public static extern bool EndDocPrinter(IntPtr hPrinter);
  [DllImport("winspool.Drv", EntryPoint="StartPagePrinter", SetLastError=true, ExactSpelling=true, CallingConvention=CallingConvention.StdCall)]
  public static extern bool StartPagePrinter(IntPtr hPrinter);
  [DllImport("winspool.Drv", EntryPoint="EndPagePrinter", SetLastError=true, ExactSpelling=true, CallingConvention=CallingConvention.StdCall)]
  public static extern bool EndPagePrinter(IntPtr hPrinter);
  [DllImport("winspool.Drv", EntryPoint="WritePrinter", SetLastError=true, ExactSpelling=true, CallingConvention=CallingConvention.StdCall)]
  public static extern bool WritePrinter(IntPtr hPrinter, byte[] pBytes, Int32 dwCount, out Int32 dwWritten);
  public static bool SendBytesToPrinter(string printerName, byte[] bytes) {
    IntPtr hPrinter = IntPtr.Zero;
    DOCINFOA di = new DOCINFOA();
    di.pDocName = "Gato Calavera Ticket";
    di.pDataType = "RAW";
    if (!OpenPrinter(printerName.Normalize(), out hPrinter, IntPtr.Zero)) return false;
    try {
      if (!StartDocPrinter(hPrinter, 1, di)) return false;
      try {
        if (!StartPagePrinter(hPrinter)) return false;
        try {
          int written = 0;
          return WritePrinter(hPrinter, bytes, bytes.Length, out written);
        } finally { EndPagePrinter(hPrinter); }
      } finally { EndDocPrinter(hPrinter); }
    } finally { ClosePrinter(hPrinter); }
  }
}
"@
try { Add-Type -TypeDefinition $RawPrinterCode -ErrorAction SilentlyContinue } catch {}

function Add-Bytes($list, [byte[]]$bytes) { foreach ($b in $bytes) { [void]$list.Add([byte]$b) } }
function Add-Text($list, $texto) { Add-Bytes $list ([Text.Encoding]::ASCII.GetBytes((Clean-Text $texto))) }
function Add-Logo($list) {
  try {
    $logo = [Convert]::FromBase64String($LogoRasterB64)
    $xL = [byte]($LogoWidthBytes % 256)
    $xH = [byte][Math]::Floor($LogoWidthBytes / 256)
    $yL = [byte]($LogoHeight % 256)
    $yH = [byte][Math]::Floor($LogoHeight / 256)
    Add-Bytes $list ([byte[]](0x1B,0x61,0x01))
    Add-Bytes $list ([byte[]](0x1D,0x76,0x30,0x00,$xL,$xH,$yL,$yH))
    Add-Bytes $list $logo
    Add-Text $list "`n"
  } catch { Write-Log "No se pudo imprimir logo: $($_.Exception.Message)" }
}

function Add-EmphasizedItemLine($list, $cantidad, $nombre) {
  $qty = [string]$cantidad
  if ([string]::IsNullOrWhiteSpace($qty)) { $qty = "1" }
  $name = (Clean-Text $nombre).ToUpperInvariant()
  $maxChars = 32
  $prefix = ($qty + " ").PadRight(4)
  $available = $maxChars - $prefix.Length
  if ($available -lt 8) { $available = 8 }
  $words = $name -split "\s+"
  $lines = New-Object System.Collections.Generic.List[string]
  $current = ""
  foreach ($word in $words) {
    if ([string]::IsNullOrWhiteSpace($word)) { continue }
    if ([string]::IsNullOrWhiteSpace($current)) {
      $current = $word
    } elseif (($current.Length + 1 + $word.Length) -le $available) {
      $current += " " + $word
    } else {
      [void]$lines.Add($current)
      $current = $word
    }
  }
  if (-not [string]::IsNullOrWhiteSpace($current)) { [void]$lines.Add($current) }
  if ($lines.Count -eq 0) { [void]$lines.Add($name) }

  Add-Bytes $list ([byte[]](0x1B,0x45,0x01))
  Add-Bytes $list ([byte[]](0x1D,0x21,0x01))
  for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($i -eq 0) { Add-Text $list ($prefix + $lines[$i] + "`n") }
    else { Add-Text $list ((" ").PadRight($prefix.Length) + $lines[$i] + "`n") }
  }
  Add-Bytes $list ([byte[]](0x1D,0x21,0x00))
  Add-Bytes $list ([byte[]](0x1B,0x45,0x00))
}

function Print-ComandaRaw($data) {
  $null = Get-Printer -Name $PrinterName -ErrorAction Stop
  $productos = Get-Productos $data
  $bytes = New-Object 'System.Collections.Generic.List[byte]'
  Add-Bytes $bytes ([byte[]](0x1B,0x40))
  Add-Bytes $bytes ([byte[]](0x1B,0x74,0x02))
  Add-Bytes $bytes ([byte[]](0x1B,0x61,0x01))
  Add-Text $bytes ("COMANDA`n`n")
  Add-Text $bytes (((Get-Date).ToString("dd/MM/yyyy")) + "`n`n")
  if ($data.mesa) { Add-Text $bytes ((Clean-Text $data.mesa) + "`n") }
  Add-Bytes $bytes ([byte[]](0x1B,0x61,0x00))
  Add-Text $bytes ("`nA nombre de: " + $(if($data.cliente){$data.cliente}else{"Cliente contado"}) + "`n")
  Add-Text $bytes ("Salonero: " + $(if($data.usuario){$data.usuario}else{"Caja"}) + "`n")
  Add-Text $bytes ("Hora comanda: " + (Get-Date).ToString("h:mm:ss tt", [System.Globalization.CultureInfo]::GetCultureInfo("es-CR")) + "`n")
  Add-Text $bytes ("Mesa: " + $(if($data.mesa){$data.mesa}else{"N/A"}) + "`n")
  Add-Text $bytes ("Pacayas`n`n")
  Add-Text $bytes ((Linea) + "Cant. Descripcion`n" + (Linea))
  foreach ($p in $productos) {
    Add-EmphasizedItemLine $bytes $p.cantidad $p.nombre
    if ($p.notas) { Add-Text $bytes ("  Nota: " + (Clean-Text $p.notas) + "`n") }
    if ($p.llevar) { Add-Text $bytes ("  PARA LLEVAR`n") }
    Add-Text $bytes (Linea)
  }
  Add-Bytes $bytes ([byte[]](0x1B,0x61,0x01))
  Add-Text $bytes ("******ULTIMA LINEA******`n`n`n")
  Add-Bytes $bytes ([byte[]](0x1D,0x56,0x42,0x00))
  $ok = [RawPrinterHelper]::SendBytesToPrinter($PrinterName, $bytes.ToArray())
  if (-not $ok) { throw "No se pudo enviar RAW a $PrinterName" }
  Write-Log "Comanda RAW resaltada enviada a $PrinterName"
}


function Print-RawTicket($texto, $tipo) {
  $null = Get-Printer -Name $PrinterName -ErrorAction Stop
  $bytes = New-Object 'System.Collections.Generic.List[byte]'
  Add-Bytes $bytes ([byte[]](0x1B,0x40))
  Add-Bytes $bytes ([byte[]](0x1B,0x74,0x02))
  if ($tipo -eq "factura") { Add-Logo $bytes }
  Add-Bytes $bytes ([byte[]](0x1B,0x61,0x00))
  Add-Bytes $bytes ([byte[]](0x1B,0x45,0x00))
  Add-Text $bytes ($texto + "`n`n`n")
  Add-Bytes $bytes ([byte[]](0x1D,0x56,0x42,0x00))
  $ok = [RawPrinterHelper]::SendBytesToPrinter($PrinterName, $bytes.ToArray())
  if (-not $ok) { throw "No se pudo enviar RAW a $PrinterName" }
  Write-Log "Ticket RAW enviado a $PrinterName tipo=$tipo"
}

function Get-JsonBody($ctx) {
  $reader = New-Object IO.StreamReader($ctx.Request.InputStream, $ctx.Request.ContentEncoding)
  $raw = $reader.ReadToEnd()
  if ([string]::IsNullOrWhiteSpace($raw)) { return @{} }
  try { return $raw | ConvertFrom-Json } catch { Write-Log "JSON invalido: $raw"; throw "JSON invalido" }
}
function Set-CorsHeaders($ctx) {
  $origin = $ctx.Request.Headers["Origin"]
  if ([string]::IsNullOrWhiteSpace($origin)) { $origin = "*" }
  $ctx.Response.Headers.Set("Access-Control-Allow-Origin", $origin)
  $ctx.Response.Headers.Set("Vary", "Origin")
  $ctx.Response.Headers.Set("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
  $ctx.Response.Headers.Set("Access-Control-Allow-Headers", "Content-Type, Access-Control-Request-Private-Network, Private-Network-Access-ID, Private-Network-Access-Name")
  $ctx.Response.Headers.Set("Access-Control-Allow-Private-Network", "true")
  $ctx.Response.Headers.Set("Private-Network-Access-Name", "Gato Calavera Print Service")
  $ctx.Response.Headers.Set("Private-Network-Access-ID", "gato-calavera-print-service")
}
function Send-Json($ctx, $status, $obj) {
  $ctx.Response.StatusCode = $status
  Set-CorsHeaders $ctx
  $ctx.Response.ContentType = "application/json; charset=utf-8"
  $json = $obj | ConvertTo-Json -Depth 20
  $out = [Text.Encoding]::UTF8.GetBytes($json)
  $ctx.Response.OutputStream.Write($out, 0, $out.Length)
  $ctx.Response.Close()
}
function Get-Productos($data) {
  if ($null -eq $data.productos) { return @() }
  if ($data.productos -is [System.Array]) { return $data.productos }
  return @($data.productos)
}
function Build-TestTicket() { return "`n" + (Centro "GATO CALAVERA") + (Centro "PRUEBA DE IMPRESION") + (Linea) + (Col "Impresora" $PrinterName) + (Col "Estado" "OK") + (Col "Fecha" (Fecha)) + (Linea) + (Centro "SERVICIO LOCAL OK V13") }
function Build-Factura($data) {
  if ($null -ne $data.texto -and -not [string]::IsNullOrWhiteSpace([string]$data.texto)) { return [string]$data.texto }
  if ($null -ne $data.text -and -not [string]::IsNullOrWhiteSpace([string]$data.text)) { return [string]$data.text }
  $productos = Get-Productos $data
  $t = "`n" + (Centro "Gato Calavera Pacayas") + (Centro "Alessandro Rubi Silesky") + (Centro "ID No: 1-1835-0862") + (Centro "alessandrorubi6@gmail.com") + (Centro "Telefono: 7229-3155") + (Centro "FACTURA") + "`n"
  $t += "Fecha apertura: " + (Fecha) + "`nFecha cierre:   " + (Fecha) + "`n" + (Col ("Cuenta: " + $data.cuenta) ("Mesa: " + $data.mesa))
  $t += "Invitados: 1`nID Cliente:`nNombre: " + $(if($data.cliente){$data.cliente}else{"Cliente Contado"}) + "`n" + (Linea) + (Col "Descripcion" "Precio") + (Linea)
  foreach ($p in $productos) { $nombre = Clean-Text $p.nombre; if($nombre.Length -gt 28){$nombre=$nombre.Substring(0,28)}; $precio = 0; try { $precio = [decimal]$p.precio * [decimal]$p.cantidad } catch {}; $t += Col $nombre (Money $precio) }
  $t += (Linea) + (Col "SubTotal:" (Money $data.subtotal)) + (Col "Total:" (Money $data.total)) + "`nCondicion de venta: Contado`nMetodo de pago: " + $data.metodoPago + "`n" + (Linea) + "Moneda: CRC`n" + (Linea) + (Centro "Regimen de Tributacion Simplificada")
  return $t
}
function Build-Comanda($data) {
  if ($null -ne $data.texto -and -not [string]::IsNullOrWhiteSpace([string]$data.texto)) { return [string]$data.texto }
  if ($null -ne $data.text -and -not [string]::IsNullOrWhiteSpace([string]$data.text)) { return [string]$data.text }
  $productos = Get-Productos $data
  $t = "`n" + (Centro "COMANDA") + "`n" + (Centro ((Get-Date).ToString("dd/MM/yyyy"))) + "`n" + (Centro $data.mesa) + "`n"
  $t += "A nombre de: " + $data.cliente + "`nSalonero: " + $data.usuario + "`nHora comanda: " + (Fecha) + "`nMesa: " + $data.mesa + "`nPacayas`n`n" + (Linea) + "Cant. Descripcion`n" + (Linea)
  foreach ($p in $productos) { $t += ([string]$p.cantidad).PadRight(5) + " " + (Clean-Text $p.nombre) + "`n" }
  $t += Linea + (Centro "******ULTIMA LINEA******")
  return $t
}
function Build-Cierre($data) {
  if ($null -ne $data.texto -and -not [string]::IsNullOrWhiteSpace([string]$data.texto)) { return [string]$data.texto }
  if ($null -ne $data.text -and -not [string]::IsNullOrWhiteSpace([string]$data.text)) { return [string]$data.text }
  return "`n" + (Centro "GATO CALAVERA") + (Centro "CIERRE TURNO") + (Linea) + (Col "Fecha" (Fecha)) + (Col "TOTAL" (Money $data.total)) + (Linea)
}
try {
  Write-Log "Iniciando servicio V13 RAW en 127.0.0.1:$Port"
  $listener = New-Object Net.HttpListener
  $listener.Prefixes.Add("http://127.0.0.1:$Port/")
  $listener.Start()
  Write-Log "Servicio activo V13 RAW"
  while ($listener.IsListening) {
    $ctx = $listener.GetContext()
    try {
      $path = $ctx.Request.Url.AbsolutePath.ToLowerInvariant()
      $method = $ctx.Request.HttpMethod.ToUpperInvariant()
      if ($method -eq "OPTIONS") { Send-Json $ctx 200 @{ ok = $true; version = "13.0" }; continue }
      if ($path -eq "/health") { $exists = $false; try { $null = Get-Printer -Name $PrinterName -ErrorAction Stop; $exists = $true } catch {}; Send-Json $ctx 200 @{ ok = $true; version = "13.0"; mode = "RAW_ESC_POS"; port = $Port; service = "GatoCalaveraPrintService"; printer = $PrinterName; printerFound = $exists; printerExists = $exists; message = "Servicio local Gato Calavera activo" }; continue }
      if ($path -eq "/test-print" -or $path -eq "/print/test") { Print-RawTicket (Build-TestTicket) "test"; Send-Json $ctx 200 @{ ok = $true; version = "13.0"; message = "Prueba enviada" }; continue }
      if ($path -eq "/print/factura") { $data = Get-JsonBody $ctx; Print-RawTicket (Build-Factura $data) "factura"; Send-Json $ctx 200 @{ ok = $true; version = "13.0"; message = "Factura enviada" }; continue }
      if ($path -eq "/print/comanda") { $data = Get-JsonBody $ctx; Print-ComandaRaw $data; Send-Json $ctx 200 @{ ok = $true; version = "13.0"; message = "Comanda enviada" }; continue }
      if ($path -eq "/print/cierre") { $data = Get-JsonBody $ctx; Print-RawTicket (Build-Cierre $data) "cierre"; Send-Json $ctx 200 @{ ok = $true; version = "13.0"; message = "Cierre enviado" }; continue }
      if ($path -eq "/print") { $data = Get-JsonBody $ctx; $tipo = if($data.tipo){[string]$data.tipo}else{"ticket"}; $texto = if($data.texto){[string]$data.texto}elseif($data.text){[string]$data.text}else{""}; if([string]::IsNullOrWhiteSpace($texto)){throw "Texto vacio"}; Print-RawTicket $texto $tipo; Send-Json $ctx 200 @{ ok = $true; version = "13.0"; message = "Ticket enviado" }; continue }
      Send-Json $ctx 404 @{ ok = $false; version = "13.0"; error = "Ruta no encontrada" }
    } catch { Write-Log "Error request: $($_.Exception.Message)"; try { Send-Json $ctx 500 @{ ok = $false; version = "13.0"; error = $_.Exception.Message } } catch {} }
  }
} catch { Write-Log "ERROR FATAL V13: $($_.Exception.Message)"; Start-Sleep -Seconds 3; throw }
