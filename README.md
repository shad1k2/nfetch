# nfetch
Fetch utility written in Nim

Uses posix syscalls for os-release and uname 

Can be compiled only on any linux distro bc of /etc/release (i will make *nix support later)

For use compile:

    Download Nim compiler via your package manager
    
    Compile 
  
```bash
    nim c --mm:orc -d:release -d:danger
```
Or use binary

Repo binary compiled with

```bash
nim c --gcc.exe:musl-gcc --linker.exe:musl-gcc --passL:-static --mm:orc -d:release -d:danger --opt:size nfetch.nim
```
