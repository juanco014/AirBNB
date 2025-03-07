--Proyecte el listado de todas las columnas de todos los empleados.
SELECT * FROM HR.EMPLOYEES;


--Proyecte los empleados, como en el punto anterior, y ordene por nombre y apellido.
SELECT * FROM HR.EMPLOYEES 
ORDER BY FIRST_NAME, LAST_NAME;


--Seleccione los empleados para los cuales su nombre empieza por la letra K.
SELECT * FROM HR.EMPLOYEES 
WHERE FIRST_NAME LIKE 'K%';


--Seleccione los empleados cuyo nombre empieza por la letra K y ordene la
--proyección igual que el inmediato pasado punto con ordenamiento.
SELECT * FROM HR.EMPLOYEES 
WHERE FIRST_NAME LIKE 'K%' 
ORDER BY LAST_NAME, FIRST_NAME;


--Proyecte los IDs de departamentos (departments), con la cantidad de
--empleados(employees), que hay en cada uno de ellos (los departamentos).
SELECT DEPARTMENT_ID, COUNT(*) AS TOTAL_EMPLEADOS FROM HR.EMPLOYEES
GROUP BY DEPARTMENT_ID
ORDER BY DEPARTMENT_ID;


--Averigüe cual es la máxima cantidad máxima de empleados que departamento alguno tenga.
SELECT MAX(TOTAL_EMPLEADOS) AS MAX_CANTIDAD_EMPLEADOS FROM (
    SELECT DEPARTMENT_ID, COUNT(*) AS TOTAL_EMPLEADOS
    FROM HR.EMPLOYEES
    GROUP BY DEPARTMENT_ID
);


--Proyecte el ID y nombre de los empleados con el nombre del departamento en el que trabaja.
SELECT E.EMPLOYEE_ID, E.FIRST_NAME, E.LAST_NAME, D.DEPARTMENT_NAME FROM HR.EMPLOYEES E
JOIN HR.DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
ORDER BY E.EMPLOYEE_ID;


--Proyecte el número, nombre y salario de los empleados que trabajan en el
--departamento SALES.
SELECT E.EMPLOYEE_ID, E.FIRST_NAME, E.LAST_NAME, E.SALARY FROM HR.EMPLOYEES E JOIN HR.DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID WHERE D.DEPARTMENT_NAME = 'Sales'
ORDER BY E.EMPLOYEE_ID;
--este comando es para saber todos los nombres de los departamentos que hay 
SELECT DISTINCT DEPARTMENT_NAME FROM HR.DEPARTMENTS;


--Igual al anterior pero ordenado de mayor a menor salario.
SELECT E.EMPLOYEE_ID, E.FIRST_NAME, E.LAST_NAME, E.SALARY
FROM HR.EMPLOYEES E
JOIN HR.DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE D.DEPARTMENT_NAME = 'Sales'
ORDER BY E.SALARY DESC;


--Obtenga el número y nombre de cada empleado junto con su salario y grado
--salarial (Si falta la tabla de grado salarial, crearla y poblarla conforme se estudió el
--ejemplo de non-equijoin).
CREATE TABLE HR.SALARY_GRADES (
    GRADE_ID NUMBER PRIMARY KEY,
    MIN_SALARY NUMBER,
    MAX_SALARY NUMBER
);

INSERT INTO HR.SALARY_GRADES (GRADE_ID, MIN_SALARY, MAX_SALARY) VALUES (1, 0, 3000);
INSERT INTO HR.SALARY_GRADES (GRADE_ID, MIN_SALARY, MAX_SALARY) VALUES (2, 3001, 6000);
INSERT INTO HR.SALARY_GRADES (GRADE_ID, MIN_SALARY, MAX_SALARY) VALUES (3, 6001, 10000);
INSERT INTO HR.SALARY_GRADES (GRADE_ID, MIN_SALARY, MAX_SALARY) VALUES (4, 10001, 15000);
INSERT INTO HR.SALARY_GRADES (GRADE_ID, MIN_SALARY, MAX_SALARY) VALUES (5, 15001, 20000);

COMMIT;

