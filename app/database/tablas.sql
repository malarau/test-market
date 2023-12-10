/*
    DROP TABLES
*/

DROP TABLE MMMB_DESCUENTO cascade constraints;
DROP TABLE MMMB_DETALLE_VENTA_PRODUCTO cascade constraints;
DROP TABLE MMMB_VENTA cascade constraints;
DROP TABLE MMMB_MEDIO_PAGO cascade constraints;
DROP TABLE MMMB_CLIENTE cascade constraints;
DROP TABLE MMMB_DETALLE_CUADRATURA cascade constraints;
DROP TABLE MMMB_CAJA cascade constraints;
DROP TABLE MMMB_SUCURSAL cascade constraints;
DROP TABLE MMMB_DETALLE_BODEGA_PRODUCTO cascade constraints;
DROP TABLE MMMB_BODEGA cascade constraints;
DROP TABLE MMMB_DETALLE_PRODUCTO_PROVEEDOR cascade constraints;
DROP TABLE MMMB_PRODUCTO cascade constraints;
DROP TABLE MMMB_PROVEEDOR cascade constraints;
DROP TABLE MMMB_CATEGORIA cascade constraints;
DROP TABLE MMMB_MARCA cascade constraints;
DROP TABLE MMMB_DETALLE_TURNO_HORARIO cascade constraints;
DROP TABLE MMMB_TURNO cascade constraints;
DROP TABLE MMMB_HORARIO cascade constraints;
DROP TABLE MMMB_EMPLEADO cascade constraints;
DROP TABLE MMMB_CARGO cascade constraints;
DROP TABLE MMMB_HISTORIAL_PRECIOS cascade constraints;

/*
    SEQUENCES
*/
DROP SEQUENCE MMMB_PK_TURNO;
DROP SEQUENCE MMMB_PK_HORARIO;
DROP SEQUENCE MMMB_PK_PRODUCTO;
DROP SEQUENCE MMMB_PK_CATEGORIA;
DROP SEQUENCE MMMB_PK_PROVEEDOR;
DROP SEQUENCE MMMB_PK_CAJA;
DROP SEQUENCE MMMB_PK_DETALLE_CUADRATURA;
--DROP SEQUENCE MMMB_PK_MEDIO_PAGO;
DROP SEQUENCE MMMB_PK_VENTA;
DROP SEQUENCE MMMB_PK_DESCUENTO;
DROP SEQUENCE MMMB_PK_HISTORIAL_PRECIOS;
DROP SEQUENCE MMMB_PK_MARCA;

-- Usados

CREATE SEQUENCE MMMB_PK_TURNO
    START WITH 1
    INCREMENT BY 1
    CACHE 10;

CREATE SEQUENCE MMMB_PK_HORARIO
    START WITH 1
    INCREMENT BY 1
    CACHE 10;

CREATE SEQUENCE MMMB_PK_PRODUCTO
    START WITH 1
    INCREMENT BY 1
    CACHE 10;

CREATE SEQUENCE MMMB_PK_CATEGORIA
    START WITH 1
    INCREMENT BY 1
    CACHE 10;

CREATE SEQUENCE MMMB_PK_MARCA
    START WITH 1
    INCREMENT BY 1
    CACHE 10;

CREATE SEQUENCE MMMB_PK_PROVEEDOR
    START WITH 75000001
    INCREMENT BY 1
    CACHE 10;

CREATE SEQUENCE MMMB_PK_CAJA
    START WITH 1
    INCREMENT BY 1
    CACHE 10;

CREATE SEQUENCE MMMB_PK_DETALLE_CUADRATURA
    START WITH 1
    INCREMENT BY 1
    CACHE 10;

CREATE SEQUENCE MMMB_PK_VENTA
    START WITH 1
    INCREMENT BY 1
    CACHE 10;

CREATE SEQUENCE MMMB_PK_DESCUENTO
    START WITH 1
    INCREMENT BY 1
    CACHE 10;

CREATE SEQUENCE MMMB_PK_HISTORIAL_PRECIOS
    START WITH 1
    INCREMENT BY 1
    CACHE 10;

------ No usados

/*
CREATE SEQUENCE MMMB_PK_MEDIO_PAGO
    START WITH 1
    INCREMENT BY 1
    CACHE 10;
CREATE SEQUENCE MMMB_PK_DETALLE_VENTA_PRODUCTO
    START WITH 1
    INCREMENT BY 1
    CACHE 10;

CREATE SEQUENCE MMMB_PK_DETALLE_BODEGA_PRODUCTO
    START WITH 1
    INCREMENT BY 1
    CACHE 10;

CREATE SEQUENCE MMMB_PK_DETALLE_PRODUCTO_PROVEEDOR
    START WITH 1
    INCREMENT BY 1
    CACHE 10;

CREATE SEQUENCE MMMB_PK_DETALLE_TURNO_HORARIO
    START WITH 1
    INCREMENT BY 1
    CACHE 10;
*/

/*
    CREATE TABLES
*/

CREATE TABLE MMMB_CARGO(
    COD_CARGO NUMBER,
    NOMBRE_CARGO VARCHAR2(50),
    CONSTRAINT PK_CARGO PRIMARY KEY (COD_CARGO)
);

CREATE TABLE MMMB_BODEGA(
    COD_BODEGA NUMBER,
    CONSTRAINT PK_BODEGA PRIMARY KEY (COD_BODEGA)
);

CREATE TABLE MMMB_SUCURSAL(
    COD_SUCURSAL NUMBER,
    COD_BODEGA NUMBER,
    NOMBRE_SUCURSAL VARCHAR2(50),
    TELEFONO_SUCURSAL VARCHAR2(15), -- Se ha cambiado a VARCHAR2 15
    CONSTRAINT PK_SUCURSAL PRIMARY KEY (COD_SUCURSAL),
    CONSTRAINT FK_SUCURSAL_BODEGA FOREIGN KEY (COD_BODEGA) REFERENCES MMMB_BODEGA(COD_BODEGA)
);

CREATE TABLE MMMB_EMPLEADO(
    RUT_EMPLEADO NUMBER,
    COD_SUCURSAL NUMBER,
    COD_CARGO NUMBER,
    NOMBRE_EMPLEADO VARCHAR2(40),
    APELLIDO1_EMPLEADO VARCHAR2(30),
    APELLIDO2_EMPLEADO VARCHAR2(30),
    TELEFONO_EMPLEADO VARCHAR2(15),     -- Se ha cambiado a VARCHAR2 15
    EMAIL_EMPLEADO VARCHAR2(50),
    USUARIO_EMPLEADO VARCHAR2(30),
    CONTRASEÑA_EMPLEADO VARCHAR2(64),   -- Se ha cambiado a 64, por supuesto hash de 64
    CONSTRAINT PK_EMPLEADO PRIMARY KEY (RUT_EMPLEADO),
    CONSTRAINT FK_EMPLEADO_CARGO FOREIGN KEY (COD_CARGO) REFERENCES MMMB_CARGO(COD_CARGO),
    CONSTRAINT FK_EMPLEADO_SUCURSAL FOREIGN KEY (COD_SUCURSAL) REFERENCES MMMB_SUCURSAL(COD_SUCURSAL)
);

CREATE TABLE MMMB_HORARIO(
    COD_HORARIO NUMBER,
    RUT_EMPLEADO NUMBER,
    FECHA_INICIO DATE,
    CONSTRAINT PK_HORARIO PRIMARY KEY (COD_HORARIO),
    CONSTRAINT FK_HORARIO_EMPLEADO FOREIGN KEY (RUT_EMPLEADO) REFERENCES MMMB_EMPLEADO(RUT_EMPLEADO)
);

CREATE TABLE MMMB_TURNO(
    COD_TURNO NUMBER,
    DIA DATE,
    HORA_ENTRADA TIMESTAMP,
    HORA_SALIDA TIMESTAMP,
    INICIO_COLACION TIMESTAMP,
    TERMINO_COLACION TIMESTAMP,
    CONSTRAINT PK_TURNO PRIMARY KEY (COD_TURNO)
);

CREATE TABLE MMMB_DETALLE_TURNO_HORARIO(
    COD_TURNO NUMBER,
    COD_HORARIO NUMBER,
    CONSTRAINT PK_DETALLE_TURNO_HORARIO PRIMARY KEY (COD_TURNO,COD_HORARIO),
    CONSTRAINT FK_DETALLE_TURNO_HORARIO_TURNO FOREIGN KEY (COD_TURNO) REFERENCES MMMB_TURNO(COD_TURNO),
    CONSTRAINT FK_DETALLE_TURNO_HORARIO_HORARIO FOREIGN KEY (COD_HORARIO) REFERENCES MMMB_HORARIO(COD_HORARIO)
);

CREATE TABLE MMMB_MARCA(
    COD_MARCA NUMBER,
    NOMBRE_MARCA VARCHAR2(30),
    CONSTRAINT PK_MARCA PRIMARY KEY (COD_MARCA)
);

CREATE TABLE MMMB_CATEGORIA(
    COD_CATEGORIA NUMBER,
    NOMBRE_CATEGORIA VARCHAR2(30),
    CONSTRAINT PK_CATEGORIA PRIMARY KEY (COD_CATEGORIA)
);

CREATE TABLE MMMB_PROVEEDOR(
    RUT_PROVEEDOR NUMBER,
    NOMBRE_PROVEEDOR VARCHAR2(30),
    CORREO_PROVEEDOR VARCHAR2(50),
    TELEFONO_PROVEEDOR VARCHAR2(15), -- Se ha cambiado a VARCHAR2
    CONSTRAINT PK_PROVEEDOR PRIMARY KEY (RUT_PROVEEDOR)
);

CREATE TABLE MMMB_PRODUCTO( -- Se ha quitado LOTE
    COD_PRODUCTO NUMBER,
    COD_MARCA NUMBER,
    COD_CATEGORIA NUMBER,
    NOMBRE_PRODUCTO VARCHAR2(50), -- Se ha cambiado de 30 a 50 (me dio error en pruebas con un nombre 'corto')
    PRECIO_COMPRA NUMBER,
    PRECIO_VENTA NUMBER,
    STOCK_PRODUCTO NUMBER,
    RUT_PROVEEDOR NUMBER, -- Se ha agregado como FK
    CONSTRAINT PK_PRODUCTO PRIMARY KEY (COD_PRODUCTO),
    CONSTRAINT FK_PRODUCTO_MARCA FOREIGN KEY (COD_MARCA) REFERENCES MMMB_MARCA(COD_MARCA),
    CONSTRAINT FK_PRODUCTO_CATEGORIA FOREIGN KEY (COD_CATEGORIA) REFERENCES MMMB_CATEGORIA(COD_CATEGORIA),
    CONSTRAINT FK_PRODUCTO_PROVEEDOR FOREIGN KEY (RUT_PROVEEDOR) REFERENCES MMMB_PROVEEDOR(RUT_PROVEEDOR)
);

