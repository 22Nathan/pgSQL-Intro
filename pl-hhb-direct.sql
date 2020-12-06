
create or replace function getOneTuple() returns record
language plpgsql
as
$function$
	declare
			res record ;
	begin
			select into res * from client ;
			return res ;
	end;		
$function$;		
/* 
Résultat obtenu : 
un tuple de la table client
*/	
/*-----------------------------------------------------------------------------------------------*/

create or replace function getOneTupleTable() returns SETOF client
language plpgsql
as
$function$
	begin
		return query select * from client ;
	end;
$function$;		
/* 
Résultat obtenu : 
tous les tuples de la table client
*/	
/*-----------------------------------------------------------------------------------------------*/

create or replace function lesClients() returns SETOF client
language plpgsql
as
$function$
	declare
		res client%ROWTYPE ;
	begin
		for res in select * from client
		loop
			return next res ;
		end loop;
		return;	
	end;
$function$;		
/* 
Résultat obtenu : 
tous les tuples de la table client
*/	
/*-----------------------------------------------------------------------------------------------*/

create or replace function nb_operation_compte_mois( integer , integer , integer , integer ) returns setof operation
language plpgsql
as
$function$
	declare
		aaa operation%ROWTYPE ;
		
	begin
		
		
		for aaa in select count(id_operation) from operation where num_compte = $3 
		and extract( Year from date ) = $2
		and extract( Month from date ) = $1 
		and id_type = $4 
		loop
			return next aaa ;
		end loop;	

	return;
	end;
$function$;		

/*-----------------------------------------------------------------------------------------------*/

create or replace function creer_id_internet( text , text ) returns void
language plpgsql
as
$function$
	declare
		aaa client%ROWTYPE ;
		id text ;
		id2 text ;
		num integer ;
		i integer ; 
		
	begin
		id := concat( upper( SUBSTR($2, 1, 1)::char(1) ) , $1 ) ;
		num := 1 ;
		i := 0 ;
		
		/*for aaa in select * from client 
		loop
			if id = (select identifiant_internet from client where identifiant_internet = id limit 1) then
				num := num + 1 ;	
				id := concat( id , num::text ) ;			
			end if ;			
		end loop ;*/
		
		if i < ( select count(*) from client where nom_client = $1 and prenom_client = $2 ) then
		
			num := num + count(*) from client where nom_client = $1 and prenom_client = $2 ;
			id2 := concat( id , num::text ) ;
			insert into client ( nom_client , prenom_client , identifiant_internet , mdp_internet ) values ( $1 , $2 , id2 , id2 ) ;
			return ;
			
		end if;

		/*id2 := concat( upper( SUBSTR($2, 1, 1)::char(1) ) , $1 ) ;
		id2 := concat( id2 , num::text ) ;
		mdp := id2 ;*/
		
		insert into client ( nom_client , prenom_client , identifiant_internet , mdp_internet ) values ( $1 , $2 , id , id ) ;

	return ;
	end;
$function$;		

/*-----------------------------------------------------------------------------------------------*/

create or replace function creer_date( integer , integer ) returns void
language plpgsql
as
$function$
	declare
		i integer ;
		zz text ;
		aaa integer ;
		date date ;
		pop date ;
		
	begin
		
		i := 1 ;
		if $1 < 10 then
			date := to_date( concat($2::text,0,$1,'00')::text , 'YYYYMMDD' )::date ;
			aaa := DATE_PART('days', DATE_TRUNC('month', date) + '1 MONTH'::INTERVAL - '1 DAY'::INTERVAL) ;
			loop 
				zz := concat($2,'-',$1,'-',i) ;
				pop := to_date( zz , 'YYYY-MM-DD' ) ;
				insert into date values ( pop ) ;
				i := i + 1 ;
				exit when i > aaa ;
			end loop;
			return ;
		end if;
		
			date := to_date( concat($2::text,$1,'00')::text , 'YYYYMMDD' )::date ;
			aaa := DATE_PART('days', DATE_TRUNC('month', date) + '1 MONTH'::INTERVAL - '1 DAY'::INTERVAL) ;
			loop 
				zz := concat($2,'-',$1,'-',i) ;
				pop := to_date( zz , 'YYYY-MM-DD' ) ;
				insert into date values ( pop ) ;
				i := i + 1 ;
				exit when i > aaa ;
			end loop;
	return ;		
	end;
$function$;	

/*-----------------------------------------------------------------------------------------------*/

create or replace function creer_user_client() returns integer
language plpgsql
as
$function$
	declare
		i integer ;
		ii integer ;
		iii integer ;
		id text ;
		max integer ;
		aaa client%ROWTYPE ;
		
	begin
	i := 0 ;
	ii := 0 ;
	select max(num_client) into max from client ;
	/*select identifiant_internet into id from client ;
	id := lower(id) ;*/
	
		/*for i in select max(num_client) from client*/
		while i < max
		loop
			if exists ( select identifiant_internet from client where num_client = i ) then
				select identifiant_internet into id from client where num_client = i ;
				id := lower(id) ;
				if not exists ( select * from pg_catalog.pg_user where usename = id ) then
			    /*if i = ( select count(*) from pg_catalog.pg_user where usename = id ) then*/	
					execute ' create role '||id||' with login password '''||id||''' ' ;
					ii := ii + 1 ;
				end if ;
			end if ;
			i := i + 1 ;
		end loop ; 			
	return ii ;		
	end;
$function$;	

/*-----------------------------------------------------------------------------------------------*/


