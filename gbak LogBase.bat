gbak -b -user sysdba -password masterkey "c:\LogBase Projects\LogBase V1.0.0\LogBase.fdb" LogBase.bak

del "c:\LogBase Projects\LogBase V1.0.0\LogBase.fdb"

gbak -r -user sysdba -password masterkey LogBase.bak "c:\LogBase Projects\LogBase V1.0.0\LogBase.fdb" 
