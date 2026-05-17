import posix, strutils

const
  Reset   = "\x1b[0m"
  Bold    = "\x1b[1m"
  Blue    = "\x1b[34m"
  Cyan    = "\x1b[36m"
  Magenta = "\x1b[35m"
  White   = "\x1b[37m"
  Yellow  = "\x1b[33m"
  Green   = "\x1b[32m"
  
const Colors = [Blue, Cyan, Magenta, White, Yellow, Green]

const
  logoAlpine = slurp("logos/alpine3_small.txt")
  logoArch   = slurp("logos/arch_small.txt")
  logoDebian = slurp("logos/debian_small.txt")
  logoFedora = slurp("logos/fedora2_small.txt")
  logoGentoo = slurp("logos/gentoo_small.txt")
  logoNixos  = slurp("logos/nixos_small.txt")
  logoVoid   = slurp("logos/void2_small.txt")


proc getOsId(): string =
  try:
    for line in lines("/etc/os-release"):
      if line.startsWith("ID="):
        var id =  line.replace("ID=", "")
        return id.strip(chars = {'"','\''})
  except IOError:
    discard
  return "arch"

proc getUnameData(): tuple[kernel, host: string] =
  var u: UtsName
  if uname(u) != 0: return ("unknown", "unknown")
  
  let k = $cast[cstring](addr u.release[0])
  let h = $cast[cstring](addr u.nodename[0])
  
  result = (kernel: k, host: h)

proc processLogo(rawLogo: string): string =
  result = rawLogo
  for i, color in Colors:
    result = result.replace("$" & $(i+1), color & Bold)

let osId = getOsId()
let sysInfo = getUnameData() 

let currentLogoRaw = case osId:
  of "alpine": logoAlpine
  of "arch":   logoArch
  of "debian": logoDebian
  of "fedora": logoFedora
  of "gentoo": logoGentoo
  of "nixos":  logoNixos
  of "void":   logoVoid
  else:        logoArch
let processedLogo = processLogo(currentLogoRaw)
let logoLines = processedLogo.splitLines()
let infoLines = @[ 
  "",
  Bold & White & sysInfo.host & Reset,
  "--------------------",
  Bold & Cyan & "Kernel: " & Reset & sysInfo.kernel
]

let maxLines = max(logoLines.len, infoLines.len)
echo "" 
for i in 0 ..< maxLines:
  let leftSide  = if i < logoLines.len: logoLines[i] & Reset else: "               " 
  let rightSide = if i < infoLines.len: infoLines[i] else: ""
  echo "  ", leftSide, "   ", rightSide
echo ""