CREATE TABLE MMMB_DETALLE_PRODUCTO_PROVEEDOR(
    COD_PRODUCTO NUMBER,
    RUT_PROVEEDOR NUMBER,
    CONSTRAINT PK_DETALLE_PRODUCTO_PROVEEDOR PRIMARY KEY (COD_PRODUCTO,RUT_PROVEEDOR),
    CONSTRAINT FK_DETALLE_PRODUCTO_PROVEEDOR_PRODUCTO FOREIGN KEY (COD_PRODUCTO) REFERENCES MMMB_PRODUCTO(COD_PRODUCTO),
    CONSTRAINT FK_DETALLE_PRODUCTO_PROVEEDOR_PROVEEDOR FOREIGN KEY (RUT_PROVEEDOR) REFERENCES MMMB_PROVEEDOR(RUT_PROVEEDOR)
);


CREATE TABLE MMMB_DETALLE_BODEGA_PRODUCTO(
    COD_BODEGA NUMBER,
    COD_PRODUCTO NUMBER,
    STOCK_BODEGA_PRODUCTO NUMBER,
    CONSTRAINT PK_DETALLE_BODEGA_PRODUCTO PRIMARY KEY (COD_BODEGA,COD_PRODUCTO),
    CONSTRAINT FK_DETALLE_BODEGA_PRODUCTO_BODEGA FOREIGN KEY (COD_BODEGA) REFERENCES MMMB_BODEGA(COD_BODEGA),
    CONSTRAINT FK_DETALLE_BODEGA_PRODUCTO_PRODUCTO FOREIGN KEY (COD_PRODUCTO) REFERENCES MMMB_PRODUCTO(COD_PRODUCTO)
);

CREATE TABLE MMMB_CAJA(
    COD_CAJA NUMBER,
    COD_SUCURSAL NUMBER,
    CONSTRAINT PK_CAJA PRIMARY KEY (COD_CAJA),
    CONSTRAINT FK_CAJA_SUCURSAL FOREIGN KEY (COD_SUCURSAL) REFERENCES MMMB_SUCURSAL(COD_SUCURSAL)
);

CREATE TABLE MMMB_DETALLE_CUADRATURA(
    COD_DETALLE_CUADRATURA NUMBER,
    COD_CAJA NUMBER,
    SALDO_INICIAL NUMBER,
    SALDO_FINAL NUMBER,
    FECHA DATE,
    CONSTRAINT PK_DETALLE_CUADRATURA PRIMARY KEY (COD_DETALLE_CUADRATURA),
    CONSTRAINT FK_DETALLE_CUADRATURA_CAJA FOREIGN KEY (COD_CAJA) REFERENCES MMMB_CAJA(COD_CAJA)
);

CREATE TABLE MMMB_CLIENTE(
    RUT_CLIENTE NUMBER,
    NOMBRE_CLIENTE VARCHAR2(40), -- Se ha corregido a NOMBRE_CLIENTE
    APELLIDO1_CLIENTE VARCHAR2(30),
    APELLIDO2_CLIENTE VARCHAR2(30),
    CORREO_CLIENTE VARCHAR2(50),
    CONSTRAINT PK_CLIENTE PRIMARY KEY (RUT_CLIENTE)
);

CREATE TABLE MMMB_MEDIO_PAGO(
    COD_PAGO NUMBER,
    NOMBRE_MEDIO_PAGO VARCHAR2(25),
    CONSTRAINT PK_MEDIO_PAGO PRIMARY KEY (COD_PAGO)
);

CREATE TABLE MMMB_VENTA(
    COD_VENTA NUMBER,
    COD_CAJA NUMBER,
    RUT_CLIENTE NUMBER,
    RUT_EMPLEADO NUMBER,
    COD_PAGO NUMBER,
    FECHA_VENTA DATE,
    TOTAL_VENTA NUMBER,
    DESCUENTO_VENTA NUMBER,
    CONSTRAINT PK_VENTA PRIMARY KEY (COD_VENTA),
    CONSTRAINT FK_VENTA_CAJA FOREIGN KEY (COD_CAJA) REFERENCES MMMB_CAJA(COD_CAJA),
    CONSTRAINT FK_VENTA_CLIENTE FOREIGN KEY (RUT_CLIENTE) REFERENCES MMMB_CLIENTE(RUT_CLIENTE),
    CONSTRAINT FK_VENTA_EMPLEADO FOREIGN KEY (RUT_EMPLEADO) REFERENCES MMMB_EMPLEADO(RUT_EMPLEADO),
    CONSTRAINT FK_VENTA_MEDIO_PAGO FOREIGN KEY (COD_PAGO) REFERENCES MMMB_MEDIO_PAGO(COD_PAGO)
);

CREATE TABLE MMMB_DETALLE_VENTA_PRODUCTO(
    COD_VENTA NUMBER,
    COD_PRODUCTO NUMBER,
    CANTIDAD NUMBER,
    CONSTRAINT PK_DETALLE_VENTA_PRODUCTO PRIMARY KEY (COD_VENTA,COD_PRODUCTO),
    CONSTRAINT FK_DETALLE_VENTA_PRODUCTO_VENTA FOREIGN KEY (COD_VENTA) REFERENCES MMMB_VENTA(COD_VENTA),
    CONSTRAINT FK_DETALLE_VENTA_PRODUCTO_PRODUCTO FOREIGN KEY (COD_PRODUCTO) REFERENCES MMMB_PRODUCTO(COD_PRODUCTO)
);

CREATE TABLE MMMB_DESCUENTO(
    COD_DESCUENTO NUMBER,
    COD_PRODUCTO NUMBER,
    PORCENTAJE_DESCUENTO NUMBER,
    VALIDO_DESDE DATE,
    VALIDO_HASTA DATE,
    CONSTRAINT PK_DESCUENTO PRIMARY KEY (COD_DESCUENTO),
    CONSTRAINT FK_DESCUENTO_PRODUCTO FOREIGN KEY (COD_PRODUCTO) REFERENCES MMMB_PRODUCTO(COD_PRODUCTO)
);

CREATE TABLE MMMB_HISTORIAL_PRECIOS( -- Se ha agregado tabla
    COD_HISTORIAL_PRECIO NUMBER,
    COD_PRODUCTO NUMBER,
    TIPO_PRECIO VARCHAR2(15), -- Se ha cambiado a 15, de 10.
    VALOR_ANTERIOR NUMBER,
    VALOR_NUEVO NUMBER,
    FECHA DATE,
    CONSTRAINT PK_HISTORIAL_PRECIOS PRIMARY KEY(COD_HISTORIAL_PRECIO),
    CONSTRAINT FK_HISTORIAL_PRECIOS_PRODUCTO FOREIGN KEY(COD_PRODUCTO) REFERENCES MMMB_PRODUCTO(COD_PRODUCTO)
);

/*
    FUNCTIONS
*/

-- Existe tal cargo? Retorna el número.
CREATE OR REPLACE FUNCTION MMMB_EXISTE_CARGO(COD_CARGO_P NUMBER) RETURN NUMBER
IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM MMMB_CARGO
    WHERE COD_CARGO = COD_CARGO_P;

    RETURN v_count;
END MMMB_EXISTE_CARGO;
/

-- Existe tal sucursal?
CREATE OR REPLACE FUNCTION MMMB_EXISTE_SUCURSAL(COD_SUCURSAL_P NUMBER) RETURN NUMBER
IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM MMMB_SUCURSAL
    WHERE COD_SUCURSAL = COD_SUCURSAL_P;

    RETURN v_count;
END MMMB_EXISTE_SUCURSAL;
/

-- Existe tal marca? 
CREATE OR REPLACE FUNCTION MMMB_EXISTE_MARCA(COD_MARCA_P NUMBER) RETURN NUMBER
IS
    v_marca_exists NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_marca_exists
    FROM MMMB_MARCA
    WHERE COD_MARCA = COD_MARCA_P;

    RETURN v_marca_exists;
EXCEPTION
    WHEN OTHERS THEN
        RETURN -1;
END MMMB_EXISTE_MARCA;
/

-- Existe tal categoría?
CREATE OR REPLACE FUNCTION MMMB_EXISTE_CATEGORIA(COD_CATEGORIA_P NUMBER)
RETURN NUMBER
IS
    v_categoria_exists NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_categoria_exists
    FROM MMMB_CATEGORIA
    WHERE COD_CATEGORIA = COD_CATEGORIA_P;

    RETURN v_categoria_exists;
EXCEPTION
    WHEN OTHERS THEN
        RETURN -1;
END MMMB_EXISTE_CATEGORIA;
/

-- Existe tal proveedor?
CREATE OR REPLACE FUNCTION MMMB_EXISTE_PROVEEDOR(RUT_PROVEEDOR_P NUMBER)
RETURN NUMBER
IS
    v_proveedor_exists NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_proveedor_exists
    FROM MMMB_PROVEEDOR
    WHERE RUT_PROVEEDOR = RUT_PROVEEDOR_P;

    RETURN v_proveedor_exists;
EXCEPTION
    WHEN OTHERS THEN
        RETURN -1;
END MMMB_EXISTE_PROVEEDOR;
/

-- Existe empleado?
CREATE OR REPLACE FUNCTION MMMB_EXISTE_EMPLEADO(RUT_EMPLEADO_P NUMBER)
RETURN NUMBER
IS
    v_empleado_exists NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_empleado_exists
    FROM MMMB_EMPLEADO
    WHERE RUT_EMPLEADO = RUT_EMPLEADO_P;

    RETURN v_empleado_exists;
EXCEPTION
    WHEN OTHERS THEN
        RETURN -1;
END MMMB_EXISTE_EMPLEADO;
/

