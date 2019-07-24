

DROP TABLE HAMLOG;

CREATE TABLE HAMLOG (
    Num          INTEGER NOT NULL,
    Callsign     VARCHAR(16),
    OrgCallsign  VARCHAR(16),
    onDateTime   TIMESTAMP,
    Freq         BIGINT,
    Band         BIGINT,
    RecvFreq     BIGINT,
    RecvBand     BIGINT,
    Mode         VARCHAR(10),
    Route        VARCHAR(10),
    Repeater     VARCHAR(10),
    Qsl          CHAR(1),
    QslSend      CHAR(1),
    QslRecv      CHAR(1),
    NetLogSend   VARCHAR(16),
    NetLogRecv   VARCHAR(16),
    Suffix       VARCHAR(10),
    GridLoc      VARCHAR(6),
);

ALTER TABLE HAMLOG ADD CONSTRAINT pk_HAMLOG PRIMARY KEY (Num);