SELECT E.EMPLOYEE_ID, E.FIRST_NAME, E.LAST_NAME, E.SALARY, S.GRADE_ID
FROM HR.EMPLOYEES E
JOIN HR.SALARY_GRADES S 
ON E.SALARY BETWEEN S.MIN_SALARY AND S.MAX_SALARY
ORDER BY S.GRADE_ID DESC, E.SALARY DESC;


--Proyectar el ID, nombre y grado salarial de los empleados que tienen grados
--salariales 2, 4 o 5.
SELECT E.EMPLOYEE_ID, E.FIRST_NAME, E.LAST_NAME, S.GRADE_ID
FROM HR.EMPLOYEES E
JOIN HR.SALARY_GRADES S 
ON E.SALARY BETWEEN S.MIN_SALARY AND S.MAX_SALARY
WHERE S.GRADE_ID IN (2, 4, 5)
ORDER BY S.GRADE_ID, E.EMPLOYEE_ID;


--Obtener el ID del departamento con el promedio salarial ordenado de mayor a menor.
SELECT DEPARTMENT_ID, ROUND(AVG(SALARY), 2) AS PROMEDIO_SALARIAL
FROM HR.EMPLOYEES
GROUP BY DEPARTMENT_ID
ORDER BY PROMEDIO_SALARIAL DESC;


--Proyectar el nombre del departamento con el promedio salarial ordenado de mayor a menor.
SELECT D.DEPARTMENT_NAME, ROUND(AVG(E.SALARY), 2) AS PROMEDIO_SALARIAL
FROM HR.DEPARTMENTS D
JOIN HR.EMPLOYEES E ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_NAME
ORDER BY PROMEDIO_SALARIAL DESC;


--Presentar el ID del departamento con la cantidad de empleados del
--departamento que cuente con el mayor número de empleados.
SELECT DEPARTMENT_ID, COUNT(*) AS TOTAL_EMPLEADOS
FROM HR.EMPLOYEES
GROUP BY DEPARTMENT_ID
HAVING COUNT(*) = (
    SELECT MAX(CANTIDAD)
    FROM (
        SELECT COUNT(*) AS CANTIDAD
        FROM HR.EMPLOYEES
        GROUP BY DEPARTMENT_ID
    )
);


--Encuentre los jefes (manager), presentando su ID y nombre, y el nombre del
--departamento donde trabajan.
SELECT DISTINCT M.EMPLOYEE_ID, M.FIRST_NAME, M.LAST_NAME, D.DEPARTMENT_NAME
FROM HR.EMPLOYEES E
JOIN HR.EMPLOYEES M ON E.MANAGER_ID = M.EMPLOYEE_ID
JOIN HR.DEPARTMENTS D ON M.DEPARTMENT_ID = D.DEPARTMENT_ID
ORDER BY M.EMPLOYEE_ID;


--Determinar los nombres de cada empleado junto con el grado salarial del
--empleado, el grado salarial del jefe y la diferencia de grado salarial existente con su
--jefe (grado del jefe – grado del empleado).
SELECT 
    E.EMPLOYEE_ID, 
    E.FIRST_NAME || ' ' || E.LAST_NAME AS EMPLEADO,
    SE.GRADE_ID AS GRADO_EMPLEADO,
    M.EMPLOYEE_ID AS ID_JEFE,
    M.FIRST_NAME || ' ' || M.LAST_NAME AS JEFE,
    SM.GRADE_ID AS GRADO_JEFE,
    (SM.GRADE_ID - SE.GRADE_ID) AS DIFERENCIA_GRADOS
FROM HR.EMPLOYEES E
JOIN HR.SALARY_GRADES SE 
    ON E.SALARY BETWEEN SE.MIN_SALARY AND SE.MAX_SALARY
LEFT JOIN HR.EMPLOYEES M 
    ON E.MANAGER_ID = M.EMPLOYEE_ID
LEFT JOIN HR.SALARY_GRADES SM 
    ON M.SALARY BETWEEN SM.MIN_SALARY AND SM.MAX_SALARY
ORDER BY E.EMPLOYEE_ID;


