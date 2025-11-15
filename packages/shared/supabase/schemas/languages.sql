do $$
    begin
        if not exists (select 1 from pg_type where typname = 'Language') then
            create type public."Language" as enum (
                'vi',
                'en'
            );
        end if;
end$$
