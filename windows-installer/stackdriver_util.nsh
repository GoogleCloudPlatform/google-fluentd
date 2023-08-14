;--------------------------------
; Utility functions and macros for Stackdriver installers.
;--------------------------------


;--------------------------------
; GLOBAL VARIABLES
;--------------------------------

; Uninstaller registry key, used to register the software uninstaller.
!define UNINST_REG_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall"

;--------------------------------
; Defines Print and UnPrint (uninstaller functions)
;
; Print outputs a string messages to the details for an
; installer/uninstaller.  It prints to both (list and text view).
; After printing it returns to the last used DetailsPrint setting.
;
; Call with:
;   ${Print}   "Message"
;   ${UnPrint} "Message"
;--------------------------------

; Generate two print details functions, one for installer sections
; and one for uninstaller sections.
!macro _STACKDRIVER_PRINT_DETAILS_FUNC_MACRO un
  Function ${un}PrintDetailsFunc
    ; Ensure we preserve the global var $0 with an exchange.
    ; $0 is on the top of the stack and $details_var is copied
    ; to $0.
    ; Stack: [details var, ...] -> [orig $0 val, ...]
    Exch $0
    ; Ensure we log to both outputs and restore the old print location.
    SetDetailsPrint both
    DetailPrint "$0"
    SetDetailsPrint lastused

    ; Restore $0
    ; Stack: [orig $0 val, ...] -> [...]
    Pop $0
  FunctionEnd
!macroend
!insertmacro _STACKDRIVER_PRINT_DETAILS_FUNC_MACRO ""
!insertmacro _STACKDRIVER_PRINT_DETAILS_FUNC_MACRO "un."

; Macro for Print to help pass along the details parameter
; on the stack.
!macro _STACKDRIVER_PRINT_DETAILS_MACRO details
  Push "${details}"
  Call PrintDetailsFunc
!macroend

; Macro for UnPrint to help pass along the details parameter
; on the stack.
!macro _STACKDRIVER_UN_PRINT_DETAILS_MACRO details
  Push "${details}"
  Call un.PrintDetailsFunc
!macroend

; Define the Print/UnPrint functions for ease of calling.
!define Print "!insertmacro _STACKDRIVER_PRINT_DETAILS_MACRO"
!define UnPrint "!insertmacro _STACKDRIVER_UN_PRINT_DETAILS_MACRO"
;--------------------------------
; END Print/UnPrint
;--------------------------------


;--------------------------------
; Defines ExecuteCommand and UnExecuteCommand (uninstaller functions)
;
; Executes a command with the given parameters via cmd.exe.
;
; Call with:
;   ${ExecuteCommand}   "Command" "Parameters"
;   ${UnExecuteCommand} "Command" "Parameters"
;--------------------------------

; Generate two execute command functions, one for installer sections
; and one for uninstaller sections.
!macro _STACKDRIVER_EXECUTE_COMMAND_FUNC_MACRO un
  Function ${un}ExecuteCommand
    ; Ensure we preserve the global vars $0, $1, $2.
    ; Stack: [command var, params var, ...]
    Exch $0 ; Command variable ; [command var, params var, ...] -> [orig $0, params var, ...]
    Exch    ; [orig $0, params var, ...] -> [params var, orig $0, ...]
    Exch $1 ; [params var, orig $0, ...] -> [orig $1, orig $0, ...]
    Push $2 ; [orig $1, orig $0, ...] -> [orig $2, orig $1, orig $0, ...]

    ; Get the absolute location of the cmd.exe executable.
    ReadEnvStr $2 COMSPEC

    ; Using nsExec::Exec over Exec as it hides the cmd pop up.
    nsExec::Exec '"$2" /C "$\"$0$\" $1"'

    ; The stack is restored by the macros.
  FunctionEnd
!macroend
!insertmacro _STACKDRIVER_EXECUTE_COMMAND_FUNC_MACRO ""
!insertmacro _STACKDRIVER_EXECUTE_COMMAND_FUNC_MACRO "un."

; Macro for ExecuteCommand to help pass along the parameters.
; via the stack
!macro _STACKDRIVER_EXECUTE_COMMAND_MACRO Command Parameters
  Push "${Parameters}"
  Push "${Command}"
  Call ExecuteCommand

  ; Get and log the return value of nsExec::Exec
  Pop $0
  ${Print} "nsExec::Exec return code: $0"

  ; Restore $0, $1, $2
  ; Stack: [orig $2, orig $1, orig $0, ...] -> [...]
  Pop $2
  Pop $1
  Pop $0
!macroend

