

DROP TABLE EQSL;

CREATE TABLE EQSL (
    DataKey      VARCHAR(48) NOT NULL,
    Callsign     VARCHAR(16),
    OrgCallsign  VARCHAR(16),
    OnDateTime   TIMESTAMP,
    Band         BIGINT,
    Band_M       VARCHAR(10),
    Mode         VARCHAR(10),
    Suffix       VARCHAR(10),
    GridLoc      VARCHAR(6),
    QSLMSG       VARCHAR(240), 
    Num          BIGINT,
    Match        SMALLINT,
    NewStation   SMALLINT,
    NewJCA       SMALLINT,
    Archived     SMALLINT,
    Printed      SMALLINT,
    isNew        SMALLINT,
    isMark     	 SMALLINT,
    DownloadDate TIMESTAMP
    MyCallsign   VARCHAR(16),
);

ALTER TABLE EQSL ADD CONSTRAINT pk_EQSL PRIMARY KEY (DataKey);



ALTER TABLE EQSL 
  ALTER ArchivedDate TO DownloadDate;

ALTER TABLE EQSL 
  ADD MyCallsign   VARCHAR(16);
