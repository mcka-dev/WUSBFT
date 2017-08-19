# WUSBFT

## WUSB

Wake protocol library.

HTML: http://leoniv.diod.club/articles/wake/wake.html

PDF: http://leoniv.diod.club/articles/wake/downloads/wake.pdf

### Compiling and Building
- in Visual Studio 2017 for Windows (x86/x86-64):
  - WUSB32.dll (x86, 3584 Byte)
  - WUSB64.dll (x86-64, 4096 Byte)

- in GNU C++ for Linux (x86/x86-64):
  - libWUSB32.so (x86, 4780 Byte)
  - libWUSB64.so (x86-64, 5496 Byte)

- in GNU C++ for MacOS (x86-64):
  - libWUSB64.dylib (x86-64, 14980 Byte)

### Exported functions*:   
  - AccessUSB
  - CloseUSB
  - NumUSB
  - OpenUSB
  - PurgeUSB
  - RxFrameUSB
  - TxFrameUSB

*include JNI functions  

## Drivers

for Windows, Linux & MacOS

## Example

Example of use in 
  - Embarcadero Delphi v10.2 Tokyo (x86/x86-64)
  	- Windows 10

      <a href="https://github.com/mcka-dev/WUSBFT/blob/master/Example/Delphi/wake-delphi-example/Screenshots/Win10 (Rus) - Wake Delphi пример.png"><img src="https://github.com/mcka-dev/WUSBFT/blob/master/Example/Delphi/wake-delphi-example/Screenshots/Win10 (Rus) - Wake Delphi пример.png" alt="Windows 10: Wake Delphi пример" title="Windows 10: Wake Delphi пример"></a>
    - Windows 7

      <a href="https://github.com/mcka-dev/WUSBFT/blob/master/Example/Delphi/wake-delphi-example/Screenshots/Win7 (Eng) - Wake Delphi example.png"><img src="https://github.com/mcka-dev/WUSBFT/blob/master/Example/Delphi/wake-delphi-example/Screenshots/Win7 (Eng) - Wake Delphi example.png" alt="Windows 7: Wake Delphi example" title="Windows 7: Wake Delphi example"></a>
	- Windows XP

	  <a href="https://github.com/mcka-dev/WUSBFT/blob/master/Example/Delphi/wake-delphi-example/Screenshots/WinXP (Rus) - Wake Delphi пример.png"><img src="https://github.com/mcka-dev/WUSBFT/blob/master/Example/Delphi/wake-delphi-example/Screenshots/WinXP (Rus) - Wake Delphi пример.png" alt="Windows XP: Wake Delphi пример" title="Windows XP: Wake Delphi пример"></a>  

  - Java 8 (x86/x86-64)
    - Windows 10

	  <a href="https://github.com/mcka-dev/WUSBFT/blob/master/Example/Java/wake-java-example/screenshots/Win10 (Rus) - Wake Java пример.png"><img src="https://github.com/mcka-dev/WUSBFT/blob/master/Example/Java/wake-java-example/screenshots/Win10 (Rus) - Wake Java пример.png" alt="Windows 10: Wake Java пример" title="Windows 10: Wake Java пример"></a>

    - Windows 7

      <a href="https://github.com/mcka-dev/WUSBFT/blob/master/Example/Java/wake-java-example/screenshots/Win7 (Eng) - Wake Java example.png"><img src="https://github.com/mcka-dev/WUSBFT/blob/master/Example/Java/wake-java-example/screenshots/Win7 (Eng) - Wake Java example.png" alt="Windows 7: Wake Java example" title="Windows 7: Wake Java example"></a>

    - Windows XP

      <a href="https://github.com/mcka-dev/WUSBFT/blob/master/Example/Java/wake-java-example/screenshots/WinXP (Rus) - Wake Delphi пример.png"><img src="https://github.com/mcka-dev/WUSBFT/blob/master/Example/Java/wake-java-example/screenshots/WinXP (Rus) - Wake Delphi пример.png" alt="Windows XP: Wake Delphi пример" title="Windows XP: Wake Delphi пример"></a>

    - Ubuntu

      <a href="https://github.com/mcka-dev/WUSBFT/blob/master/Example/Java/wake-java-example/screenshots/Ubuntu (Eng) - Wake Java example.png"><img src="https://github.com/mcka-dev/WUSBFT/blob/master/Example/Java/wake-java-example/screenshots/Ubuntu (Eng) - Wake Java example.png" alt="Ubuntu: Wake Java example" title="Ubuntu: Wake Java example"></a>

    - Debian
    
      <a href="https://github.com/mcka-dev/WUSBFT/blob/master/Example/Java/wake-java-example/screenshots/Debian (Eng) - Wake Java example.png"><img src="https://github.com/mcka-dev/WUSBFT/blob/master/Example/Java/wake-java-example/screenshots/Debian (Eng) - Wake Java example.png" alt="Debian: Wake Java example" title="Debian: Wake Java example"></a>

    - MacOS
    
      <a href="https://github.com/mcka-dev/WUSBFT/blob/master/Example/Java/wake-java-example/screenshots/MacOS (Rus) - Wake Java пример.png"><img src="https://github.com/mcka-dev/WUSBFT/blob/master/Example/Java/wake-java-example/screenshots/MacOS (Rus) - Wake Java пример.png" alt="Debian: Wake Java example" title="MacOS: Wake Java пример"></a>

## License

Code released under the <a href="https://github.com/mcka-dev/WUSBFT/blob/master/LICENSE">MIT License</a>
