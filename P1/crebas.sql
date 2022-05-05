/*==============================================================*/
/* DBMS name:      PostgreSQL 9.x                               */
/* Created on:     11.11.2021 09:37:05                          */
/*==============================================================*/


drop index BEINHALTET_FK;

drop index FLIEGT_FK;

drop index ABFLUG_PK;

drop table ABFLUG cascade;

drop index STARTET_FK;

drop index LANDET_FK;

drop index FLUG_PK;

drop table FLUG cascade;

drop index FLUGHAFEN_PK;

drop table FLUGHAFEN cascade;

drop index FLUGZEUG_PK;

drop table FLUGZEUG cascade;

/*==============================================================*/
/* Table: ABFLUG                                                */
/*==============================================================*/
create table ABFLUG (
   KENNZEICHEN          VARCHAR(60)          not null,
   FLUG_NR              VARCHAR(60)          not null,
   DATUM                DATE                 not null,
   constraint PK_ABFLUG primary key (KENNZEICHEN, FLUG_NR, DATUM)
);

/*==============================================================*/
/* Index: ABFLUG_PK                                             */
/*==============================================================*/
create unique index ABFLUG_PK on ABFLUG (
KENNZEICHEN,
FLUG_NR,
DATUM
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
FLUG_NR
);

/*==============================================================*/
/* Table: FLUG                                                  */
/*==============================================================*/
create table FLUG (
   FLUG_NR              VARCHAR(60)          not null,
   START                VARCHAR(60)          not null,
   ENDE                 VARCHAR(60)          not null,
   constraint PK_FLUG primary key (FLUG_NR)
);

/*==============================================================*/
/* Index: FLUG_PK                                               */
/*==============================================================*/
create unique index FLUG_PK on FLUG (
FLUG_NR
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

alter table ABFLUG
   add constraint FK_ABFLUG_BEINHALTE_FLUG foreign key (FLUG_NR)
      references FLUG (FLUG_NR)
      on delete restrict on update restrict;

alter table ABFLUG
   add constraint FK_ABFLUG_FLIEGT_FLUGZEUG foreign key (KENNZEICHEN)
      references FLUGZEUG (KENNZEICHEN)
      on delete restrict on update restrict;

alter table FLUG
   add constraint FK_FLUG_LANDET_FLUGHAFE foreign key (ENDE)
      references FLUGHAFEN (IATA_CODE)
      on delete restrict on update restrict;

alter table FLUG
   add constraint FK_FLUG_STARTET_FLUGHAFE foreign key (START)
      references FLUGHAFEN (IATA_CODE)
      on delete restrict on update restrict;

