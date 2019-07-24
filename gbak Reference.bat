gbak -b -user sysdba -password masterkey "c:\LogBase Projects\LogBase V1.0.0\Reference.fdb" Reference.bak

del "c:\LogBase Projects\LogBase V1.0.0\Reference.fdb"

gbak -r -user sysdba -password masterkey Reference.bak "c:\LogBase Projects\LogBase V1.0.0\Reference.fdb" 