-- Existe turno?
CREATE OR REPLACE FUNCTION MMMB_EXISTE_TURNO(COD_TURNO_P NUMBER)
RETURN NUMBER
IS
    v_turno_exists NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_turno_exists
    FROM MMMB_TURNO
    WHERE COD_TURNO = COD_TURNO_P;

    RETURN v_turno_exists;
EXCEPTION
    WHEN OTHERS THEN
        RETURN -1;
END MMMB_EXISTE_TURNO;
/

-- Existe caja?
CREATE OR REPLACE FUNCTION MMMB_EXISTE_CAJA(COD_CAJA_P NUMBER) RETURN NUMBER
IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM MMMB_CAJA
    WHERE COD_CAJA = COD_CAJA_P;

    RETURN v_count;
END MMMB_EXISTE_CAJA;
/

-- Existe cliente?
CREATE OR REPLACE FUNCTION MMMB_EXISTE_CLIENTE(RUT_CLIENTE_P NUMBER) RETURN NUMBER
IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM MMMB_CLIENTE
    WHERE RUT_CLIENTE = RUT_CLIENTE_P;

    RETURN v_count;
END MMMB_EXISTE_CLIENTE;
/

-- Existe producto?
CREATE OR REPLACE FUNCTION MMMB_EXISTE_PRODUCTO(COD_PRODUCTO_P NUMBER) RETURN NUMBER
IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM MMMB_PRODUCTO
    WHERE COD_PRODUCTO = COD_PRODUCTO_P;

    RETURN v_count;
END MMMB_EXISTE_PRODUCTO;
/

/*
    PROCEDURES
*/

/*
    Procedimientos de almacenado integral.
    
    OPCION;
        R para insert
        U para update
        D para delete

    -	Restricciones 
        	En el caso de insertar datos, se deben insertar todos.
        	En el caso de la actualización, se actualizarán todos los valores (menos el código).
        	En el caso del borrado, se realizará a través del código.
        
    -   CONFIRM_OUTPUT
                1: Todo OK
               -1: Error general
        	    -2: Índice duplicado (DUP_VAL_ON_INDEX)
            -2292: Error de integridad referencial.
*/

-- Empleado

CREATE OR REPLACE PROCEDURE MMMB_PROC_EMPLEADO(
    OPCION VARCHAR2,
    RUT_EMPLEADO_P NUMBER,
    COD_SUCURSAL_P NUMBER DEFAULT NULL,
    COD_CARGO_P NUMBER DEFAULT NULL,
    NOMBRE_EMPLEADO_P VARCHAR2 DEFAULT NULL,
    APELLIDO1_EMPLEADO_P VARCHAR2 DEFAULT NULL,
    APELLIDO2_EMPLEADO_P VARCHAR2 DEFAULT NULL,
    TELEFONO_EMPLEADO_P VARCHAR2 DEFAULT NULL,
    EMAIL_EMPLEADO_P VARCHAR2 DEFAULT NULL,
    USUARIO_EMPLEADO_P VARCHAR2 DEFAULT NULL,
    CONTRASEÑA_EMPLEADO_P IN VARCHAR2 DEFAULT NULL,
    CONFIRM_OUTPUT OUT NUMBER 
)
IS
    v_cargo_exists NUMBER;
    v_sucursal_exists NUMBER;

BEGIN
    LOCK TABLE MMMB_EMPLEADO IN ROW EXCLUSIVE MODE;
    
    CASE OPCION
        WHEN 'I' THEN
            IF COALESCE(
                    RUT_EMPLEADO_P,
                    COD_SUCURSAL_P,
                    COD_CARGO_P,
                    NOMBRE_EMPLEADO_P,
                    APELLIDO1_EMPLEADO_P,
                    APELLIDO2_EMPLEADO_P,
                    TELEFONO_EMPLEADO_P,
                    EMAIL_EMPLEADO_P,
                    USUARIO_EMPLEADO_P,
                    CONTRASEÑA_EMPLEADO_P) IS NULL THEN
                DBMS_OUTPUT.PUT_LINE('Error: Alguno de los parámetros contiene valores nulos.');
                CONFIRM_OUTPUT := -1;
            ELSE
                -- Verificar si el código de cargo y la sucursal existen utilizando las funciones
                v_cargo_exists := MMMB_EXISTE_CARGO(COD_CARGO_P);
                v_sucursal_exists := MMMB_EXISTE_SUCURSAL(COD_SUCURSAL_P);

                IF v_cargo_exists = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('Error: El código de cargo proporcionado no existe.');
                    CONFIRM_OUTPUT := -1;
                ELSIF v_sucursal_exists = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('Error: El código de sucursal proporcionado no existe.');
                    CONFIRM_OUTPUT := -1;
                ELSE
                    INSERT INTO MMMB_EMPLEADO 
                        VALUES(
                            RUT_EMPLEADO_P,
                            COD_SUCURSAL_P,
                            COD_CARGO_P,
                            NOMBRE_EMPLEADO_P,
                            APELLIDO1_EMPLEADO_P,
                            APELLIDO2_EMPLEADO_P,
                            TELEFONO_EMPLEADO_P,
                            EMAIL_EMPLEADO_P,
                            USUARIO_EMPLEADO_P,
                            CONTRASEÑA_EMPLEADO_P
                        );
                    CONFIRM_OUTPUT := 1;
                END IF;
            END IF;
        WHEN 'U' THEN
            -- Verificar si el código de cargo y la sucursal existen utilizando las funciones
            v_cargo_exists := MMMB_EXISTE_CARGO(COD_CARGO_P);
            v_sucursal_exists := MMMB_EXISTE_SUCURSAL(COD_SUCURSAL_P);

            IF v_cargo_exists = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Error: El código de cargo proporcionado no existe.');
                CONFIRM_OUTPUT := -1;
            ELSIF v_sucursal_exists = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Error: El código de sucursal proporcionado no existe.');
                CONFIRM_OUTPUT := -1;
            ELSE
                UPDATE MMMB_EMPLEADO 
                    SET COD_SUCURSAL = COD_SUCURSAL_P,
                        COD_CARGO = COD_CARGO_P,
                        NOMBRE_EMPLEADO = NOMBRE_EMPLEADO_P,
                        APELLIDO1_EMPLEADO = APELLIDO1_EMPLEADO_P,
                        APELLIDO2_EMPLEADO = APELLIDO2_EMPLEADO_P,
                        TELEFONO_EMPLEADO = TELEFONO_EMPLEADO_P,
                        EMAIL_EMPLEADO = EMAIL_EMPLEADO_P,
                        USUARIO_EMPLEADO = USUARIO_EMPLEADO_P,
                        CONTRASEÑA_EMPLEADO = CONTRASEÑA_EMPLEADO_P
                    WHERE (RUT_EMPLEADO = RUT_EMPLEADO_P);
                CONFIRM_OUTPUT := 1;
            END IF;
        WHEN 'D' THEN
            DELETE FROM MMMB_EMPLEADO WHERE (RUT_EMPLEADO = RUT_EMPLEADO_P);
            CONFIRM_OUTPUT := 1;
        ELSE
            CONFIRM_OUTPUT := -1;
    END CASE;

    COMMIT;

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        CONFIRM_OUTPUT := -2; -- Índice duplicado (DUP_VAL_ON_INDEX)
    WHEN OTHERS THEN
        IF SQLCODE = -2292 THEN
            -- Si es un error de violación de integridad referencial (ORA-02292)
            DBMS_OUTPUT.PUT_LINE('Error de integridad referencial (ORA-02292) detectado. Violación de la restricción.');
            CONFIRM_OUTPUT := SQLCODE;
        ELSE
            -- Otro manejo de errores
            DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error intentando realizar el procedimiento en la tabla MMMB_MARCA.');
            DBMS_OUTPUT.PUT_LINE('Error no manejado: ' || SQLERRM);
            CONFIRM_OUTPUT := -1;
        END IF;
        ROLLBACK;
END;
/

-- Marca

CREATE OR REPLACE PROCEDURE MMMB_PROC_MARCA(
    OPCION VARCHAR2,
    COD_MARCA_P NUMBER,
    NOMBRE_MARCA_P VARCHAR2 DEFAULT NULL,
    CONFIRM_OUTPUT OUT NUMBER 
)
IS
BEGIN
    LOCK TABLE MMMB_MARCA IN ROW EXCLUSIVE MODE;

    CASE OPCION
        WHEN 'I' THEN
            IF NOMBRE_MARCA_P IS NULL THEN
                DBMS_OUTPUT.PUT_LINE('Error: Alguno de los parámetros contiene valores nulos.');
                CONFIRM_OUTPUT := -1;
            ELSE
                INSERT INTO MMMB_MARCA 
                    VALUES(MMMB_PK_MARCA.NEXTVAL, NOMBRE_MARCA_P);
                CONFIRM_OUTPUT := 1;
            END IF;
        WHEN 'U' THEN
            UPDATE MMMB_MARCA 
                SET NOMBRE_MARCA = NOMBRE_MARCA_P
                WHERE (COD_MARCA = COD_MARCA_P);
            CONFIRM_OUTPUT := 1;
        WHEN 'D' THEN
            DELETE FROM MMMB_MARCA WHERE (COD_MARCA = COD_MARCA_P);
            CONFIRM_OUTPUT := 1;
        ELSE
            CONFIRM_OUTPUT := -1;
    END CASE;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2292 THEN
            -- Si es un error de violación de integridad referencial (ORA-02292)
            DBMS_OUTPUT.PUT_LINE('Error de integridad referencial (ORA-02292) detectado. Violación de la restricción.');
            CONFIRM_OUTPUT := SQLCODE;
        ELSE
            -- Otro manejo de errores
            DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error intentando realizar el procedimiento en la tabla MMMB_MARCA.');
            DBMS_OUTPUT.PUT_LINE('Error no manejado: ' || SQLERRM);
            CONFIRM_OUTPUT := -1;
        END IF;
        ROLLBACK;
END;
/

-- Categoría

