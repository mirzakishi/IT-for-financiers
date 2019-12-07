
-- 1.1. Create table quotes (there is not primary key)


-- Table: quotes_task


-- DROP TABLE if exists public.quotes_task;



CREATE TABLE public.quotes
(
    "ID" character varying(7) COLLATE pg_catalog."default" NOT NULL,
    "TIME" date NOT NULL,
    "ACCRUEDINT" real,
    "ASK" real,
    "ASK_SIZE" integer,
    "ASK_SIZE_TOTAL" bigint,
    "AVGE_PRCE" money,
    "BID" real,
    "BID_SIZE" integer,
    "BID_SIZE_TOTAL" bigint,
    "BOARDID" text COLLATE pg_catalog."default",
    "BOARDNAME" text COLLATE pg_catalog."default",
    "BUYBACKDATE" date,
    "BUYBACKPRICE" money,
    "CBR_LOMBARD" real,
    "CBR_PLEDGE" real,
    "CLOSE" real,
    "CPN" real,
    "CPN_DATE" date,
    "CPN_PERIOD" integer,
    "DEAL_ACC" integer,
    "FACEVALUE" real,
    "ISIN" character varying(15) COLLATE pg_catalog."default",
    "ISSUER" text COLLATE pg_catalog."default",
    "ISSUESIZE" bigint,
    "MAT_DATE" date,
    "MPRICE" money,
    "MPRICE2" money,
    "SPREAD" real,
    "VOL_ACC" bigint,
    "Y2O_ASK" real,
    "Y2O_BID" real,
    "YIELD_ASK" real,
    "YIELD_BID" real
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;



ALTER TABLE public.quotes

    OWNER to postgres;




-- Sort of data in quotes.xlsx

-- a) change all commas(',') to dots('.') then save as csv.

-- b) column (B) TIME change format of short date

-- c) columns (Y) ISSUESIZE and (AD) VOL_ACC transform to numbers format and hide numbers after separator

-- d) column BAYBACKDATE consists of dates as well as datetime values, so change on dd.mm.yy hh:mm



--Importing data  

COPY public.quotes  FROM '/Users/Public/quotes_task.csv' DELIMITER ',' CSV HEADER;


-- Result: 1047800 rows



---------------------------------------------------------------------------------------------
-- 1.2. Create table bond_descriptionWITH PRIMARY KEY ("ISIN, RegCode, NRDCode")

--drop table if exists public.bond_description;


CREATE TABLE public.bond_description
(
    "ISIN, RegCode, NRDCode" varchar(15) NOT NULL,
    "FinToolType" text COLLATE pg_catalog."default" NOT NULL,
    "SecurityType" text COLLATE pg_catalog."default",
    "SecurityKind" text COLLATE pg_catalog."default",
    "CouponType" text COLLATE pg_catalog."default",
    "RateTypeNameRus_NRD" text COLLATE pg_catalog."default",
    "CouponTypeName_NRD" text COLLATE pg_catalog."default",
    "HaveOffer" boolean NOT NULL,
    "AmortisedMty" boolean NOT NULL,
    "MaturityGroup" text COLLATE pg_catalog."default",
    "IsConvertible" boolean NOT NULL,
    "ISINCode" varchar(15) NOT NULL,
    "Status" text COLLATE pg_catalog."default" NOT NULL,
    "HaveDefault" boolean NOT NULL,
    "IsLombardCBR_NRD" boolean,
    "IsQualified_NRD" boolean,
    "ForMarketBonds_NRD" boolean,
    "MicexList_NRD" text COLLATE pg_catalog."default",
    "Basis" text COLLATE pg_catalog."default",
    "Basis_NRD" text COLLATE pg_catalog."default",
    "Base_Month" text COLLATE pg_catalog."default",
    "Base_Year" text COLLATE pg_catalog."default",
    "Coupon_Period_Base_ID" integer,
    "AccruedintCalcType" boolean NOT NULL,
    "IsGuaranteed" boolean NOT NULL,
    "GuaranteeType" text COLLATE pg_catalog."default",
    "GuaranteeAmount" text COLLATE pg_catalog."default",
    "GuarantVal" bigint,
    "Securitization" text COLLATE pg_catalog."default",
    "CouponPerYear" integer,
    "Cp_Type_ID" smallint,
    "NumCoupons" integer,
    "NumCoupons_M" smallint NOT NULL,
    "NumCoupons_NRD" integer,
    "Country" text COLLATE pg_catalog."default" NOT NULL,
    "FaceFTName" text COLLATE pg_catalog."default" NOT NULL,
    "FaceFTName_M" smallint NOT NULL,
    "FaceFTName_NRD" text COLLATE pg_catalog."default",
    "FaceValue" real NOT NULL,
    "FaceValue_M" smallint NOT NULL,
    "FaceValue_NRD" real,
    "CurrentFaceValue_NRD" real,
    "BorrowerName" text COLLATE pg_catalog."default" NOT NULL,
    "BorrowerOKPO" bigint,
    "BorrowerSector" text COLLATE pg_catalog."default",
    "BorrowerUID" bigint NOT NULL,
    "IssuerName" text COLLATE pg_catalog."default" NOT NULL,
    "IssuerName_NRD" text COLLATE pg_catalog."default",
    "IssuerOKPO" bigint,
    "NumGuarantors" integer NOT NULL,
    "EndMtyDate" date,
	CONSTRAINT bond_description_pkey PRIMARY KEY ("ISIN, RegCode, NRDCode")
) 
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.bond_description
    OWNER to postgres;
	
	copy public.bond_description  FROM '/Users/Public/bond_description_task.csv' DELIMITER ';' CSV HEADER;

