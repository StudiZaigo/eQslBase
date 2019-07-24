

/* Current DirectryÇ…DataBaseÇçÏê¨Ç∑ÇÈ */

CREATE DATABASE 'eQslBase.FDB'
  USER 'SYSDBA' PASSWORD 'masterkey'
  PAGE_SIZE=16384 DEFAULT CHARACTER SET UTF8; 

SET SQL DIALECT 3;

input "\udf\ib_udf.sql";
input "\udf\fbudf.sql";

CREATE USER DBUSER PASSWORD 'logbase';
GRANT ALL TO DBUSER;




/* Current DirectryÇÃDataBaseÇ…ê⁄ë±Ç∑ÇÈ */

CONNECT "eQslBase.FDB"
  USER 'SYSDBA' PASSWORD 'masterkey';

SET SQL DIALECT 3;