CREATE OR REPLACE PROCEDURE MMMB_PROC_CATEGORIA(
    OPCION VARCHAR2,
    COD_CATEGORIA_P NUMBER,
    NOMBRE_CATEGORIA_P VARCHAR2 DEFAULT NULL,
    CONFIRM_OUTPUT OUT NUMBER 
)
IS
BEGIN
    LOCK TABLE MMMB_CATEGORIA IN ROW EXCLUSIVE MODE;

    CASE OPCION
        WHEN 'I' THEN
            IF NOMBRE_CATEGORIA_P IS NULL THEN
                DBMS_OUTPUT.PUT_LINE('Error: Alguno de los parámetros contiene valores nulos.');
                CONFIRM_OUTPUT := -1;
            ELSE
                INSERT INTO MMMB_CATEGORIA 
                    VALUES(MMMB_PK_CATEGORIA.NEXTVAL, NOMBRE_CATEGORIA_P);
                CONFIRM_OUTPUT := 1;
            END IF;
        WHEN 'U' THEN
            UPDATE MMMB_CATEGORIA 
                SET NOMBRE_CATEGORIA = NOMBRE_CATEGORIA_P
                WHERE (COD_CATEGORIA = COD_CATEGORIA_P);
            CONFIRM_OUTPUT := 1;
        WHEN 'D' THEN
            DELETE FROM MMMB_CATEGORIA WHERE (COD_CATEGORIA = COD_CATEGORIA_P);
            CONFIRM_OUTPUT := 1;
        ELSE
            CONFIRM_OUTPUT := -1;
    END CASE;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2292 THEN
            -- Si es un error de violación de integridad referencial (ORA-02292)
            DBMS_OUTPUT.PUT_LINE('Error de integridad referencial (ORA-02292) detectado. Violación de la restricción.');
            CONFIRM_OUTPUT := SQLCODE;
        ELSE
            -- Otro manejo de errores
            DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error intentando realizar el procedimiento en la tabla MMMB_MARCA.');
            DBMS_OUTPUT.PUT_LINE('Error no manejado: ' || SQLERRM);
            CONFIRM_OUTPUT := -1;
        END IF;
        ROLLBACK;
END;
/

-- Proveedor

CREATE OR REPLACE PROCEDURE MMMB_PROC_PROVEEDOR(
    OPCION VARCHAR2,
    RUT_PROVEEDOR_P NUMBER,
    NOMBRE_PROVEEDOR_P VARCHAR2 DEFAULT NULL,
    CORREO_PROVEEDOR_P VARCHAR2 DEFAULT NULL,
    TELEFONO_PROVEEDOR_P VARCHAR2 DEFAULT NULL,
    CONFIRM_OUTPUT OUT NUMBER 
)
IS
BEGIN
    LOCK TABLE MMMB_PROVEEDOR IN ROW EXCLUSIVE MODE;

    CASE OPCION
        WHEN 'I' THEN
            IF COALESCE(NOMBRE_PROVEEDOR_P, CORREO_PROVEEDOR_P, TELEFONO_PROVEEDOR_P) IS NULL THEN
                DBMS_OUTPUT.PUT_LINE('Error: Alguno de los parámetros contiene valores nulos.');
                CONFIRM_OUTPUT := -1;
            ELSE
                INSERT INTO MMMB_PROVEEDOR 
                    VALUES(MMMB_PK_PROVEEDOR.NEXTVAL, NOMBRE_PROVEEDOR_P, CORREO_PROVEEDOR_P, TELEFONO_PROVEEDOR_P);
                CONFIRM_OUTPUT := 1;
            END IF;
        WHEN 'U' THEN
            UPDATE MMMB_PROVEEDOR 
                SET NOMBRE_PROVEEDOR = NOMBRE_PROVEEDOR_P,
                    CORREO_PROVEEDOR = CORREO_PROVEEDOR_P,
                    TELEFONO_PROVEEDOR = TELEFONO_PROVEEDOR_P
                WHERE (RUT_PROVEEDOR = RUT_PROVEEDOR_P);
            CONFIRM_OUTPUT := 1;
        WHEN 'D' THEN
            DELETE FROM MMMB_PROVEEDOR WHERE (RUT_PROVEEDOR = RUT_PROVEEDOR_P);
            CONFIRM_OUTPUT := 1;
        ELSE
            CONFIRM_OUTPUT := -1;
    END CASE;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2292 THEN
            -- Si es un error de violación de integridad referencial (ORA-02292)
            DBMS_OUTPUT.PUT_LINE('Error de integridad referencial (ORA-02292) detectado. Violación de la restricción.');
            CONFIRM_OUTPUT := SQLCODE;
        ELSE
            -- Otro manejo de errores
            DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error intentando realizar el procedimiento en la tabla MMMB_MARCA.');
            DBMS_OUTPUT.PUT_LINE('Error no manejado: ' || SQLERRM);
            CONFIRM_OUTPUT := -1;
        END IF;
        ROLLBACK;
END;
/

-- Producto

    CREATE OR REPLACE PROCEDURE MMMB_PROC_PRODUCTO(
        OPCION VARCHAR2,
        COD_PRODUCTO_P NUMBER,
        COD_MARCA_P NUMBER DEFAULT NULL,
        COD_CATEGORIA_P NUMBER DEFAULT NULL,
        NOMBRE_PRODUCTO_P VARCHAR2 DEFAULT NULL,
        PRECIO_COMPRA_P NUMBER DEFAULT NULL,
        PRECIO_VENTA_P NUMBER DEFAULT NULL,
        STOCK_PRODUCTO_P NUMBER DEFAULT NULL,
        RUT_PROVEEDOR_P NUMBER DEFAULT NULL,
        CONFIRM_OUTPUT OUT NUMBER 
    )
IS
BEGIN
    LOCK TABLE MMMB_PRODUCTO IN ROW EXCLUSIVE MODE;

    CASE OPCION
        WHEN 'I' THEN
            IF COALESCE(
                COD_MARCA_P, COD_CATEGORIA_P, NOMBRE_PRODUCTO_P, PRECIO_COMPRA_P, PRECIO_VENTA_P, STOCK_PRODUCTO_P, RUT_PROVEEDOR_P
            ) IS NULL THEN
                DBMS_OUTPUT.PUT_LINE('Error: Alguno de los parámetros contiene valores nulos.');
                CONFIRM_OUTPUT := -1;
            ELSE
                IF MMMB_EXISTE_MARCA(COD_MARCA_P) = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('Error: La marca no existe.');
                    CONFIRM_OUTPUT := -1;
                ELSIF MMMB_EXISTE_CATEGORIA(COD_CATEGORIA_P) = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('Error: La categoría no existe.');
                    CONFIRM_OUTPUT := -1;
                ELSIF MMMB_EXISTE_PROVEEDOR(RUT_PROVEEDOR_P) = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('Error: El proveedor no existe.');
                    CONFIRM_OUTPUT := -1;
                ELSE
                    INSERT INTO MMMB_PRODUCTO 
                        VALUES(
                            MMMB_PK_PRODUCTO.NEXTVAL, COD_MARCA_P, COD_CATEGORIA_P, NOMBRE_PRODUCTO_P,
                            PRECIO_COMPRA_P, PRECIO_VENTA_P, STOCK_PRODUCTO_P, RUT_PROVEEDOR_P
                        );
                    CONFIRM_OUTPUT := 1;
                END IF;
            END IF;
        WHEN 'U' THEN
            IF MMMB_EXISTE_MARCA(COD_MARCA_P) = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Error: La marca no existe.');
                CONFIRM_OUTPUT := -1;
            ELSIF MMMB_EXISTE_CATEGORIA(COD_CATEGORIA_P) = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Error: La categoría no existe.');
                CONFIRM_OUTPUT := -1;
            ELSIF MMMB_EXISTE_PROVEEDOR(RUT_PROVEEDOR_P) = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Error: El proveedor no existe.');
                CONFIRM_OUTPUT := -1;
            ELSE
                UPDATE MMMB_PRODUCTO 
                    SET COD_MARCA = COD_MARCA_P,
                        COD_CATEGORIA = COD_CATEGORIA_P,
                        NOMBRE_PRODUCTO = NOMBRE_PRODUCTO_P,
                        PRECIO_COMPRA = PRECIO_COMPRA_P,
                        PRECIO_VENTA = PRECIO_VENTA_P,
                        STOCK_PRODUCTO = STOCK_PRODUCTO_P,
                        RUT_PROVEEDOR = RUT_PROVEEDOR_P
                    WHERE (COD_PRODUCTO = COD_PRODUCTO_P);
                CONFIRM_OUTPUT := 1;
            END IF;
        WHEN 'D' THEN
            DELETE FROM MMMB_PRODUCTO WHERE (COD_PRODUCTO = COD_PRODUCTO_P);
            CONFIRM_OUTPUT := 1;
        ELSE
            CONFIRM_OUTPUT := -1;
    END CASE;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2292 THEN
            -- Si es un error de violación de integridad referencial (ORA-02292)
            DBMS_OUTPUT.PUT_LINE('Error de integridad referencial (ORA-02292) detectado. Violación de la restricción.');
            CONFIRM_OUTPUT := SQLCODE;
        ELSE
            -- Otro manejo de errores
            DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error intentando realizar el procedimiento en la tabla MMMB_MARCA.');
            DBMS_OUTPUT.PUT_LINE('Error no manejado: ' || SQLERRM);
            CONFIRM_OUTPUT := -1;
        END IF;
        ROLLBACK;
END;
/

-- Horario