--DELETE FROM BOND_DESCRIPTION;
-----------------------------------------------------------------------------------------------------------------------

--СОЗДАНИЕ ТАБЛИЦЫ public.listing

DROP TABLE if exists public.listing;


CREATE TABLE public.listing
(
    "ID" bigint NOT NULL,
    "ISIN" character varying(15) COLLATE pg_catalog."default",
    "Platform" text COLLATE pg_catalog."default",
    "Section" text COLLATE pg_catalog."default",
	CONSTRAINT listing_pkey PRIMARY KEY ("ID")

)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.listing
    OWNER to postgres;

copy public.listing  FROM '/Users/Public/listing.csv' DELIMITER ';' CSV HEADER;

----------------------------------------------------------------------------------------------

--2.1.Firstly via the ALTER TABLE function add 5 columns which will contain information about emitent(from bond_description) and trading platform(from the quotes)

ALTER TABLE PUBLIC.LISTING
         add column "IssuerName" text  COLLATE pg_catalog."default",
         add column "IssuerName_NRD" text  COLLATE pg_catalog."default",
         add column "IssuerOKPO" bigint,
         add column "BOARDID" text  COLLATE pg_catalog."default",
         add column "BOARDNAME" text  COLLATE pg_catalog."default"


--2.2.Secondly filling columns from bond_description via the UPDATE function

update public.listing
set "IssuerName"=public.bond_description."IssuerName",
    "IssuerName_NRD" = public.bond_description."IssuerName_NRD", 
    "IssuerOKPO" = public.bond_description."IssuerOKPO" 
FROM public.bond_description
    WHERE public.bond_description."ISINCode" = public.listing."ISIN";

--2.3. Thirdly filling columns from quotes via the UPDATE function

update public.listing

set "BOARDID"=public.quotes."BOARDID",
     "BOARDNAME"=public.quotes."BOARDNAME"
FROM public.quotes
     where public.quotes."ISIN"=PUBLIC.listing."ISIN";
	 
--------------------------------------------------------------------------------------------	 
---- 3.Foreign key

    It is almost impossible)
		 
---------------------------------------------------------------------------------------------
4. --Final point
  
  -- a) count bids 
  
  SELECT "ISIN", count(*) as "num_bid"

FROM public.quotes

GROUP BY "ISIN";

-- b) count not null bids

SELECT "ISIN", count(*) AS "not_null_bid"

FROM public.quotes

WHERE "BID" IS NOT NULL

GROUP BY "ISIN";

-----------------------------------
-- d) count a share of not_null_bids

SELECT DISTINCT a."ISIN", b."not_null_bid"::real / a."num_bid"::real as "nun_ratio"

FROM (

	SELECT "ISIN", count(*) as "num_bid"

	FROM public.quotes

	GROUP BY "ISIN"

) as a

INNER JOIN (SELECT "ISIN", count(*) AS "not_null_bid"

			FROM public.quotes

			WHERE "BID" IS NOT NULL

			GROUP BY "ISIN"

) as b

ON a."ISIN"=b."ISIN"

WHERE (b."not_null_bid"::real/a."num_bid"::real ) >= 0.9

----------------------------------------------------------------
-- e) about platform and regime

SELECT "ISIN", "IssuerName"

FROM public.listing

WHERE "Platform" = 'Московская Биржа ' AND "Section" = ' Основной'

---------------------------------------------------------------------------

--Final query

SELECT DISTINCT c."ISIN", c."nun_ratio", d."IssuerName" as "Issuer"

FROM (SELECT DISTINCT a."ISIN", b."not_null_bid"::real / a."num_bid"::real as "nun_ratio"

	FROM (

	SELECT "ISIN", count(*) as "num_bid"

	FROM public.quotes
		
		--607 rows affected

	GROUP BY "ISIN"

) as a

INNER JOIN (SELECT "ISIN", count(*) AS "not_null_bid"

			FROM public.quotes

			WHERE "BID" IS NOT NULL

			GROUP BY "ISIN"

) as b

ON a."ISIN"=b."ISIN"

WHERE (b."not_null_bid"::real / a."num_bid"::real) >= 0.9) as c

INNER JOIN (SELECT "ISIN", "IssuerName"

FROM public.listing

WHERE "Platform" = 'Московская Биржа ' AND "Section" = ' Основной'

) as d

ON c."ISIN" = d."ISIN"


