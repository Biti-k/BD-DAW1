declare
cursor c_ingressos is select * from ingressos;
v_nomhospital hospital.nom%type;
v_malalt malalt%rowtype;
begin
for v_ingres in c_ingressos loop
    select nom into v_nomhospital from hospital
    where hospital_cod = v_ingres.hospital_cod;
    select * into v_malalt from malalt
    where inscripcio = v_ingres.inscripcio;
    dbms_output.put_line(v_ingres.inscripcio|| ' ' ||
    v_ingres.hospital.cod || ' ' || v_ingres.sala_cod
    || ' ' || v_ingres.llit);
end loop;
end;

<-- Passem per cada iteració de la taula ingressos, totes les tuples. -!>

declare 
cursor c_hospital is select * from hospital;
cursor c_sala is select * from sala;
begin
for v_hospital in c_hospital loop
  if v_sala.hospital_cod = v_hospital.hospital_cod then
    dbms_output.put_line('--------------' || v_sala.nom
    ||' ' || v_sala.qtat_llits);
  end if;
end loop;
end;

-------Exercici 9. (CAS EMPRESA) Creeu un programa que calculi l’import mig de les comandes del client que
-------indiqui l’usuari (via variable de substitució, ens donarà el codi del client). La consulta del
-------cursor serà “select * from comanda”, i no es podrà modificar.
-------Fer també la versió modificant la consulta al gust del programador.

ACCEPT s_codi_client PROMPT 'Introdueix client'
declare
cursor c_comanda is select * from comanda;
v_clientcod client.client_cod%type := &s_codi_client;
v_qcomandes int := 0;
v_qtotal int := 0;
cursor c_comanda is select * from comanda;
begin 
  for v_comanda in c_comanda loop
    if v_comanda.client_cod = v_clientcod
      v_qcomandes := v_qcomandes + 1;
      v_qtotal := v_qtotal + v_comanda.total;
    end if;




end loop;
  dbms_output.put_line('el valor mig de les comandes del client: '
   || v_clientcod || ' es: ' || v_qtotal/v_qcomandes);

end;

--10. (CAS EMPRESA) Crea un bloc PL/SQL que determini els X empleats que més cobren.
--El guió preguntarà quants empleats vol veure (la X)
--En el bucle del cursor, has d’obtenir els noms i salaris dels X empleats amb sous més alts
--de la taula EMP.
--Fes la prova per a x=0, x=3 i x= 15.

ACCEPT s_quantitatMCobren PROMPT 'Introdueix quantitat llista dels que mes cobren: '
declare
  v_qtLlista int := &s_quantitatMCobren;
  v_contador int := 0;

  cursor c_empleats is select cognom, salari from emp where salari is not null
  order by salari desc;

begin
  for v_empleat in c_empleats loop
      if(v_contador < v_qtLlista ) then 
        dbms_output.put_line('El empleat ' || v_empleat.cognom || ' té un salari de ' || v_empleat.salari);
      end if;
      v_contador := v_contador + 1;
  end loop;  
end;

--també es pot fer amb un fetch first row only (&s_quantitatMCobren);
--o també d'aquesta

ACCEPT s_quantitatMCobren PROMPT 'Introdueix quantitat llista dels que mes cobren: '
declare
  v_qtLlista int := &s_quantitatMCobren;
  v_contador int := 0;

  cursor c_empleats is select cognom, salari from emp where salari is not null
  order by salari desc;
v_emp emp%rowtype;
v_i int := 1;
v_qt int := &s_x;

begin
  open c_emp;
    fetch c_emp into v_emp;
      while c_emp%found and v_i < qt loop
        dbms_output.put_line(v_emp.cognom || ' ' || v_emp.salari || ' ');
        fetch c_emp into v_emp;
        v_i := v_i + 1;
      end loop;
  close c_emp;
end;

--Exercici 11
--Executa una consulta mitjançant un cursor que recuperi els codis de
--departaments de la taula dept, i una altra consulta que recuperi el cognom i número de
--departament de tots els empleats. Cal fer un recorregut complet pel primer cursor i per
--cada departament, recórrer tots els empleats i quedar-nos amb les dades només dels
--empleats que treballen en el departament actual. Inserir el resultat a la columna
--“RESULTAT” de la taula PRACTICA. La taula PRÀCTICA cal crear-la com s’indica a
--continuació:
--CREATE TABLE PRACTICA ( RESULTAT varchar2 (50));
--A la columna resultat hi ha d&#39;haver el nom de l&#39;empleat i el departament del qual prové.
--(tot dins d’un mateix SCRIPT).
--La creació de la taula Practica cal fer-la fora del bloc PL/SQL
--RESULTAT



declare
cursor c_dept is select dept_no, dnom from DEPT;
cursor c_empleats is select cognom, dept_no from emp;

begin
  for v_dept in c_dept loop
    for v_empleat in c_empleats loop
      if(v_dept.dept_no = v_empleat.dept_no) then
        insert into PRACTICA(resultat) values (v_empleat.cognom || ' ' || v_dept.dnom ||' '
        || v_empleat.dept_no);
      end if;
    end loop;
  end loop;
end;

