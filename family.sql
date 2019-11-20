DROP TABLE IF EXISTS public.client_information;

CREATE TABLE public.client_information

(
"CLIENT_ID" text not null,
"NAME" text,
"SURNAME" text,
"AGE" integer,
"COUNTRY" text,
"CITY" text,
"SALARY" text,
"ADDRESS" text,
	
CONSTRAINT client_information_pkey PRIMARY KEY ("CLIENT_ID")

)

WITH (

    OIDS = FALSE

)

TABLESPACE pg_default;

ALTER TABLE public.client_information

    OWNER to postgres;

	copy public.client_information  FROM '/Users/Public/client_information.csv' DELIMITER ';' CSV HEADER;