; Macro for UnExecuteCommand to help pass along the parameters.
; via the stack
!macro _STACKDRIVER_UN_EXECUTE_COMMAND_MACRO Command Parameters
  Push "${Parameters}"
  Push "${Command}"
  Call un.ExecuteCommand

  ; Get and log the return value of nsExec::Exec
  Pop $0
  ${UnPrint} "nsExec::Exec return code: $0"

  ; Restore $0, $1, $2
  ; Stack: [orig $2, orig $1, orig $0, ...] -> [...]
  Pop $2
  Pop $1
  Pop $0
!macroend

; Define the ExecuteCommand/UnExecuteCommand functions for ease of calling.
!define ExecuteCommand "!insertmacro _STACKDRIVER_EXECUTE_COMMAND_MACRO"
!define UnExecuteCommand "!insertmacro _STACKDRIVER_UN_EXECUTE_COMMAND_MACRO"
;--------------------------------
; END ExecuteCommand/UnExecuteCommand
;--------------------------------


;--------------------------------
; Defines RemoveOldVersion
;
; Prompts the user the given program (name param) is already installed.
; If the candidate clicks 'OK' the uninstaller (uninstaller param) will
; be executed.  If they click 'Cancel' the install will be aborted.
;
; Call with:
;   ${RemoveOldVersion}   "Name" "Full path to uninstall executable"
;--------------------------------
!macro _STACKDRIVER_REMOVE_OLD_VERSION_MACRO name uninstaller
  ; Notify the user the program is already installed.
  MessageBox MB_OKCANCEL \
    "${name} is already installed.  Click 'OK' to remove the old \
    version and continue or 'Cancel' to exit the installer" \
    /SD IDOK \
    IDOK remove IDCANCEL abort

  ; The user does not want to unintall, abort the installer.
  abort:
    Abort

  ; Uninstall the program, honor silent options.
  remove:
    ${If} ${Silent}
      ExecWait '"${uninstaller}" /S _?=$INSTDIR'
    ${Else}
      ExecWait '"${uninstaller}" _?=$INSTDIR'
    ${EndIf}
!macroend

; Define the RemoveOldVersion function for ease of calling.
!define RemoveOldVersion "!insertmacro _STACKDRIVER_REMOVE_OLD_VERSION_MACRO"
;--------------------------------
; END RemoveOldVersion
;--------------------------------


;--------------------------------
; Defines RegisterUninstallSoftware
;
; Registers the software in the uninstall registry, installs for the current
; user or for the local machine based on install preferences.
;
; Call with:
;   ${RegisterUninstallSoftware} "Software Name" "SoftwareName" "Uninstaller location"
;       "Absolute path to icon" "Company name" "Estimated size in KB" "Version of agent"
;--------------------------------
!macro _STACKDRIVER_REGISTER_UNINSTALL_SOFTWARE_MACRO displayName compressedName uninstaller icon company sizeKB version
  ; Store global var $0 on the stack and copy the reg key to $0
  Push $0
  StrCpy $0 "${UNINST_REG_KEY}\${compressedName}"

  ; Write all the needed register information
  WriteRegStr HKLM "$0" "DisplayName" "${displayName}"
  WriteRegStr HKLM "$0" "UninstallString" "${uninstaller}"
  WriteRegStr HKLM "$0" "QuietUninstallString" "${uninstaller} /S"
  WriteRegStr HKLM "$0" "DisplayIcon" "${icon}"
  WriteRegStr HKLM "$0" "Publisher" "${company}"
  WriteRegDWORD HKLM "$0" "EstimatedSize" "${sizeKB}"
  WriteRegStr HKLM "$0" "Version" "${version}"

  ; We do not allow modifying or reparing an install
  WriteRegDWORD HKLM "$0" "NoModify" 1
  WriteRegDWORD HKLM "$0" "NoRepair" 1

  ; Restore the $0 global var
  Pop $0
 !macroend

; Define the RegisterUninstallSoftware function for ease of calling
!define RegisterUninstallSoftware "!insertmacro _STACKDRIVER_REGISTER_UNINSTALL_SOFTWARE_MACRO"
 ;--------------------------------
; END RegisterUninstallSoftware
;--------------------------------


;--------------------------------
; Defines RemoveRegisterUninstallSoftware
;
; Removes the registration for the software in the uninstall registry.
;
; Call with:
;   ${RemoveRegisterUninstallSoftware} "SoftwareName"
;--------------------------------
!macro _STACKDRIVER_REMOVE_REGISTER_UNINSTALL_SOFTWARE_MACRO name
  DeleteRegKey HKLM "${UNINST_REG_KEY}\${name}"
!macroend

 ; Define the RemoveRegisterUninstallSoftware function for ease of calling.
!define RemoveRegisterUninstallSoftware "!insertmacro _STACKDRIVER_REMOVE_REGISTER_UNINSTALL_SOFTWARE_MACRO"
;--------------------------------
; END RemoveRegisterUninstallSoftware
;--------------------------------
