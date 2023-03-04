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