--M02 BASES DE DADES Grup 1r ICC0/ICB0
--UF3 Extensió procedimental PL/SQL Data: Març 2019
--C Exercicis Pàgines 2 / 3
--------------------------------------------------
--REY- Departament 10
--CEREZO- Departament 10
--MUÑOZ- Departament 10
--JIMENEZ- Departament 20
--FERNANDEZ- Departament 20
--SANCHEZ- Departament 20
--GIL- Departament 20
--ALONSO- Departament 20
--NEGRO- Departament 30
--ARROYO- Departament 30
--SALA- Departament 30
--MARTIN- Departament 30
--TOVAR- Departament 30
--JIMENO- Departament 30

/* Creeu un programa que llisti per pantalla les comandes que tenen més de
3 línies de detall (indicant el nombre de línies de detall ). Verifiqueu-ho amb una consulta.
Comanda numero --&gt; 619 data de la comanda --&gt; 22/02/87 total de
la comanda --&gt; 1260
i té 4 linies de detall
----------------------------------
Comanda numero --&gt; 605 data de la comanda --&gt; 14/07/86 total de
la comanda --&gt; 8324
i té 6 linies de detall
----------------------------------
Comanda numero --&gt; 613 data de la comanda --&gt; 01/02/87 total de la
comanda --&gt; 6400
i té 4 linies de detall
----------------------------------
Comanda numero --&gt; 616 data de la comanda --&gt; 03/02/87 total de
la comanda --&gt; 764
i té 5 linies de detall
----------------------------------
Comanda numero --&gt; 612 data de la comanda --&gt; 15/01/87 total de la
comanda --&gt; 5860
i té 4 linies de detall
----------------------------------
Comanda numero --&gt; 617 data de la comanda --&gt; 05/02/87 total de
la comanda --&gt; 46370
i té 10 linies de detall */


declare
cursor c_comanda is select * from comanda;
v_countD int;
begin
  for v_comanda in c_comanda loop
    select count(*) into v_countD from detall
    where com_num = v_comanda.com_num;
    if v_countD > 3 then
      dbms_output.put_line('Numero de comanda: ' || v_comanda.com_num || ' data comanda: ' || v_comanda.com_data
      || ' ' || v_comanda.total || ' ' || v_countD);
    end if;
  end loop;

end;

/* (CAS EMPRESA) Modifiqueu el programa anterior de forma que també es mostri el
percentatge que representa cada comanda respecte el total de vendes.
Comanda numero --&gt; 619 data de la comanda --&gt; 22/02/87
total de la comanda --&gt; 1260
i té 4 linies de detall i representa 1,22 % del total
----------------------------------
Comanda numero --&gt; 605 data de la comanda --&gt; 14/07/86
total de la comanda --&gt; 8324
i té 6 linies de detall i representa 8,04 % del total
----------------------------------

M02 BASES DE DADES Grup 1r ICC0/ICB0
UF3 Extensió procedimental PL/SQL Data: Març 2019
C Exercicis Pàgines 3 / 3
Comanda numero --&gt; 613 data de la comanda --&gt; 01/02/87
total de la comanda --&gt; 6400
i té 4 linies de detall i representa 6,18 % del total
----------------------------------
Comanda numero --&gt; 616 data de la comanda --&gt; 03/02/87
total de la comanda --&gt; 764
i té 5 linies de detall i representa ,74 % del total
----------------------------------
Comanda numero --&gt; 612 data de la comanda --&gt; 15/01/87
total de la comanda --&gt; 5860
i té 4 linies de detall i representa 5,66 % del total
----------------------------------
Comanda numero --&gt; 617 data de la comanda --&gt; 05/02/87
total de la comanda --&gt; 46370
i té 10 linies de detall i representa 44,76 % del total */
declare
cursor c_comanda is select * from comanda;
v_countD int;
v_total float;
v_percentatge number(4,2);
begin
  select sum(total) into v_total from comanda;
  for v_comanda in c_comanda loop
    select count(*) into v_countD from detall
    where com_num = v_comanda.com_num;
    if v_countD > 3 then
      v_percetatge := round(v.comanda.total * 100 / v_total, 2);
      dbms_output.put_line('Numero de comanda: ' || v_comanda.com_num || ' data comanda: ' || v_comanda.com_data
      || ' ' || v_comanda.total || ' ' || v_countD);
    end if;
  end loop;

end;


/* exercici 14 */
create table factura (
  num_factura number(3),
  com_num_associada number(4),
  client_cod number(6),
  total number(8,2),
  iva number(8,2),
  data_emissio date default sysdate,
  data_pagament date default null
);


/* Programeu un petit programa que mostri una llista amb el nom de
cadascun dels departaments i tots els seus empleats : */

--documento D, ejercicio 16.
declare
cursor c_emp(dept emp.dept_no%type) is select * from emp where dept_no = dept;
cursor c_dept is select * from dept;
v_numDept emp.dept_no%type;
begin
  for v_dept in c_dept loop
      dbms_output.put_line('Departament ' || v_dept.dept_no || ' ' ||
      v_dept.dnom || ' / ' || v_dept.loc);
      v_numDept := v_dept.dept_no;
    for v_emp in c_emp(v_numDept) loop
        dbms_output.put_line('...Empleat ' || v_emp.emp_no || ', ' ||
        v_emp.cognom);
    end loop;
  end loop;
end;

--documento D, ejercicio 15

accept 
declare

begin
  
end;