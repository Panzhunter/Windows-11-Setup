#======================================================================
# ENABLING AND DISABLING POWERSHELL SCRIPT
#======================================================================
# Used to give permissions to just one user
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser 
# Used to take it away
Set-ExecutionPolicy Undefined -Scope CurrentUser 