CREATE OR REPLACE PROCEDURE MMMB_PROC_HORARIO(
    OPCION VARCHAR2,
    COD_HORARIO_P NUMBER,
    RUT_EMPLEADO_P NUMBER DEFAULT NULL,
    FECHA_INICIO_P DATE DEFAULT NULL,
    CONFIRM_OUTPUT OUT NUMBER 
)
IS
BEGIN
    LOCK TABLE MMMB_HORARIO IN ROW EXCLUSIVE MODE;

    CASE OPCION
        WHEN 'I' THEN
            IF (RUT_EMPLEADO_P IS NULL OR FECHA_INICIO_P IS NULL) THEN
                DBMS_OUTPUT.PUT_LINE('Error: Alguno de los parámetros contiene valores nulos.');
                CONFIRM_OUTPUT := -1;
            ELSE
                IF MMMB_EXISTE_EMPLEADO(RUT_EMPLEADO_P) = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('Error: El empleado no existe.');
                    CONFIRM_OUTPUT := -1;
                ELSE
                    INSERT INTO MMMB_HORARIO 
                        VALUES(MMMB_PK_HORARIO.NEXTVAL, RUT_EMPLEADO_P, FECHA_INICIO_P);
                    CONFIRM_OUTPUT := 1;      
                END IF;              
            END IF;
        WHEN 'U' THEN
            IF MMMB_EXISTE_EMPLEADO(RUT_EMPLEADO_P) = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Error: El empleado no existe.');
                CONFIRM_OUTPUT := -1;
            ELSE
                UPDATE MMMB_HORARIO 
                    SET RUT_EMPLEADO = RUT_EMPLEADO_P,
                        FECHA_INICIO = FECHA_INICIO_P
                    WHERE (COD_HORARIO = COD_HORARIO_P);
                CONFIRM_OUTPUT := 1;
            END IF;
        WHEN 'D' THEN
            DELETE FROM MMMB_HORARIO WHERE (COD_HORARIO = COD_HORARIO_P);
            CONFIRM_OUTPUT := 1;
        ELSE
            CONFIRM_OUTPUT := -1;
    END CASE;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2292 THEN
            -- Si es un error de violación de integridad referencial (ORA-02292)
            DBMS_OUTPUT.PUT_LINE('Error de integridad referencial (ORA-02292) detectado. Violación de la restricción.');
            CONFIRM_OUTPUT := SQLCODE;
        ELSE
            -- Otro manejo de errores
            DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error intentando realizar el procedimiento en la tabla MMMB_MARCA.');
            DBMS_OUTPUT.PUT_LINE('Error no manejado: ' || SQLERRM);
            CONFIRM_OUTPUT := -1;
        END IF;
        ROLLBACK;
END;
/

-- Turno

CREATE OR REPLACE PROCEDURE MMMB_PROC_TURNO(
    OPCION VARCHAR2,
    COD_TURNO_P NUMBER,
    DIA_P DATE DEFAULT NULL,
    HORA_ENTRADA_P TIMESTAMP DEFAULT NULL,
    HORA_SALIDA_P TIMESTAMP DEFAULT NULL,
    INICIO_COLACION_P TIMESTAMP DEFAULT NULL,
    TERMINO_COLACION_P TIMESTAMP DEFAULT NULL,
    CONFIRM_OUTPUT OUT NUMBER 
)
IS
BEGIN
    LOCK TABLE MMMB_TURNO IN ROW EXCLUSIVE MODE;

    CASE OPCION
        WHEN 'I' THEN
            IF DIA_P IS NULL OR COALESCE(HORA_ENTRADA_P, HORA_SALIDA_P, INICIO_COLACION_P, TERMINO_COLACION_P) IS NULL THEN
                DBMS_OUTPUT.PUT_LINE('Error: Alguno de los parámetros contiene valores nulos.');
                CONFIRM_OUTPUT := -1;
            ELSE
                INSERT INTO MMMB_TURNO 
                    VALUES(
                        MMMB_PK_TURNO.NEXTVAL, DIA_P, HORA_ENTRADA_P, HORA_SALIDA_P,
                        INICIO_COLACION_P, TERMINO_COLACION_P
                    );
                CONFIRM_OUTPUT := 1;
            END IF;
        WHEN 'U' THEN
            UPDATE MMMB_TURNO 
                SET DIA = DIA_P,
                    HORA_ENTRADA = HORA_ENTRADA_P,
                    HORA_SALIDA = HORA_SALIDA_P,
                    INICIO_COLACION = INICIO_COLACION_P,
                    TERMINO_COLACION = TERMINO_COLACION_P
                WHERE (COD_TURNO = COD_TURNO_P);
            CONFIRM_OUTPUT := 1;
        WHEN 'D' THEN
            DELETE FROM MMMB_TURNO WHERE (COD_TURNO = COD_TURNO_P);
            CONFIRM_OUTPUT := 1;
        ELSE
            CONFIRM_OUTPUT := -1;
    END CASE;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2292 THEN
            -- Si es un error de violación de integridad referencial (ORA-02292)
            DBMS_OUTPUT.PUT_LINE('Error de integridad referencial (ORA-02292) detectado. Violación de la restricción.');
            CONFIRM_OUTPUT := SQLCODE;
        ELSE
            -- Otro manejo de errores
            DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error intentando realizar el procedimiento en la tabla MMMB_MARCA.');
            DBMS_OUTPUT.PUT_LINE('Error no manejado: ' || SQLERRM);
            CONFIRM_OUTPUT := -1;
        END IF;
        ROLLBACK;
END;
/

-- Caja

CREATE OR REPLACE PROCEDURE MMMB_PROC_CAJA(
    OPCION VARCHAR2,
    COD_CAJA_P NUMBER,
    COD_SUCURSAL_P NUMBER DEFAULT NULL,
    CONFIRM_OUTPUT OUT NUMBER 
)
IS
BEGIN
    LOCK TABLE MMMB_CAJA IN ROW EXCLUSIVE MODE;

    CASE OPCION
        WHEN 'I' THEN
            IF (COD_SUCURSAL_P IS NULL) THEN
                DBMS_OUTPUT.PUT_LINE('Error: El código de sucursal no puede ser nulo.');
                CONFIRM_OUTPUT := -1;
            ELSE
                IF MMMB_EXISTE_SUCURSAL(COD_SUCURSAL_P) = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('Error: La sucursal no existe.');
                    CONFIRM_OUTPUT := -1;
                ELSE
                    INSERT INTO MMMB_CAJA 
                        VALUES(MMMB_PK_CAJA.NEXTVAL, COD_SUCURSAL_P);
                    CONFIRM_OUTPUT := 1;
                END IF;
            END IF;
        WHEN 'U' THEN
            IF MMMB_EXISTE_SUCURSAL(COD_SUCURSAL_P) = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Error: La sucursal no existe.');
                CONFIRM_OUTPUT := -1;
            ELSE
                UPDATE MMMB_CAJA 
                    SET COD_SUCURSAL = COD_SUCURSAL_P
                    WHERE (COD_CAJA = COD_CAJA_P);
                CONFIRM_OUTPUT := 1;
            END IF;
        WHEN 'D' THEN
            DELETE FROM MMMB_CAJA WHERE (COD_CAJA = COD_CAJA_P);
            CONFIRM_OUTPUT := 1;
        ELSE
            CONFIRM_OUTPUT := -1;
    END CASE;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2292 THEN
            -- Si es un error de violación de integridad referencial (ORA-02292)
            DBMS_OUTPUT.PUT_LINE('Error de integridad referencial (ORA-02292) detectado. Violación de la restricción.');
            CONFIRM_OUTPUT := SQLCODE;
        ELSE
            -- Otro manejo de errores
            DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error intentando realizar el procedimiento en la tabla MMMB_MARCA.');
            DBMS_OUTPUT.PUT_LINE('Error no manejado: ' || SQLERRM);
            CONFIRM_OUTPUT := -1;
        END IF;
        ROLLBACK;
END;
/

-- Detalle cuadratura

CREATE OR REPLACE PROCEDURE MMMB_PROC_DETALLE_CUADRATURA(
    OPCION VARCHAR2,
    COD_DETALLE_CUADRATURA_P NUMBER,
    COD_CAJA_P NUMBER DEFAULT NULL,
    SALDO_INICIAL_P NUMBER DEFAULT NULL,
    SALDO_FINAL_P NUMBER DEFAULT NULL,
    FECHA_P DATE DEFAULT NULL,
    CONFIRM_OUTPUT OUT NUMBER 
)
IS
BEGIN
    LOCK TABLE MMMB_DETALLE_CUADRATURA IN ROW EXCLUSIVE MODE;

    CASE OPCION
        WHEN 'I' THEN
            IF (COD_CAJA_P IS NULL OR SALDO_INICIAL_P IS NULL OR SALDO_FINAL_P IS NULL OR FECHA_P IS NULL) THEN
                DBMS_OUTPUT.PUT_LINE('Error: Alguno de los parámetros contiene valores nulos.');
                CONFIRM_OUTPUT := -1;
            ELSE
                IF MMMB_EXISTE_CAJA(COD_CAJA_P) = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('Error: La caja no existe.');
                    CONFIRM_OUTPUT := -1;
                ELSE
                    INSERT INTO MMMB_DETALLE_CUADRATURA 
                        VALUES(MMMB_PK_DETALLE_CUADRATURA.NEXTVAL, COD_CAJA_P, SALDO_INICIAL_P, SALDO_FINAL_P, FECHA_P);
                    CONFIRM_OUTPUT := 1;
                END IF;
            END IF;
        WHEN 'U' THEN
            IF MMMB_EXISTE_CAJA(COD_CAJA_P) = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Error: La caja no existe.');
                CONFIRM_OUTPUT := -1;
            ELSE
                UPDATE MMMB_DETALLE_CUADRATURA 
                    SET COD_CAJA = COD_CAJA_P,
                        SALDO_INICIAL = SALDO_INICIAL_P,
                        SALDO_FINAL = SALDO_FINAL_P,
                        FECHA = FECHA_P
                    WHERE (COD_DETALLE_CUADRATURA = COD_DETALLE_CUADRATURA_P);
                CONFIRM_OUTPUT := 1;
            END IF;
        WHEN 'D' THEN
            DELETE FROM MMMB_DETALLE_CUADRATURA WHERE (COD_DETALLE_CUADRATURA = COD_DETALLE_CUADRATURA_P);
            CONFIRM_OUTPUT := 1;
        ELSE
            CONFIRM_OUTPUT := -1;
    END CASE;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2292 THEN
            -- Si es un error de violación de integridad referencial (ORA-02292)
            DBMS_OUTPUT.PUT_LINE('Error de integridad referencial (ORA-02292) detectado. Violación de la restricción.');
            CONFIRM_OUTPUT := SQLCODE;
        ELSE
            -- Otro manejo de errores
            DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error intentando realizar el procedimiento en la tabla MMMB_MARCA.');
            DBMS_OUTPUT.PUT_LINE('Error no manejado: ' || SQLERRM);
            CONFIRM_OUTPUT := -1;
        END IF;
        ROLLBACK;
END;
/

-- Cliente

