
/*
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
*/	
/*--------------------------------------------------------------------------------------------------------------------------------------*/	
/*	
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
*/
/*--------------------------------------------------------------------------------------------------------------------------------------*/
/*
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
*/
/*--------------------------------------------------------------------------------------------------------------------------------------*/
/*
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
*/
/*--------------------------------------------------------------------------------------------------------------------------------------*/
/*
create or replace function getNbJoursParMois( date ) returns integer as $$
	declare
		aaa integer ;
				
	begin
		aaa := DATE_PART('days', DATE_TRUNC('month', $1) + '1 MONTH'::INTERVAL - '1 DAY'::INTERVAL) ;
	
	return aaa ;
	end ;
$$ language plpgsql ;	
*/		
/*--------------------------------------------------------------------------------------------------------------------------------------*/
/*
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
*/
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








