' helper script for FileInformation CMake module

Function ToISODateTime(ByVal dt)
	ToISODateTime = CStr(Year(dt)) & "-" & _
		Right("00" & Month(dt), 2) & "-" & _
		Right("00" & Day(dt), 2) & "T" & _
		Right("00" & Hour(dt), 2) & ":" & _
		Right("00" & Minute(dt), 2) & ":" & _
		Right("00" & Second(dt), 2)
End Function

If WScript.Arguments.Count < 2 Then
	Wscript.Quit 1
End If

InputOption=WScript.Arguments.Item(0)
Set FSO=CreateObject("Scripting.FileSystemObject")
Set File=FSO.GetFile(WScript.Arguments.Item(1))

If InputOption = "--size" Then
	Wscript.Echo CStr(File.Size)
ElseIf InputOption = "--timestamp" Then
	Wscript.Echo ToISODateTime(File.DateLastModified)
Else
	Wscript.Quit 1
End If
