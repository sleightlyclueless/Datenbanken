//*==============================================================*/
/* DBMS name:      PostgreSQL 9.x                               */
/* Created on:     25.11.2021 09:27:13                          */
/*==============================================================*/


drop index BEINHALTET_FK;

drop index FLIEGT_FK;

drop index BUCHUNG_PK;

drop index GEHOERT_ZU_FK;

drop table BUCHUNG cascade;

drop index ABFLUG_PK;

drop table ABFLUG cascade;

drop index STARTET_FK;

drop index LANDET_FK;

drop index FLUG_PK;

drop table FLUG cascade;

drop index FLUGHAFEN_PK;

drop table FLUGHAFEN cascade;

drop index PASSAGIER_PK;

drop table PASSAGIER cascade;

drop index PRUFEN_FK;

drop index WARTUNG_PK;

drop table WARTUNG cascade;

drop index FLUGZEUG_PK;

drop table FLUGZEUG cascade;

/*==============================================================*/
/* Table: ABFLUG                                                */
/*==============================================================*/
create table ABFLUG (
   DATUM                DATE                 not null,
   KENNZEICHEN          VARCHAR(60)          not null,
   FLUGNR               VARCHAR(60)          not null,
   constraint PK_ABFLUG primary key (DATUM, KENNZEICHEN, FLUGNR)
);

/*==============================================================*/
/* Index: ABFLUG_PK                                             */
/*==============================================================*/
create unique index ABFLUG_PK on ABFLUG (
DATUM,
KENNZEICHEN,
FLUGNR
);

/*==============================================================*/
/* Index: FLIEGT_FK                                             */
/*==============================================================*/
create  index FLIEGT_FK on ABFLUG (
KENNZEICHEN
);

/*==============================================================*/
/* Index: BEINHALTET_FK                                         */
/*==============================================================*/
create  index BEINHALTET_FK on ABFLUG (
FLUGNR
);

/*==============================================================*/
/* Table: BUCHUNG                                               */
/*==============================================================*/
create table BUCHUNG (
   BUCHUNGSNR           SERIAL,
   KUNDENNR             INT4                 not null,
   DATUM                DATE                 not null,
   KENNZEICHEN          VARCHAR(60)          not null,
   FLUGNR               VARCHAR(60)          not null,
   SITZKLASSE           INT4                 DEFAULT 0,
   PREIS                DECIMAL              null,
   BUCHUNGSDATUM        DATE                 null,
   constraint PK_BUCHUNG primary key (BUCHUNGSNR)
);

/*==============================================================*/
/* Index: BUCHUNG_PK                                            */
/*==============================================================*/
create unique index BUCHUNG_PK on BUCHUNG (
BUCHUNGSNR
);

/*==============================================================*/
/* Index: GEHOERT_ZU_FK                                         */
/*==============================================================*/
create  index GEHOERT_ZU_FK on BUCHUNG (
DATUM,
KENNZEICHEN,
FLUGNR
);

/*==============================================================*/
/* Table: FLUG                                                  */
/*==============================================================*/
create table FLUG (
   FLUGNR               VARCHAR(60)          not null,
   START                VARCHAR(60)          not null,
   ENDE                 VARCHAR(60)          not null,
   constraint PK_FLUG primary key (FLUGNR)
);

/*==============================================================*/
/* Index: FLUG_PK                                               */
/*==============================================================*/
create unique index FLUG_PK on FLUG (
FLUGNR
);

/*==============================================================*/
/* Index: LANDET_FK                                             */
/*==============================================================*/
create  index LANDET_FK on FLUG (
ENDE
);

/*==============================================================*/
/* Index: STARTET_FK                                            */
/*==============================================================*/
create  index STARTET_FK on FLUG (
START
);

