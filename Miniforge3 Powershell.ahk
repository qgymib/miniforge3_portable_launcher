; Miniforge3 portable launcher
#Requires AutoHotkey v2

; By default conda installation path is the same with script path.
condaPath := A_ScriptDir

; Command line arguments parser
args := A_Args
for idx, arg in args {
    if (arg = "/?" || arg = "-h" || arg = "--help") {
        ShowHelpAndExit()
        return
    }
    if (arg = "--conda") {
        if (idx < args.Length) {
            condaPath := args[idx + 1]
        } else {
            MsgBox("Missing argument to --conda")
            ExitApp
        }
    }
}

; Set current working directory
SetWorkingDir A_InitialWorkingDir

; Set $PATH
;condaBin := condaPath "\condabin"
;EnvSet("PATH", condaBin ";" EnvGet("PATH"))

; Run powershell and initialize micromamba
Run('powershell -NoExit -Command "' condaPath '\Scripts\conda.exe shell.powershell hook" | Out-String | ?{$_} | Invoke-Expression')

ShowHelpAndExit() {
    
    helpText := "
    (
    Usage:
        launcher [OPTIONS]

    Optional Arguments:
        /?, -h, --help    Show help message
        --conda <PATH>    Set conda installation path
    )"

    guiobj := Gui("+AlwaysOnTop", "Help")
    guiobj.Add("Text", "wrap", helpText)
    guiobj.Add("Button", "Default", "Ok").onEvent("Click", Ok_Click)
    guiobj.Show()
    Ok_Click(*){
        guiobj.Destroy()
        ExitApp
    }
}
