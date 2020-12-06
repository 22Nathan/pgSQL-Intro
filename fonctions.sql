

create or replace function calculer_longueur_max(arg1 varchar(255), arg2 varchar(255)) returns integer as $$ 
	declare 
		len1 integer ;
		len2 integer ;
	
	begin
		len1 := length( arg1 ) ;
		len2 := length( arg2 ) ;
		
		if len1 > len2 then
			return len1 ;
		else 
			return len2 ;
		end if ;

	end ;
$$ language plpgsql ;	

/*--------------------------------------------------------------------------------------------------------------------------------------*/	

create or replace function nb_occurrences( char(1),  varchar(100),  integer,  integer) returns integer as $$
		declare
			num integer ;
			compteur integer ;
			compteur2 integer ;
			
		begin
			num := 1 ;
			compteur := 0 ;
			compteur2 := 0 ;
			
			for num in $3..$4 loop 
			
				if $1 = SUBSTR($2, compteur, 1)::char(1) then
					compteur2 := compteur2 + 1 ; 
				end if ;
				compteur := compteur + 1 ;
				
			end loop ;
		
		return compteur2 ;
		end ;
$$ language plpgsql ;	

/*--------------------------------------------------------------------------------------------------------------------------------------*/

create or replace function nb_occurrences( char(1),  varchar(100),  integer,  integer) returns integer as $$
		declare
			num integer ;
			compteur integer ;
			compteur2 integer ;
			
		begin
			num := 1 ;
			compteur := 0 ;
			compteur2 := 0 ;
			
			loop 
			
				if $1 = SUBSTR($2, compteur, 1)::char(1) then
					compteur2 := compteur2 + 1 ; 
				end if ;
				compteur := compteur + 1 ;
				exit when compteur - 1 = $4 ;
				
			end loop ;
		
		return compteur2 ;
		end ;
$$ language plpgsql ;	

/*--------------------------------------------------------------------------------------------------------------------------------------*/

create or replace function nb_occurrences( char(1),  varchar(100),  integer,  integer) returns integer as $$
		declare
			num integer ;
			compteur integer ;
			compteur2 integer ;
			
		begin
			num := 1 ;
			compteur := 0 ;
			compteur2 := 0 ;
			
			while compteur - 1 != $4 loop 
			
				if $1 = SUBSTR($2, compteur, 1)::char(1) then
					compteur2 := compteur2 + 1 ; 
				end if ;
				compteur := compteur + 1 ;
				
			end loop ;
		
		return compteur2 ;
		end ;
$$ language plpgsql ;	

/*--------------------------------------------------------------------------------------------------------------------------------------*/

create or replace function getNbJoursParMois( date ) returns integer as $$
	declare
		aaa integer ;
				
	begin
		aaa := DATE_PART('days', DATE_TRUNC('month', $1) + '1 MONTH'::INTERVAL - '1 DAY'::INTERVAL) ;
	
	return aaa ;
	end ;
$$ language plpgsql ;	
		
/*--------------------------------------------------------------------------------------------------------------------------------------*/

create or replace function dateSqlToDatefr( date ) returns text as $$
	declare
		
		YYYY text ;
		MM text ;
		DD text ;
		
		aaa1 text ;
		aaa2 text ;
		aaa3 text ;
		aaa4 text ;
		ccc date ;
		
	begin
			
			YYYY := extract (YEAR FROM $1) ;
			MM := extract (MONTH FROM $1) ;
			DD := extract (DAY FROM $1) ;
			
			aaa1 := DD || '/' ;
			aaa2 := aaa1 || MM ;
			aaa3 := aaa2 || '/' ;
			aaa4 := aaa3 || YYYY ;
			
			ccc := TO_DATE(aaa4::text, 'DD/MM/YYYY'::text)::date ;
	
	return aaa4 ;
	end ;
$$ language plpgsql ;			

/*--------------------------------------------------------------------------------------------------------------------------------------*/

