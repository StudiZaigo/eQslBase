

Drop Table Band;

CREATE TABLE Band(
    Band      BIGINT NOT NULL,
    Band_F    VARCHAR(10),
    Band_M    VARCHAR(10),
    BandCode  SMALLINT
);

ALTER TABLE Band ADD CONSTRAINT pk_BAND PRIMARY KEY (Band);