/*==============================================================*/
/* Table: FLUGHAFEN                                             */
/*==============================================================*/
create table FLUGHAFEN (
   IATA_CODE            VARCHAR(60)          not null,
   NAME                 VARCHAR(60)          not null,
   LAENGENGRAD          FLOAT8               not null,
   BREITENGRAD          FLOAT8               not null,
   constraint PK_FLUGHAFEN primary key (IATA_CODE)
);

/*==============================================================*/
/* Index: FLUGHAFEN_PK                                          */
/*==============================================================*/
create unique index FLUGHAFEN_PK on FLUGHAFEN (
IATA_CODE
);

/*==============================================================*/
/* Table: FLUGZEUG                                              */
/*==============================================================*/
create table FLUGZEUG (
   KENNZEICHEN          VARCHAR(60)          not null,
   TYP                  VARCHAR(60)          not null,
   SITZPLAETZE          INT4                 not null,
   constraint PK_FLUGZEUG primary key (KENNZEICHEN)
);

/*==============================================================*/
/* Index: FLUGZEUG_PK                                           */
/*==============================================================*/
create unique index FLUGZEUG_PK on FLUGZEUG (
KENNZEICHEN
);

/*==============================================================*/
/* Table: PASSAGIER                                             */
/*==============================================================*/
create table PASSAGIER (
   KUNDENNR             SERIAL,
   VORNAME              VARCHAR(60)          not null,
   NACHNAME             VARCHAR(60)          not null,
   BONUSMEILENKONTO     INT4                 DEFAULT 0,
   constraint PK_PASSAGIER primary key (KUNDENNR)
);

/*==============================================================*/
/* Index: PASSAGIER_PK                                          */
/*==============================================================*/
create unique index PASSAGIER_PK on PASSAGIER (
KUNDENNR
);

/*==============================================================*/
/* Table: WARTUNG                                               */
/*==============================================================*/
create table WARTUNG (
   WARTUNGSNR           SERIAL,
   KENNZEICHEN          VARCHAR(60)          not null,
   WARTUNGSDATUM        DATE                 not null,
   FLUGFREIGABE         BOOL                 not null,
   constraint PK_WARTUNG primary key (WARTUNGSNR)
);

/*==============================================================*/
/* Index: WARTUNG_PK                                            */
/*==============================================================*/
create unique index WARTUNG_PK on WARTUNG (
WARTUNGSNR
);

/*==============================================================*/
/* Index: PRUFEN_FK                                             */
/*==============================================================*/
create  index PRUFEN_FK on WARTUNG (
KENNZEICHEN
);

alter table ABFLUG
   add constraint FK_ABFLUG_BEINHALTE_FLUG foreign key (FLUGNR)
      references FLUG (FLUGNR)
      on delete restrict on update restrict;

alter table ABFLUG
   add constraint FK_ABFLUG_FLIEGT_FLUGZEUG foreign key (KENNZEICHEN)
      references FLUGZEUG (KENNZEICHEN)
      on delete restrict on update restrict;

alter table BUCHUNG
   add constraint FK_BUCHUNG_BUCHT_PASSAGIE foreign key (KUNDENNR)
      references PASSAGIER (KUNDENNR)
      on delete restrict on update restrict;

alter table BUCHUNG
   add constraint FK_BUCHUNG_GEHOERT_Z_ABFLUG foreign key (DATUM, KENNZEICHEN, FLUGNR)
      references ABFLUG (DATUM, KENNZEICHEN, FLUGNR)
      on delete restrict on update restrict;

alter table FLUG
   add constraint FK_FLUG_LANDET_FLUGHAFE foreign key (ENDE)
      references FLUGHAFEN (IATA_CODE)
      on delete restrict on update restrict;

alter table FLUG
   add constraint FK_FLUG_STARTET_FLUGHAFE foreign key (START)
      references FLUGHAFEN (IATA_CODE)
      on delete restrict on update restrict;

alter table WARTUNG
   add constraint FK_WARTUNG_PRUFEN_FLUGZEUG foreign key (KENNZEICHEN)
      references FLUGZEUG (KENNZEICHEN)
      on delete restrict on update restrict;