CREATE OR REPLACE PROCEDURE MMMB_PROC_CLIENTE(
    OPCION VARCHAR2,
    RUT_CLIENTE_P NUMBER,
    NOMBRE_CLIENTE_P VARCHAR2 DEFAULT NULL,
    APELLIDO1_CLIENTE_P VARCHAR2 DEFAULT NULL,
    APELLIDO2_CLIENTE_P VARCHAR2 DEFAULT NULL,
    CORREO_CLIENTE_P VARCHAR2 DEFAULT NULL,
    CONFIRM_OUTPUT OUT NUMBER 
)
IS
BEGIN
    LOCK TABLE MMMB_CLIENTE IN ROW EXCLUSIVE MODE;

    CASE OPCION
        WHEN 'I' THEN
            IF (RUT_CLIENTE_P IS NULL OR 
                NOMBRE_CLIENTE_P IS NULL OR 
                APELLIDO1_CLIENTE_P IS NULL OR 
                APELLIDO2_CLIENTE_P IS NULL OR 
                CORREO_CLIENTE_P IS NULL) THEN
                DBMS_OUTPUT.PUT_LINE('Error: Alguno de los parámetros contiene valores nulos.');
                CONFIRM_OUTPUT := -1;
            ELSE
                IF MMMB_EXISTE_CLIENTE(RUT_CLIENTE_P) > 0 THEN -- U omitir y usar DUP_VAL_ON_INDEX
                    DBMS_OUTPUT.PUT_LINE('Error: El cliente ya existe.');
                    CONFIRM_OUTPUT := -2;
                ELSE
                    INSERT INTO MMMB_CLIENTE 
                        VALUES(RUT_CLIENTE_P, NOMBRE_CLIENTE_P, APELLIDO1_CLIENTE_P, APELLIDO2_CLIENTE_P, CORREO_CLIENTE_P);
                    CONFIRM_OUTPUT := 1;
                END IF;
            END IF;
        WHEN 'U' THEN
            IF MMMB_EXISTE_CLIENTE(RUT_CLIENTE_P) = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Error: El cliente no existe.');
                CONFIRM_OUTPUT := -1;
            ELSE
                UPDATE MMMB_CLIENTE 
                    SET NOMBRE_CLIENTE = NOMBRE_CLIENTE_P,
                        APELLIDO1_CLIENTE = APELLIDO1_CLIENTE_P,
                        APELLIDO2_CLIENTE = APELLIDO2_CLIENTE_P,
                        CORREO_CLIENTE = CORREO_CLIENTE_P
                    WHERE (RUT_CLIENTE = RUT_CLIENTE_P);
                CONFIRM_OUTPUT := 1;
            END IF;
        WHEN 'D' THEN
            DELETE FROM MMMB_CLIENTE WHERE (RUT_CLIENTE = RUT_CLIENTE_P);
            CONFIRM_OUTPUT := 1;
        ELSE
            CONFIRM_OUTPUT := -1;
    END CASE;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2292 THEN
            -- Si es un error de violación de integridad referencial (ORA-02292)
            DBMS_OUTPUT.PUT_LINE('Error de integridad referencial (ORA-02292) detectado. Violación de la restricción.');
            CONFIRM_OUTPUT := SQLCODE;
        ELSE
            -- Otro manejo de errores
            DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error intentando realizar el procedimiento en la tabla MMMB_MARCA.');
            DBMS_OUTPUT.PUT_LINE('Error no manejado: ' || SQLERRM);
            CONFIRM_OUTPUT := -1;
        END IF;
        ROLLBACK;
END;
/

-- Medio de pago
/*
CREATE OR REPLACE PROCEDURE MMMB_PROC_MEDIO_PAGO(
    OPCION VARCHAR2,
    COD_PAGO_P NUMBER,
    NOMBRE_MEDIO_PAGO_P VARCHAR2 DEFAULT NULL,
    CONFIRM_OUTPUT OUT NUMBER 
)
IS
BEGIN
    LOCK TABLE MMMB_MEDIO_PAGO IN ROW EXCLUSIVE MODE;

    CASE OPCION
        WHEN 'I' THEN
            IF (NOMBRE_MEDIO_PAGO_P IS NULL) THEN
                DBMS_OUTPUT.PUT_LINE('Error: El nombre del medio de pago no puede ser nulo.');
                CONFIRM_OUTPUT := -1;
            ELSE
                INSERT INTO MMMB_MEDIO_PAGO 
                    VALUES(MMMB_PK_MEDIO_PAGO.NEXTVAL, NOMBRE_MEDIO_PAGO_P);
                CONFIRM_OUTPUT := 1;
            END IF;
        WHEN 'U' THEN
            UPDATE MMMB_MEDIO_PAGO 
                SET NOMBRE_MEDIO_PAGO = NOMBRE_MEDIO_PAGO_P
                WHERE (COD_PAGO = COD_PAGO_P);
            CONFIRM_OUTPUT := 1;
        WHEN 'D' THEN
            DELETE FROM MMMB_MEDIO_PAGO WHERE (COD_PAGO = COD_PAGO_P);
            CONFIRM_OUTPUT := 1;
        ELSE
            CONFIRM_OUTPUT := -1;
    END CASE;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2292 THEN
            -- Si es un error de violación de integridad referencial (ORA-02292)
            DBMS_OUTPUT.PUT_LINE('Error de integridad referencial (ORA-02292) detectado. Violación de la restricción.');
            CONFIRM_OUTPUT := SQLCODE;
        ELSE
            -- Otro manejo de errores
            DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error intentando realizar el procedimiento en la tabla MMMB_MARCA.');
            DBMS_OUTPUT.PUT_LINE('Error no manejado: ' || SQLERRM);
            CONFIRM_OUTPUT := -1;
        END IF;
        ROLLBACK;
END;
/
*/

-- Descuento

CREATE OR REPLACE PROCEDURE MMMB_PROC_DESCUENTO(
    OPCION VARCHAR2,
    COD_DESCUENTO_P NUMBER,
    COD_PRODUCTO_P NUMBER DEFAULT NULL,
    PORCENTAJE_DESCUENTO_P NUMBER DEFAULT NULL,
    VALIDO_DESDE_P DATE DEFAULT NULL,
    VALIDO_HASTA_P DATE DEFAULT NULL,
    CONFIRM_OUTPUT OUT NUMBER 
)
IS
BEGIN
    LOCK TABLE MMMB_DESCUENTO IN ROW EXCLUSIVE MODE;

    CASE OPCION
        WHEN 'I' THEN
            IF (COD_PRODUCTO_P IS NULL OR PORCENTAJE_DESCUENTO_P IS NULL 
                OR VALIDO_DESDE_P IS NULL OR VALIDO_HASTA_P IS NULL) THEN
                DBMS_OUTPUT.PUT_LINE('Error: Alguno de los parámetros contiene valores nulos.');
                CONFIRM_OUTPUT := -1;
            ELSE
                IF MMMB_EXISTE_PRODUCTO(COD_PRODUCTO_P) = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('Error: El producto no existe.');
                    CONFIRM_OUTPUT := -1;
                ELSE
                    INSERT INTO MMMB_DESCUENTO 
                        VALUES(
                            MMMB_PK_DESCUENTO.NEXTVAL,
                            COD_PRODUCTO_P,
                            PORCENTAJE_DESCUENTO_P,
                            VALIDO_DESDE_P,
                            VALIDO_HASTA_P
                        );
                    CONFIRM_OUTPUT := 1;
                END IF;
            END IF;
        WHEN 'U' THEN
            IF MMMB_EXISTE_PRODUCTO(COD_PRODUCTO_P) = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Error: El producto no existe.');
                CONFIRM_OUTPUT := -1;
            ELSE
                UPDATE MMMB_DESCUENTO 
                    SET COD_PRODUCTO = COD_PRODUCTO_P,
                        PORCENTAJE_DESCUENTO = PORCENTAJE_DESCUENTO_P,
                        VALIDO_DESDE = VALIDO_DESDE_P,
                        VALIDO_HASTA = VALIDO_HASTA_P
                    WHERE (COD_DESCUENTO = COD_DESCUENTO_P);
                CONFIRM_OUTPUT := 1;
            END IF;
        WHEN 'D' THEN
            DELETE FROM MMMB_DESCUENTO WHERE (COD_DESCUENTO = COD_DESCUENTO_P);
            CONFIRM_OUTPUT := 1;
        ELSE
            CONFIRM_OUTPUT := -1;
    END CASE;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2292 THEN
            -- Si es un error de violación de integridad referencial (ORA-02292)
            DBMS_OUTPUT.PUT_LINE('Error de integridad referencial (ORA-02292) detectado. Violación de la restricción.');
            CONFIRM_OUTPUT := SQLCODE;
        ELSE
            -- Otro manejo de errores
            DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error intentando realizar el procedimiento en la tabla MMMB_MARCA.');
            DBMS_OUTPUT.PUT_LINE('Error no manejado: ' || SQLERRM);
            CONFIRM_OUTPUT := -1;
        END IF;
        ROLLBACK;
END;
/

-- Venta