--Averiguar los IDs y nombres de los distintos departamentos en donde hay al
--menos un empleado que gana más de 3000 (Que no hayan tuplas repetidas).
SELECT DISTINCT D.DEPARTMENT_ID, D.DEPARTMENT_NAME
FROM HR.DEPARTMENTS D
JOIN HR.EMPLOYEES E ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
WHERE E.SALARY > 3000
ORDER BY D.DEPARTMENT_ID;


--Identificar los IDs y nombres de los distintos departamentos en donde hay al
--menos dos empleados distintos que ganan más de 2500.
SELECT D.DEPARTMENT_ID, D.DEPARTMENT_NAME
FROM HR.DEPARTMENTS D
JOIN HR.EMPLOYEES E ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
WHERE E.SALARY > 2500
GROUP BY D.DEPARTMENT_ID, D.DEPARTMENT_NAME
HAVING COUNT(E.EMPLOYEE_ID) >= 2
ORDER BY D.DEPARTMENT_ID;


--Encontrar los IDs y nombres de los empleados que ganan más dinero que su
--respectivo jefe.
SELECT E.EMPLOYEE_ID, E.FIRST_NAME || ' ' || E.LAST_NAME AS EMPLEADO, 
       E.SALARY AS SALARIO_EMPLEADO, 
       M.EMPLOYEE_ID AS ID_JEFE, 
       M.FIRST_NAME || ' ' || M.LAST_NAME AS JEFE, 
       M.SALARY AS SALARIO_JEFE
FROM HR.EMPLOYEES E
JOIN HR.EMPLOYEES M ON E.MANAGER_ID = M.EMPLOYEE_ID
WHERE E.SALARY > M.SALARY
ORDER BY E.EMPLOYEE_ID;


--Establecer los IDs y nombres de los departamentos en donde al menos uno de
--los empleados gana más de 3000 informando la cantidad de estos empleados
--identificada para cada departamento.
SELECT D.DEPARTMENT_ID, D.DEPARTMENT_NAME, COUNT(E.EMPLOYEE_ID) AS CANTIDAD_EMPLEADOS
FROM HR.DEPARTMENTS D
JOIN HR.EMPLOYEES E ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
WHERE E.SALARY > 3000
GROUP BY D.DEPARTMENT_ID, D.DEPARTMENT_NAME
ORDER BY CANTIDAD_EMPLEADOS DESC;


--Determinar los IDs y nombres de los departamentos en donde todos los
--empleados ganan más de 3000.
SELECT D.DEPARTMENT_ID, D.DEPARTMENT_NAME
FROM HR.DEPARTMENTS D
JOIN HR.EMPLOYEES E ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_ID, D.DEPARTMENT_NAME
HAVING MIN(E.SALARY) > 3000
ORDER BY D.DEPARTMENT_ID;


--Determinar los IDs y nombres de los departamentos en donde todos los
--empleados ganan más de 3000 y existe al menos un jefe que gana más de 5000.
SELECT D.DEPARTMENT_ID, D.DEPARTMENT_NAME
FROM HR.DEPARTMENTS D
JOIN HR.EMPLOYEES E ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
JOIN HR.EMPLOYEES M ON E.MANAGER_ID = M.EMPLOYEE_ID
GROUP BY D.DEPARTMENT_ID, D.DEPARTMENT_NAME
HAVING MIN(E.SALARY) > 3000 AND COUNT(CASE WHEN M.SALARY > 5000 THEN 1 END) > 0
ORDER BY D.DEPARTMENT_ID;


--Presentar los IDs y nombres de los empleados que no son del departamento 80
--y que ganan más que cualquiera de los empleados del departamento 80.
SELECT E.EMPLOYEE_ID, E.FIRST_NAME || ' ' || E.LAST_NAME AS EMPLEADO, E.SALARY
FROM HR.EMPLOYEES E
WHERE E.DEPARTMENT_ID <> 80
AND E.SALARY > (SELECT MAX(SALARY) FROM HR.EMPLOYEES WHERE DEPARTMENT_ID = 80)
ORDER BY E.SALARY DESC;
