$ErrorActionPreference = "Continue"
$PrinterName = "TERMICA"
$Port = 5055
$BaseDir = "C:\GatoCalavera"
$LogDir = Join-Path $BaseDir "logs"
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
$LogFile = Join-Path $LogDir "print-service.log"
$LogoWidthBytes = 48
$LogoHeight = 173
$LogoRasterB64 = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB///////////////////////8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/////////////////////////wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD/////////////////////////+AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP//////////////////////////gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA///////////////////////////4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD/4AAAAAAAAAAAAAAAAAAAAAAAA/8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAH/AAAAAAAAAAAAAAAAAAAAAAAAAH+AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP8P////////////////////////B/gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAfx/////////////////////////w/wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/j+AAAAAAAAAAAAAAAAAAAAAAAH8P4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB+PgAAAAAAAAAAAAAAAAAAAAAAAA/H4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD8eAAAAAAAAAAAAAAAAAAAAAAAAAPj8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAH48AAAAAAAAAAAAAAAAAAAAAAAAADx+AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHxwAAAAD//wA///n////wf/8AAAAB4/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPzgAAAAH//4B///3////4///AAAAAcfAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPnAAAAAfAA+Bxwx+gAAAb4APgAAAAePgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAfOAAAAA9//uB/fd+////bv/9wAAAAPPgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAfOAAAAA////B7//3f//9///+4AAAAHHwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA+cAAAAB3//7Ab//Hf//9+///YAAAADnwAAAAAAAAAAAAAAAAABgAgAAAAAAAAAAA+cBgGABv///gf//m////////4AGAMDj4AAAAAAAAAAAAAAAAAD4D4AAAAAAAAAAB84DwPgBv379g/7/mn37td+6/8APAeBz4AAAAAAAAAAAAAAAAAH8P8AAAAAAAAAAB84H4fwB/v//g/79m////99//8Afg/Bx4AAAAAAAAAAAAAAABwP//+DwAAAAAAAAB9wOc54B/v/tw3/9n////99//8A57zgx8AAAAAAAAAAAAAAAD+f///f4AAAAAAAAB5wdv34B/s6043/9jw//D99j/8B2/tw58AAAAAAAAAAAAAAAH//////8AAAAAAAAB5wb3vcB/s//w33/gA//AN9j/8B3fdw58AAAAAAAAAAAAAAAP//////8AAAAAAAAD5wd7e4B/sf/g/3/wA//AN9j/8A7u7g58AAAAAAAAAAAAAAAP/8AAP/+AACAAAAAD5gO89wB/sCCB///wA//AN9j/8A953g58AAAAAAAAAAAA8B//+AAAAP//gPAAAAAD5gHf7gB/sAAB///wA//AN9j/8Ae/vA48AAAAAAAAAAAA/B//wAAAAB//w/gAAAAD5gDv3AB/sAAB//+wA//AN9j/8AP/eA48AAAAAAAAAAAB/z/+AA//gAP/x/gAAAAD5gB3uAB/s//hv++wA//AN9j/8AHfcA48AAAAAAAAAAAB/7/wA////gD///wAAAAD5gDv3ABvt//zvu/8A//AN9j/8AP/+A48AAAAAAAAAAAD///AH////8A///wAAAAD5gHf7gD/v2w/fv/eB37g///fuAe/vA48AAAAAAAAAAAD//8A//wD//gP//wAAAP/5gO89wHfv/t+/v/uDv/g7++/2A/x3g4//wAAAAAAAAAD7/wH/wAAB/4D/3wAAD//5gd7e4H/t7/u///uB37g///fuB/u7w4///AAAAAAAAAD5/wf8AAAAH+D/HwAAP//5gb3vcDvsf/nf//8A//Ad9z/8B3fdw4///wAAAAAAAAD4f5/gAAAAA/n+HwAA///5gdv24B/sf/jf/f4A//AN9j/8B2/tw4///8AAAAAAAAD4P/+AAAAAAP/8H4AD//gBgOc9wB/sf/j/7f8A//AN9j/8A5xzg4AH//AAAAAAAAD4H/4AD//wAD/4H4AH/gABgH4fgB/sf/n/ff8A//AN9j/8Afg/A4AAH/gAAAAAAAD4B/gD////wA/wH4AP8D//gDwPAB/sf/n/f/8A//AN9j/8APAeA///A/wAAAAAAAD5w/wf/////B/hH4Afw///gBgGAB/sf/n/gfsA//AN9j/8AGAMA///4P8AAAAAAAD54f7//////7/Dn4A/j///gAAAAB/sf/m///sA//AN9j/8AAAAAf///D+AAAAAAAD58f////////+Hn4B+P4AAAAAAAB/sP/m///8A//AN9j/8AAAAAAAAfh/AAAAAAAH5+P///3////8Pn8D8fAAAAAAAAB/v//m///+A//AN9//8AAAAAAAAD4/AAAAAAA/4/H///z7///8fn/n58AAAAAAAAB/v//v///+A//AN9//8AAAAAAAAA8fgAAAAAD/4/n///5z///4/n//zwAAAAAAAABv37/v+gv+A//AN+/f8AAAAAAAAAePwAAAAAD/4/////5n/////n//ngAAAAAAAABv///v///2A//AN///4AAAAAAAAAPH4AAAAAD/4/////5n/////H//PAAAAAAAAAB3///t//32A//AP///YAAAAAAAAAHj4AAAAAD/4/////4H/////H//OAAAAAAAAAA////t9g33A//AG//+4AAAAAAAAADz8AAAAAD/4/////4H/////H3+cAAAAAAAAAA9//P/vx+fh2fgHf/9wAAAAAAAAABx8AAAAAD54/////8P/////P3+8AAAAAAAAAAfAAx41x1jh1jgDz/3gAAAAAAAAAA4+AAAAAD54/////8P/////Pz84AAAAAAAAAAH/////x//h//gB///AAAAAAAAAAAY+AAAAADx8/////8P/////Pj9wAAAAAAAAAAD/////g//A//AAf/+AAAAAAAAAAAceAAAAAPx8/////8P/////Ph9wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMfAAAAAfh8/////8P/////fw/gAB//gB//+A/+AAD//8P/gf/f///n//8AB//+AAOfAAAAB/D9/////8f////f/4/wAH//4D///h//AAH//+f/w//////////AD///AAOPAAAAD/D/+f///+f///+f/4f4APAA8HLDjjjjgAOGHH44xxzxwAA8cAHgHDDDgAGPAAAAD+H/+P///+f///8P/8fwAd//uHs+7zsfgAP55//Px2b/P/+9n/9wH98/gAGPgAAAD+P/8H///+f///4P/cPwA7//3D///h/3AAPf/vd/w//7//9///+4Hv/3gAHPgAAAB+Pf8B///+f///wn/ePwA3//7A3/2A32AAD//8P/w3+b//7v///YB//+AAHPgAAAB8Of5gf//+////B3+OHwB///7g//+A32AADf/sP/w32b//9////8Bv/+AAHPgAAAB8ef7wH//+///8D3+PHwB////h///A32AADf/sP/w32b//+////sBv/2AAHPgAAAB4cPz8AP/+///AP7+PHgB/wD/h/3/A32AADfPsH+w32b8AC/+AfsBvv2AAHPgAAAB48Pz/gD////4D/7+HDgB////h/3/A32AAD/PsG+w/2b7/////vsB/n2AAHPgAAAD44f3/+A////A//7+HjwB/v9/hv/7A32AAH//8G+x/+b7//v//vsD//2AAHPgAAAHw4f3//4P//+H//5+Dj8B/sP/hvv7A32AAH//+G/x/+b7AHv/xvsD//+AAHPgAAAPx4fn//+H//4f//5/Dh+B/s/txvr7A32AAH//+H/5/+b7ADP/xvsD///AAHPgAAAfxwfn///j//w///9/Dx/B/s7V5/77A32AAG//+H/5v8b7AAP/xvsDff/AAHPgAAA/xwfnx//x//h//x9/Bx/B/s957///A32AAG+32H/5vsb7AAP/xvsDff7AAHPgAAAfhw/nwD/4//j/4B9/Bx/B/sf/z///g32AAG+32D/Zvsb7AIP/xvsDfb7AAHPgAAAfjw/nwAH8f/H8AB9/Bw/B/sPvj///g32AAG+32DfZvsb7AcP/xvsD/b7AAHPgAAAfjg/ngAB+f+PwAB9/h4+B/sAADf/9g32AAH+3+DfZ/8b7/+P//vsH/77AAHPgAAAPjg/nwAAeP+fAAB9/h4+B/sAADff9g32AAP///Df7/8b7/3P//vsH/7/AAHPgAAAPjg/nwAAfP+eAAB5/g48B/sAADfd9g32AAP///Df7/8b8AHP+zfsH///gAHPgAAAHDg/nwAAPP8+AAD5/g48Bv+AAH/d/x/2AAd//7j//f8b///P///sO//9wAHPgAAAHHg/3wAAHv88AAD5/g48D/3AAe/d+/v/AA7//93f/f8///2d///89//+4AHPgAAAPHg/3wAAHn84AAD5/g4+Hf3AAd///fv7gB3/7+//vfv3//ub///Y7+//cAHPgAAAfHg/z4AAHn84AAD7/g4+H/3AAd///fv/gB/97//fvf+///+d//+47+9/4AHPgAAAfHg/z4AAHn84AAHz/g4/Dv+AAP///5/3AA7979zvv/c7///P//9wd+9+4AHPgAAA/HA/54AAHv84AAHz/A4/h/8AAG//+w32AAf97/hv//4b8AfP/H7gP+9/wAHPgAAB/HA/58AAHv84AAPn/A4/x/sAAG+3+w32AAf///h///wb7/3P/77AN/9/wAHPgAAB/HA/8+AAHv+4AAfn/A4/x/sAAH+2/w32AAb//9h//+wb7/+P/7/gN//+wAHPgAAA/HAf8/AAPP+8AA/P/A4/h/sHGP++/432AAb//9g/++wb7A+P//9gN//+wAHPgAAA/Hgf+fwAff++AB+P/A4/B/sf/v++/432AAb//9g/2+wb7AcP/99gN//+wAHPgAAAfHgf/P8A+f/fgH8f/A4+B/s//9+A/Y32AAf8D/g32/wb7AAP/9/wP+B+wAHPgAAAPHgf/n/3++ff//4/+A4+B/s609///Y32AA////w33/wb7AAP///wf///wAHPgAAAHHgf/z//88Pv//x/+A48B/s/t9///Y32AA////w3//wb7AAP/3+wf///4AHPgAAAHDgP/4//5wDn//n/+A48B/sf/t///Y32Ac////w///gb7AHv/2/wb///4AHPgAAAPjgPf+P/zhh3/+f/+A48B/v9/v///433/+3//+w//9gb7//v/3/4b///4AHPgAAAPjgPv///nD47///+8B4+B////////833/23//+w//9gb7////3/Yb///YAHPgAAAfjgHn///PH8d///88B4+B/37//8Af833/m34B+wf59gb7/8//zfYb8A/YAHPgAAAfjwHz//+eP+ef//58Bw/B////7///83///33+/wb/9gb//+//zf8f7/fYAHPgAAAfjwHw//4+f/Pv//h4Bx/B////7///s3//3/3+/4b//gb//9//z/s///f4AHPgAAA/xwDwP/j8//Px/+D4Bx/A3//7b7Bvs3//v/+H/4b//gb//7v/xvs//Df8AHPgAAAfxwD4AAP8//n8BADwDx/A7//377Bvv3//v/+H/47//g7//7//xv///D/8AHPgAAAPx4B/4AP8//n8AH/wDh+Ad//v/bjt/+//3t+H7c//9x/f/+9m7t32/D9uAHPgAAAHw4///gH8//n4B///jj8Aef+d1rjrXrf/3L3O9Myutx23/+9afrTlbnWmAHPgAAAD4////wB8//ngD////j4AH//5//j///////+H/8///g//////7////D/+AHPgAAAB4////8A8efHAH////DwAD//w//B///////+H/4f//gf/////x///+D/8AHPgAAAB5+AP3+AMAAMAP7+B/ngAAP8AMMAYYIP/sQQAggGGMAEH//jDAYYIIAQQAHPgAAAB88AP9+AAAAIAfn8APnwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAGPgAAAB8eAH//AAAAAAf/4AOHwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOPAAAAB+PAD//AAAAAA//wAePwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOPAAAAB+PAH//AAAgAA//8AcPwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOfAAAAD+Hg///jABwAw///g8fwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAcfAAAAD/Hn///nDBww4///54f4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAceAAAAB/D/4H/nDhww4/8H/4/4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA4+AAAAA/h/AD/nDhww4/4A/w/8AAAMGAAAAAAAwYBgMBgMBgMAwYAAAAAADBgAAA4+AAAAAPz8AB//Dhw47/wAHx+cAAA//////////+H4/H4/H4fD//////////4AABx8AAAAADz8AA//jhw5//gAH7/OAAB///////////HweDweDwfH//////////8AADx8AAAAAD6eAAf//7////gAPD/HAAAcHAAAAAAAwcDweDweDweBwYAAAAAADBwAAHj4AAAAAD8eAAf///////AAeH/ngAAEGAAAAAAAwYAAAAAAAAAAwYAAAAAADBgAAPH4AAAAAD8PAAPz////7+AA+P/z4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAePwAAAAAD+HgAHzjhw4z+AA8P348AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB8fgAAAAAD/DwAH5jhw5z8AB4fz8fAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAH4/gAAAAAD/h4AD5Dhhwn4ADw/z+P4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/h/AAAAAAD/g8AD8BhgwH4APh/x/D/+AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAH/+D+AAAAAAB/weAB+ABgAPwAfD/g/wf+AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAH/4P8AAAAAAAP4PgA/AAAA/gA+H8Af8B+AB4B4AAJAAAAAAAAAAAAAgHwAAAIAIAH+A/4AAAAAAAB8HwAfwAAB/AB8PgAH/AOAH+H+eB59/4HgAeB7/zx8+P4Hg8Ph4AGAD/gAAAAAAAA+D4Af8AAP+AH4fgAD/+OAP/P/PB54/8HAAPBx/7548f8HgePA4AHA//AAAAAAAAA/B+AH/gB/8APg/gAA//uAP/f/Pjx4/8PgAPDx/5548/+HgfPB8AHP/8AAAAAAAAA/wfAD////wA/B/gAAP/uAePeHPnx488PgAPnx4Y/w88ePwfvB8AHP/4AAAAAAAAA/4PwB////AD+D/AAAD/uAePeHP3x48cPgAP3x4A/w88ePwfvB8AHP/AAAAAAAAAAf8D8Af//8AP4P/AAAAfuAeAeHP/x48cfwAP/x/gfg88APwf/D+AHP4AAAAAAAAAAf/B/gD//gA/gf/AAAAPuAeAeHP/x48cfwAP/x/gfA88Af4f/DuAHPgAAAAAAAAAAf/gf4ADAAH/A/+AAAAPuAeAeHP/x48cd4AP/x/gfg88Ac4f/HvAHPgAAAAAAAAAAAP4H/gAAB/4D+AAAAAPuAePeHPdx48c/4AP9x5g/g88ef4f/H/AHPgAAAAAAAAAAAH8A//gA//gP8AAAAAPuAeHeHPZx48c/4APZx4Q/w88e/8e/H/AHPgAAAAAAAAAAAH/AP////8A/4AAAAAPuAf/f/PJx4/9/8APJx/5748/+/8efP/gHPgAAAAAAAAAAAD/4A////gD/4AAAAAPuAP/P/PBx4/948APBx/5548f98+ePPHgHPgAAAAAAAAAAAD/+AB//wAP/wAAAAAPuAH+P+PD59/74+AfD5/7x8+f98++PfHwGPgAAAAAAAAAAAB//wAAAAB//wAAAAAPuAD8D8Pj59/j4+AfD7/zx8+Hz8/+HfHwGPgAAAAAAAAAAAB//+AAAAf//wAAAAAPmAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOPAAAAAAAAAAAAAAP/+AAP/+AAAAAAAPnAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOPAAAAAAAAAAAAAAP//////8AAAAAAAHnAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAcfAAAAAAAAAAAAAAH//////8AAAAAAAHzgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAcfAAAAAAAAAAAAAAD/////f4AAAAAAAHxwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA4+AAAAAAAAAAAAAAB4P//+DwAAAAAAAD58AAAAAAAAAAAAAAAAAAAAAAAAAAAAADw+AAAAAAAAAAAAAAAAH+P8AAAAAAAAAD8f//////////////////////////////h8AAAAAAAAAAAAAAAAD4D4AAAAAAAAAB+P//////////////////////////////D8AAAAAAAAAAAAAAAABgBwAAAAAAAAAA/D/////////////////////////////8H4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAfwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAf8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAB/gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP////////////////////////////////AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD///////////////////////////////+AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB///////////////////////////////4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAf//////////////////////////////gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB/////////////////////////////8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"

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
  try { return ([decimal]$n).ToString("N2", [Globalization.CultureInfo]::GetCultureInfo("es-CR")) }
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
function Build-TestTicket() { return "`n" + (Centro "GATO CALAVERA") + (Centro "PRUEBA DE IMPRESION") + (Linea) + (Col "Impresora" $PrinterName) + (Col "Estado" "OK") + (Col "Fecha" (Fecha)) + (Linea) + (Centro "SERVICIO LOCAL OK V9") }
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
  Write-Log "Iniciando servicio V9 RAW en 127.0.0.1:$Port"
  $listener = New-Object Net.HttpListener
  $listener.Prefixes.Add("http://127.0.0.1:$Port/")
  $listener.Start()
  Write-Log "Servicio activo V9 RAW"
  while ($listener.IsListening) {
    $ctx = $listener.GetContext()
    try {
      $path = $ctx.Request.Url.AbsolutePath.ToLowerInvariant()
      $method = $ctx.Request.HttpMethod.ToUpperInvariant()
      if ($method -eq "OPTIONS") { Send-Json $ctx 200 @{ ok = $true; version = "9.0" }; continue }
      if ($path -eq "/health") { $exists = $false; try { $null = Get-Printer -Name $PrinterName -ErrorAction Stop; $exists = $true } catch {}; Send-Json $ctx 200 @{ ok = $true; version = "9.0"; mode = "RAW_ESC_POS"; port = $Port; service = "GatoCalaveraPrintService"; printer = $PrinterName; printerFound = $exists; printerExists = $exists; message = "Servicio local Gato Calavera activo" }; continue }
      if ($path -eq "/test-print" -or $path -eq "/print/test") { Print-RawTicket (Build-TestTicket) "test"; Send-Json $ctx 200 @{ ok = $true; version = "9.0"; message = "Prueba enviada" }; continue }
      if ($path -eq "/print/factura") { $data = Get-JsonBody $ctx; Print-RawTicket (Build-Factura $data) "factura"; Send-Json $ctx 200 @{ ok = $true; version = "9.0"; message = "Factura enviada" }; continue }
      if ($path -eq "/print/comanda") { $data = Get-JsonBody $ctx; Print-RawTicket (Build-Comanda $data) "comanda"; Send-Json $ctx 200 @{ ok = $true; version = "9.0"; message = "Comanda enviada" }; continue }
      if ($path -eq "/print/cierre") { $data = Get-JsonBody $ctx; Print-RawTicket (Build-Cierre $data) "cierre"; Send-Json $ctx 200 @{ ok = $true; version = "9.0"; message = "Cierre enviado" }; continue }
      if ($path -eq "/print") { $data = Get-JsonBody $ctx; $tipo = if($data.tipo){[string]$data.tipo}else{"ticket"}; $texto = if($data.texto){[string]$data.texto}elseif($data.text){[string]$data.text}else{""}; if([string]::IsNullOrWhiteSpace($texto)){throw "Texto vacio"}; Print-RawTicket $texto $tipo; Send-Json $ctx 200 @{ ok = $true; version = "9.0"; message = "Ticket enviado" }; continue }
      Send-Json $ctx 404 @{ ok = $false; version = "9.0"; error = "Ruta no encontrada" }
    } catch { Write-Log "Error request: $($_.Exception.Message)"; try { Send-Json $ctx 500 @{ ok = $false; version = "9.0"; error = $_.Exception.Message } } catch {} }
  }
} catch { Write-Log "ERROR FATAL V9: $($_.Exception.Message)"; Start-Sleep -Seconds 3; throw }