CREATE OR REPLACE PROCEDURE MMMB_PROC_VENTA(
    OPCION VARCHAR2,
    COD_VENTA_P NUMBER,
    COD_CAJA_P NUMBER DEFAULT NULL,
    RUT_CLIENTE_P NUMBER DEFAULT NULL,
    RUT_EMPLEADO_P NUMBER DEFAULT NULL,
    COD_PAGO_P NUMBER DEFAULT NULL,
    FECHA_VENTA_P DATE DEFAULT NULL,
    TOTAL_VENTA_P NUMBER DEFAULT NULL,
    DESCUENTO_VENTA_P NUMBER DEFAULT NULL,
    CONFIRM_OUTPUT OUT NUMBER 
)
IS
BEGIN
    LOCK TABLE MMMB_VENTA IN ROW EXCLUSIVE MODE;

    CASE OPCION
        WHEN 'I' THEN
            IF (COD_CAJA_P IS NULL OR RUT_CLIENTE_P IS NULL OR RUT_EMPLEADO_P IS NULL 
                OR COD_PAGO_P IS NULL OR FECHA_VENTA_P IS NULL OR TOTAL_VENTA_P IS NULL) THEN
                DBMS_OUTPUT.PUT_LINE('Error: Alguno de los parámetros contiene valores nulos.');
                CONFIRM_OUTPUT := -1;
            ELSE
                IF MMMB_EXISTE_CAJA(COD_CAJA_P) = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('Error: La caja no existe.');
                    CONFIRM_OUTPUT := -1;
                ELSIF MMMB_EXISTE_CLIENTE(RUT_CLIENTE_P) = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('Error: El cliente no existe.');
                    CONFIRM_OUTPUT := -1;
                ELSIF MMMB_EXISTE_EMPLEADO(RUT_EMPLEADO_P) = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('Error: El empleado no existe.');
                    CONFIRM_OUTPUT := -1;
                ELSE
                    INSERT INTO MMMB_VENTA 
                        VALUES(
                            MMMB_PK_VENTA.NEXTVAL,
                            COD_CAJA_P,
                            RUT_CLIENTE_P,
                            RUT_EMPLEADO_P,
                            COD_PAGO_P,
                            FECHA_VENTA_P,
                            TOTAL_VENTA_P,
                            DESCUENTO_VENTA_P
                        );
                    CONFIRM_OUTPUT := 1;
                END IF;
            END IF;
        WHEN 'U' THEN
            IF MMMB_EXISTE_CAJA(COD_CAJA_P) = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Error: La caja no existe.');
                CONFIRM_OUTPUT := -1;
            ELSIF MMMB_EXISTE_CLIENTE(RUT_CLIENTE_P) = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Error: El cliente no existe.');
                CONFIRM_OUTPUT := -1;
            ELSIF MMMB_EXISTE_EMPLEADO(RUT_EMPLEADO_P) = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Error: El empleado no existe.');
                CONFIRM_OUTPUT := -1;
            ELSE
                UPDATE MMMB_VENTA 
                    SET COD_CAJA = COD_CAJA_P,
                        RUT_CLIENTE = RUT_CLIENTE_P,
                        RUT_EMPLEADO = RUT_EMPLEADO_P,
                        COD_PAGO = COD_PAGO_P,
                        FECHA_VENTA = FECHA_VENTA_P,
                        TOTAL_VENTA = TOTAL_VENTA_P,
                        DESCUENTO_VENTA = DESCUENTO_VENTA_P
                    WHERE (COD_VENTA = COD_VENTA_P);
                CONFIRM_OUTPUT := 1;
            END IF;
        WHEN 'D' THEN
            DELETE FROM MMMB_VENTA WHERE (COD_VENTA = COD_VENTA_P);
            CONFIRM_OUTPUT := 1;
        ELSE
            CONFIRM_OUTPUT := -1;
    END CASE;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2292 THEN
            -- Si es un error de violación de integridad referencial (ORA-02292)
            DBMS_OUTPUT.PUT_LINE('Error de integridad referencial (ORA-02292) detectado. Violación de la restricción.');
            CONFIRM_OUTPUT := SQLCODE;
        ELSE
            -- Otro manejo de errores
            DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error intentando realizar el procedimiento en la tabla MMMB_MARCA.');
            DBMS_OUTPUT.PUT_LINE('Error no manejado: ' || SQLERRM);
            CONFIRM_OUTPUT := -1;
        END IF;
        ROLLBACK;
END;
/

/*
    TRIGGERS
*/

CREATE OR REPLACE TRIGGER MMMB_TRG_ACTUALIZAR_PRECIO
AFTER UPDATE OF PRECIO_VENTA, PRECIO_COMPRA ON MMMB_PRODUCTO
FOR EACH ROW
BEGIN
    IF :OLD.PRECIO_VENTA != :NEW.PRECIO_VENTA THEN
        INSERT INTO MMMB_HISTORIAL_PRECIOS 
        VALUES (
            MMMB_PK_HISTORIAL_PRECIOS.NEXTVAL,
            :NEW.COD_PRODUCTO,
            'PRECIO_VENTA',
            :OLD.PRECIO_VENTA,
            :NEW.PRECIO_VENTA,
            SYSDATE
        );
    END IF;

    IF :OLD.PRECIO_COMPRA != :NEW.PRECIO_COMPRA THEN
        INSERT INTO MMMB_HISTORIAL_PRECIOS 
        VALUES (
            MMMB_PK_HISTORIAL_PRECIOS.NEXTVAL,
            :NEW.COD_PRODUCTO,
            'PRECIO_COMPRA',
            :OLD.PRECIO_COMPRA,
            :NEW.PRECIO_COMPRA,
            SYSDATE
        );
    END IF;
END;
/


/*
    BASE DATA
*/

-- Inserts para añadir 2 bodegas
INSERT INTO MMMB_BODEGA (COD_BODEGA) VALUES (1);
INSERT INTO MMMB_BODEGA (COD_BODEGA) VALUES (2);

-- Inserts para añadir 2 sucursales
INSERT INTO MMMB_SUCURSAL (COD_SUCURSAL, COD_BODEGA, NOMBRE_SUCURSAL, TELEFONO_SUCURSAL)
VALUES (1, 1, 'Sucursal A', '+56954685222');
INSERT INTO MMMB_SUCURSAL (COD_SUCURSAL, COD_BODEGA, NOMBRE_SUCURSAL, TELEFONO_SUCURSAL)
VALUES (2, 2, 'Sucursal B', '+56954685222');

-- Inserts para añadir 2 cargos
INSERT INTO MMMB_CARGO (COD_CARGO, NOMBRE_CARGO) VALUES (1, 'Dueño');
INSERT INTO MMMB_CARGO (COD_CARGO, NOMBRE_CARGO) VALUES (2, 'Cajero');

-- Empleados
--      Insertar Dueño
DECLARE
    confirm_output NUMBER;
BEGIN
    MMMB_PROC_EMPLEADO(
        'I',
        12345678,
        1, -- COD_SUCURSAL
        1, -- COD_CARGO (Dueño)
        'Juan',
        'Pérez',
        'González',
        '555-1234',
        'juan.perez@example.com',
        'juanperez',
        'hashed_password',
        confirm_output
    );
END;
/

--      Insertar Cajeros
DECLARE
    confirm_output NUMBER;
BEGIN
    FOR i IN 1..4 LOOP
        MMMB_PROC_EMPLEADO(
            'I',
            15000000 + i, -- RUT_EMPLEADO (Valores ficticios para cajeros)
            1, -- COD_SUCURSAL
            2, -- COD_CARGO (Cajero)
            'Cajero' || TO_CHAR(i),
            'Apellido',
            'Apellido',
            '555-5678',
            'cajero' || TO_CHAR(i) || '@example.com',
            'cajero' || TO_CHAR(i),
            'hashed_password',
            confirm_output
        );
    END LOOP;
END;
/

-- Medios de pago
INSERT INTO MMMB_MEDIO_PAGO VALUES (1, 'Efectivo');
INSERT INTO MMMB_MEDIO_PAGO VALUES (2, 'Redcompra');
INSERT INTO MMMB_MEDIO_PAGO VALUES (3, 'Fiado');
INSERT INTO MMMB_MEDIO_PAGO VALUES (4, 'Paypal');
INSERT INTO MMMB_MEDIO_PAGO VALUES (5, 'Khipu');
INSERT INTO MMMB_MEDIO_PAGO VALUES (6, 'Flow');
INSERT INTO MMMB_MEDIO_PAGO VALUES (7, 'Mach');
INSERT INTO MMMB_MEDIO_PAGO VALUES (8, 'Mercado Pago');
INSERT INTO MMMB_MEDIO_PAGO VALUES (9, 'Cheque');
INSERT INTO MMMB_MEDIO_PAGO VALUES (10, 'Transferencia Bancaria');
INSERT INTO MMMB_MEDIO_PAGO VALUES (11, 'Trueque');

-- Proveedores

/*
-- Por si error EN TESTING
DELETE FROM MMMB_PRODUCTO;
DELETE FROM MMMB_PROVEEDOR;
DELETE FROM MMMB_CATEGORIA;
DELETE FROM MMMB_MARCA;
*/

SET DEFINE OFF -- Evitar que & sea interpretado sustitución de variables y pida datos a usuario.

DECLARE
    out_val NUMBER;
