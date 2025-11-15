alter table "public"."profiles" alter column "language" set default 'vi'::public."Language";

alter table "public"."profiles" alter column "language" set data type public."Language" using "language"::public."Language";


