^j::

; This should run in the same user context as VS
; Ctrl + j in visual studio with the Line in "Find Symbol results" highlighted
; Then at the end Open a text file and Paste into it

Clipboard := "" ; Empty the Clipboard
copiedLines := ""
Send ^c
ClipWait

Clippy := Clipboard
ClippyLen := StrLen(clippy)
;MsgBox % "Starting " . Clippy . ":" . StrLen(Clippy)
while(ClippyLen > 0) {
	;MsgBox % "While loop: " . Clipboard . ClippyLen
	;if(StrLen(copiedLines) > 0) {
	;	copiedLines := copiedLines + "\r\n"
	;}
	if(StrLen(copiedLines) = 0) {
		copiedLines := Clipboard
	} else {
		copiedLines := copiedLines . Chr(10) . Clipboard
	}
	;MsgBox % "While loop: " . Clipboard . "-" . ClippyLen . "=" . copiedLines
	;MsgBox % copiedLines
	
	;Go to the next line below
	Send {Down}
	;Send {Home}
	;Send ^+{Right}
	
	;Clear the clipboard
	Clipboard := ""
	Send ^c
	ClipWait, 1
	
	if Clippy = Clipboard 
	{
		ClippyLen = 0 ; We havent found anything new
	}
	else if InStr(copiedLines, Clipboard)
	{
		;MsgBox % "While loop Exit(exists): " . Clipboard
		ClippyLen = 0 ; We have already copied it
	}
	else 
	{
		Clippy := Clipboard
		ClippyLen := StrLen(clippy)
		if(StrLen(Trim(ClippyLen)) = 0) {
			ClippyLen := 0
		}
	}
}

; Send %clipboard%
; Send ^v

MsgBox % "Copy finished"
Clipboard := copiedLines ;Copies the lines to the clipboar