create or replace function getNomJour( date ) returns text as $$
	declare 
			i integer ; 
			aaa text ;
	begin
			i := extract(isodow from  $1) ;
			case i
				when 1 then aaa := 'Lundi';
				when 2 then aaa := 'Mardi';
				when 3 then aaa := 'Mercredi';
				when 4 then aaa := 'Jeudi';
				when 5 then aaa := 'Vendredi';
				when 6 then aaa := 'Samdi';
				when 7 then aaa := 'Dimanche';
			end case;	
			
	return aaa ; 
	
	end;
$$ language plpgsql ;

/*--------------------------------------------------------------------------------------------------------------------------------------*/

create or replace function nb_Client_Debiteurs() returns integer as $$
	declare 
			i integer ;
			ii integer ;
			aaa operation%ROWTYPE ;
			max integer ;	
	begin
			i := 0 ;
			ii := 0 ;
			select max(id_operation) into max from operation ;
			while i < max
				loop
					if exists ( select num_compte from operation where type_operation = 'DEBIT' and num_compte = i) then
						ii := ii + 1 ;
					end if ;
					i := i + 1 ;
				end loop;		
	return ii ; 
	end;
$$ language plpgsql ;

/*--------------------------------------------------------------------------------------------------------------------------------------*/

create or replace function nb_client_ville( text ) returns integer as $$
	declare
			ville text ;
			aaa text ;  
			i integer ;
			ii integer ;
			iii integer ;
			max integer ;
			bbb integer ;
		
	begin
			i := 1 ;
			select max(num_client) into max from client ;
			while i < max
				loop
					if exists ( select adresse_client from client where num_client = i ) then
						select adresse_client into ville from client where num_client = i ;
						aaa := split_part( ville , ', ' , 2 ) ;
						
						/*aaa := split_part( aaa , ' ' , 2 ) ;*/
						ii := position( ' ' in aaa ) ;
						iii := char_length( aaa ) ;
						aaa := SUBSTR( aaa , ii + 1 , iii ) ;
						
						if lower( $1 ) = lower( aaa ) then
							select count(num_client) into bbb from client where adresse_client = ville ;
							return bbb ;
						end if ;
						else 
							bbb := 0 ;
					end if ;
				i := i + 1 ;
				end loop ; 
			return bbb ;	
	end;
$$ language plpgsql ;

/*--------------------------------------------------------------------------------------------------------------------------------------*/

create or replace function enr_client( text , text , text , text , text ) returns text as $$
	declare
		i integer ;
		max integer ;
		max2 integer ;
		
	begin
		select max(num_client) into max from client ;
		max := max + 1 ;
		execute 'insert into client values ( '||max||' , '''||$1||''' , '''||$2||''' , '''||$3||''' , '''||$4||''' , '''||$5||''' )' ;
		select max(num_client) into max2 from client ;
		if exists ( select * from client where num_client = max and nom_client = $1 and prenom_client = $2 ) then
			return 'bien enregistré' ;
		end if;
		return 'Echec de l enregistrement' ;
	end;
$$ language plpgsql ;

/*--------------------------------------------------------------------------------------------------------------------------------------*/

create or replace function azert( text ) returns text as $$
	declare
			ville text ;
			aaa text ;  
			i integer ;
			max integer ;
			bbb integer ;
		
	begin
			i := 1 ;
			select max(num_client) into max from client ;
			while i < max
				loop
					if exists ( select adresse_client from client where num_client = i ) then
						select adresse_client into ville from client where num_client = i ;
						aaa := split_part( ville , ', ' , 2 ) ;
						aaa := split_part( aaa , ' ' , 2 ) ;
						
						/*if lower( $1 ) = lower( aaa ) then
							select count(num_client) into bbb from client where adresse_client = ville ;
							aaa := '15' ;
						end if ;
						else 
							aaa := '0';*/
					end if ;
				i := i + 1 ;
				end loop ; 
			return aaa ;	
	end;
$$ language plpgsql ;