BEGIN    
    MMMB_PROC_PROVEEDOR('I', '', 'Frescos Ltda', 'ventas@frescos.com', '555-8888', out_val);
    MMMB_PROC_PROVEEDOR('I', '', 'Delicias SA', 'info@delicias.com', '555-7777', out_val);
    MMMB_PROC_PROVEEDOR('I', '', 'Sabores Exquisitos', 'contacto@sabores.com', '555-9999', out_val);
    MMMB_PROC_PROVEEDOR('I', '', 'Natureza Alimentos', 'info@naturezaalimentos.com', '555-1010', out_val);
    MMMB_PROC_PROVEEDOR('I', '', 'Gourmet Provisions', 'sales@gourmetprovisions.com', '555-1111', out_val);
    MMMB_PROC_PROVEEDOR('I', '', 'Suministros Office', 'info@suministrosoffice.com', '555-1717', out_val);
    MMMB_PROC_PROVEEDOR('I', '', 'EcoFresh', 'info@ecofresh.com', '555-1313', out_val);
    MMMB_PROC_PROVEEDOR('I', '', 'Golden Harvest', 'sales@goldenharvest.com', '555-1414', out_val);
    MMMB_PROC_PROVEEDOR('I', '', 'Tropical Delights', 'contacto@tropicaldelights.com', '555-1515', out_val);
    MMMB_PROC_PROVEEDOR('I', '', 'Quality Foods', 'info@qualityfoods.com', '555-1616', out_val);
    
    -- Categorías
    
    MMMB_PROC_CATEGORIA('I', '', 'Bebidas', out_val);
    MMMB_PROC_CATEGORIA('I', '', 'Enlatados', out_val);
    MMMB_PROC_CATEGORIA('I', '', 'Productos lácteos', out_val);
    MMMB_PROC_CATEGORIA('I', '', 'Panadería', out_val);
    MMMB_PROC_CATEGORIA('I', '', 'Snacks', out_val);
    MMMB_PROC_CATEGORIA('I', '', 'Cuidado personal', out_val);
    MMMB_PROC_CATEGORIA('I', '', 'Limpieza', out_val);
    MMMB_PROC_CATEGORIA('I', '', 'Higiene', out_val);
    MMMB_PROC_CATEGORIA('I', '', 'Carnes y embutidos', out_val);
    MMMB_PROC_CATEGORIA('I', '', 'Artículos de Oficina', out_val);
    MMMB_PROC_CATEGORIA('I', '', 'Mascotas', out_val);
    MMMB_PROC_CATEGORIA('I', '', 'Frutas y Verduras', out_val);
    
    -- Marcas (En realidad, una marca, puede estar en varias categorías, por lo que podríamos enlazar y crear tabla intermedia (o no))
    
        -- Bebidas
    MMMB_PROC_MARCA('I', '', 'Coca-Cola', out_val);
    MMMB_PROC_MARCA('I', '', 'Pepsi', out_val);
        -- Enlatados
    MMMB_PROC_MARCA('I', '', 'San José', out_val);
    MMMB_PROC_MARCA('I', '', 'Robinson Crusoe', out_val);
        -- Productos lácteos
    MMMB_PROC_MARCA('I', '', 'Nestlé', out_val);
    MMMB_PROC_MARCA('I', '', 'Colun', out_val);
        -- Panadería
    MMMB_PROC_MARCA('I', '', 'Bimbo', out_val);
    MMMB_PROC_MARCA('I', '', 'Ideal', out_val);
        -- Snacks
    MMMB_PROC_MARCA('I', '', 'Costa', out_val);
    MMMB_PROC_MARCA('I', '', 'Evercrisp', out_val);
        -- Cuidado personal
    MMMB_PROC_MARCA('I', '', 'Dove', out_val);
    MMMB_PROC_MARCA('I', '', 'Pantene', out_val);
        -- Limpieza
    MMMB_PROC_MARCA('I', '', 'Clorox', out_val);
    MMMB_PROC_MARCA('I', '', 'Cif', out_val);
        -- Higiene
    MMMB_PROC_MARCA('I', '', 'Colgate', out_val);
    MMMB_PROC_MARCA('I', '', 'Johnson & Johnson', out_val);
        -- Carnes y embutidos
    MMMB_PROC_MARCA('I', '', 'Ariztía', out_val);
    MMMB_PROC_MARCA('I', '', 'Super Pollo', out_val);
        -- Artículos de Oficina
    MMMB_PROC_MARCA('I', '', 'Proarte', out_val);
    MMMB_PROC_MARCA('I', '', 'Torre', out_val);
        -- Mascotas
    MMMB_PROC_MARCA('I', '', 'Whiskas', out_val);
    MMMB_PROC_MARCA('I', '', 'Master Dog', out_val);
        -- Frutas y verduras
    MMMB_PROC_MARCA('I', '', 'Sin marca', out_val);  
    
    -- Productos
    
        -- Bebidas - Coca-Cola
    MMMB_PROC_PRODUCTO('I', '', 1, 1, 'Coca-Cola Regular', 1500, 2500, 100, 75000001, out_val);
    MMMB_PROC_PRODUCTO('I', '', 1, 1, 'Coca-Cola Zero', 2500, 3000, 100, 75000001, out_val);
        -- Bebidas - Pepsi
    MMMB_PROC_PRODUCTO('I', '', 2, 1, 'Pepsi Regular', 1500, 2500, 100, 75000001, out_val);
    MMMB_PROC_PRODUCTO('I', '', 2, 1, 'Pepsi Max', 2500, 2800, 100, 75000001, out_val);
        -- Enlatados - San José
    MMMB_PROC_PRODUCTO('I', '', 3, 2, 'Atún San José', 2000, 3500, 50, 75000010, out_val);
    MMMB_PROC_PRODUCTO('I', '', 3, 2, 'Maíz enlatado', 1800, 2.8, 50, 75000010, out_val);
        -- Enlatados - Robinson Crusoe
    MMMB_PROC_PRODUCTO('I', '', 4, 2, 'Sardinas kawai', 1700, 3000, 40, 75000010, out_val);
    MMMB_PROC_PRODUCTO('I', '', 4, 2, 'Choclo enlatado', 1900, 3.2, 40, 75000010, out_val);
        -- Productos lácteos - Nestlé
    MMMB_PROC_PRODUCTO('I', '', 5, 3, 'Leche Nestlé', 2500, 3500, 30, 75000003, out_val);
    MMMB_PROC_PRODUCTO('I', '', 5, 3, 'Yogurt Nestlé', 1800, 2500, 40, 75000003, out_val);    
        -- Productos lácteos - Colun
    MMMB_PROC_PRODUCTO('I', '', 6, 3, 'Lache', 2200, 3000, 35, 75000003, out_val);
    MMMB_PROC_PRODUCTO('I', '', 6, 3, 'Queso de ayer', 3000, 4500, 25, 75000003, out_val);
        -- Panadería - Bimbo
    MMMB_PROC_PRODUCTO('I', '', 7, 4, 'Pan Blanco Bimbo', 1500, 2000, 50, 75000004, out_val);
    MMMB_PROC_PRODUCTO('I', '', 7, 4, 'Pan Integral Bimbo', 2000, 2500, 40, 75000004, out_val);
        -- Panadería - Ideal
    MMMB_PROC_PRODUCTO('I', '', 8, 4, 'Pan Blanco Ideal', 1800, 2200, 45, 75000004, out_val);
    MMMB_PROC_PRODUCTO('I', '', 8, 4, 'Pan Integral Ideal', 2200, 2800, 35, 75000004, out_val);
        -- Snacks - Costa
    MMMB_PROC_PRODUCTO('I', '', 9, 5, 'Papas Fritas', 1500, 2000, 60, 75000005, out_val);
    MMMB_PROC_PRODUCTO('I', '', 9, 5, 'Galletas Saladas', 1200, 1800, 75, 75000005, out_val);
        -- Snacks - Evercrisp
    MMMB_PROC_PRODUCTO('I', '', 10, 5, 'Chips HD', 2000, 2500, 55, 75000005, out_val);
    MMMB_PROC_PRODUCTO('I', '', 10, 5, 'Pretzels 2G', 1800, 2200, 50, 75000005, out_val);
        -- Cuidado personal - Dove
    MMMB_PROC_PRODUCTO('I', '', 11, 6, 'Shampoo 1L', 5000, 7000, 30, 75000006, out_val);
    MMMB_PROC_PRODUCTO('I', '', 11, 6, 'Acondicionador II', 4500, 6500, 25, 75000006, out_val);
        -- Cuidado personal - Pantene
    MMMB_PROC_PRODUCTO('I', '', 12, 6, 'Shampoo con instrucciones', 4800, 6800, 35, 75000006, out_val);
    MMMB_PROC_PRODUCTO('I', '', 12, 6, 'Acondicionador Palpelo', 4300, 6300, 28, 75000006, out_val);
        -- Limpieza - Clorox
    MMMB_PROC_PRODUCTO('I', '', 13, 7, 'Cloro 15L', 3000, 4500, 40, 75000007, out_val);
    MMMB_PROC_PRODUCTO('I', '', 13, 7, 'Limpiador Multiusos', 2500, 4000, 45, 75000007, out_val);
        -- Limpieza - Cif
    MMMB_PROC_PRODUCTO('I', '', 14, 7, 'Limpiador Baño', 2800, 4200, 38, 75000007, out_val);
    MMMB_PROC_PRODUCTO('I', '', 14, 7, 'Limpiador Cocina', 3200, 4800, 32, 75000007, out_val);
        -- Higiene - Colgate
    MMMB_PROC_PRODUCTO('I', '', 15, 8, 'Pasta Dental picante', 2000, 3500, 55, 75000008, out_val);
    MMMB_PROC_PRODUCTO('I', '', 15, 8, 'Cepillo Dental usado', 1500, 2800, 60, 75000008, out_val);
        -- Higiene - Johnson & Johnson
    MMMB_PROC_PRODUCTO('I', '', 16, 8, 'Jabón Líquido 2L', 4000, 5500, 28, 75000008, out_val);
    MMMB_PROC_PRODUCTO('I', '', 16, 8, 'Shampoo Bebé', 3500, 5000, 30, 75000008, out_val);
    -- Carnes y embutidos - Ariztía
    MMMB_PROC_PRODUCTO('I', '', 17, 9, 'Pollo fresco', 5000, 8000, 25, 75000010, out_val);
    MMMB_PROC_PRODUCTO('I', '', 17, 9, 'Embutidos en butido', 6000, 9000, 20, 75000010, out_val);
    -- Carnes y embutidos - Super Pollo
    MMMB_PROC_PRODUCTO('I', '', 18, 9, 'Pollo Super', 4500, 7500, 30, 75000010, out_val);
    MMMB_PROC_PRODUCTO('I', '', 18, 9, 'Embutidos embutibles', 5500, 8500, 22, 75000010, out_val);
    -- Artículos de Oficina - Proarte
    MMMB_PROC_PRODUCTO('I', '', 19, 10, 'Set Pinceles usados', 8000, 12000, 18, 75000006, out_val);
    MMMB_PROC_PRODUCTO('I', '', 19, 10, 'Bloc de Dibujo seminuevo', 6500, 10000, 25, 75000006, out_val);
    -- Artículos de Oficina - Torre
    MMMB_PROC_PRODUCTO('I', '', 20, 10, 'Lápices color blanco', 3000, 5000, 35, 75000006, out_val);
    MMMB_PROC_PRODUCTO('I', '', 20, 10, 'Libretas 50 hojas', 2500, 4000, 40, 75000006, out_val);
    -- Mascotas - Whiskas
    MMMB_PROC_PRODUCTO('I', '', 21, 11, 'Comida uwu', 7000, 10000, 15, 75000008, out_val);
    MMMB_PROC_PRODUCTO('I', '', 21, 11, 'Snacks Gatos', 4500, 7000, 20, 75000008, out_val);
    -- Mascotas - Master Dog
    MMMB_PROC_PRODUCTO('I', '', 22, 11, 'Comida Pa Kiltros', 8000, 12000, 12, 75000008, out_val);
    MMMB_PROC_PRODUCTO('I', '', 22, 11, 'Snacks Perros', 5500, 8000, 18, 75000008, out_val);
    -- Frutas y verduras
    MMMB_PROC_PRODUCTO('I', '', 23, 12, 'Manzana 1Kg', 500, 2100, 18, 75000008, out_val);
    MMMB_PROC_PRODUCTO('I', '', 23, 12, 'Tomate 1Kg', 800, 1000, 18, 75000008, out_val);
    MMMB_PROC_PRODUCTO('I', '', 23, 12, 'Zanahoria 1Kg', 500, 700, 18, 75000008, out_val);
END;
/
----