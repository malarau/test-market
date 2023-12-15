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
DROP TABLE MMMB_DETALLE_SUCURSAL_PRODUCTO cascade constraints; -- Se ha cambiado, antes: MMMB_DETALLE_BODEGA_PRODUCTO
DROP TABLE MMMB_DETALLE_PRODUCTO_PROVEEDOR cascade constraints;
DROP TABLE MMMB_PRODUCTO cascade constraints;
DROP TABLE MMMB_PROVEEDOR cascade constraints;
DROP TABLE MMMB_CATEGORIA cascade constraints;
DROP TABLE MMMB_MARCA cascade constraints;
--DROP TABLE MMMB_DETALLE_TURNO_HORARIO cascade constraints;  -- Se ha quitado
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
-- DROP SEQUENCE MMMB_PK_CAJA; 
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
CREATE SEQUENCE MMMB_PK_CAJA
    START WITH 1
    INCREMENT BY 1
    CACHE 10;

CREATE SEQUENCE MMMB_PK_DETALLE_VENTA_PRODUCTO
    START WITH 1
    INCREMENT BY 1
    CACHE 10;

CREATE SEQUENCE MMMB_PK_DETALLE_PRODUCTO_PROVEEDOR
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

CREATE TABLE MMMB_SUCURSAL( -- Se ha eliminado el campo y restricción asociados a Bodega
    COD_SUCURSAL NUMBER,
    NOMBRE_SUCURSAL VARCHAR2(50),
    TELEFONO_SUCURSAL VARCHAR2(15), -- Se ha cambiado a VARCHAR2 15
    CONSTRAINT PK_SUCURSAL PRIMARY KEY (COD_SUCURSAL));

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
    CONTRASEÑA_EMPLEADO VARCHAR2(100),   -- Se ha cambiado a 100, por supuesto hash de 256
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
    COD_HORARIO NUMBER, -- Se ha agregado horario, ahora es 1:M, eliminando MMMB_DETALLE_TURNO_HORARIO
    DIA DATE,
    HORA_ENTRADA TIMESTAMP,
    HORA_SALIDA TIMESTAMP,
    INICIO_COLACION TIMESTAMP,
    TERMINO_COLACION TIMESTAMP,
    CONSTRAINT PK_TURNO PRIMARY KEY (COD_TURNO),
    CONSTRAINT FK_TURNO_HORARIO FOREIGN KEY (COD_HORARIO) REFERENCES MMMB_HORARIO(COD_HORARIO)
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
    -- STOCK_PRODUCTO NUMBER, Se ha eliminado stock, se debe consultar y actualizar stock según sucursal
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

CREATE TABLE MMMB_DETALLE_SUCURSAL_PRODUCTO(
    COD_SUCURSAL NUMBER,
    COD_PRODUCTO NUMBER,
    STOCK_SUCURSAL_PRODUCTO NUMBER,
    CONSTRAINT PK_DETALLE_SUCURSAL_PRODUCTO PRIMARY KEY (COD_SUCURSAL,COD_PRODUCTO),
    CONSTRAINT FK_DETALLE_SUCURSAL_PRODUCTO_SUCURSAL FOREIGN KEY (COD_SUCURSAL) REFERENCES MMMB_SUCURSAL(COD_SUCURSAL),
    CONSTRAINT FK_DETALLE_SUCURSAL_PRODUCTO_PRODUCTO FOREIGN KEY (COD_PRODUCTO) REFERENCES MMMB_PRODUCTO(COD_PRODUCTO)
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
    RUT_EMPLEADO NUMBER,
    SALDO_INICIAL NUMBER,
    VENTAS_EFECTIVO NUMBER,
    SALDO_FINAL NUMBER,
    DIFERENCIA NUMBER,
    FECHA DATE,
    CONSTRAINT PK_DETALLE_CUADRATURA PRIMARY KEY (COD_DETALLE_CUADRATURA),
    CONSTRAINT FK_DETALLE_CUADRATURA_CAJA FOREIGN KEY (COD_CAJA) REFERENCES MMMB_CAJA(COD_CAJA),
    CONSTRAINT FK_DETALLE_CUADRATURA_EMPLEADO FOREIGN KEY (RUT_EMPLEADO) REFERENCES MMMB_EMPLEADO(RUT_EMPLEADO)
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
    COD_SUCURSAL NUMBER, -- Se ha agregado la sucursal
    COD_CAJA NUMBER,        -- Droplist, según sucursal, según empleado
    RUT_CLIENTE NUMBER,     -- Se ingresa y se busca
    RUT_EMPLEADO NUMBER,    -- Automático (por logeo)
    COD_PAGO NUMBER,        -- Droplist (Medio de pago?)
    FECHA_VENTA DATE,       -- Automático
    TOTAL_VENTA NUMBER,     -- Trigger
    DESCUENTO_VENTA NUMBER, -- NO HAY TRIGGER, ERA MENTIRA
    CONSTRAINT PK_VENTA PRIMARY KEY (COD_VENTA),
    CONSTRAINT FK_VENTA_CAJA FOREIGN KEY (COD_CAJA) REFERENCES MMMB_CAJA(COD_CAJA),
    CONSTRAINT FK_VENTA_CLIENTE FOREIGN KEY (RUT_CLIENTE) REFERENCES MMMB_CLIENTE(RUT_CLIENTE),
    CONSTRAINT FK_VENTA_EMPLEADO FOREIGN KEY (RUT_EMPLEADO) REFERENCES MMMB_EMPLEADO(RUT_EMPLEADO),
    CONSTRAINT FK_VENTA_MEDIO_PAGO FOREIGN KEY (COD_PAGO) REFERENCES MMMB_MEDIO_PAGO(COD_PAGO)
);

CREATE TABLE MMMB_DETALLE_VENTA_PRODUCTO( -- OBVIAMENTE FALTÓ EL VALOR UNITARIO, PORQUE LOS PRECIOS PUEDEN CAMBIARRRRRRRRRRRRRRRRRRRRRRRRR!!!1
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
    CONSTRAINT PK_HISTORIAL_PRECIOS PRIMARY KEY(COD_HISTORIAL_PRECIO)
    -- ,CONSTRAINT FK_HISTORIAL_PRECIOS_PRODUCTO FOREIGN KEY(COD_PRODUCTO) REFERENCES MMMB_PRODUCTO(COD_PRODUCTO) -- Es un registro, puede que el producto sea eliminado y esto bloquea.
);

/*
    FUNCTIONS
*/

CREATE OR REPLACE FUNCTION MMMB_SUMAR_DESCUENTOS_HOY RETURN NUMBER IS
    CURSOR cursor_descuentos IS
        SELECT DESCUENTO_VENTA
        FROM MMMB_VENTA
        WHERE TRUNC(FECHA_VENTA) = TRUNC(SYSDATE);
    descuento_hoy MMMB_VENTA.DESCUENTO_VENTA%TYPE;
    suma_descuentos NUMBER DEFAULT 0;
BEGIN
    OPEN cursor_descuentos;

    LOOP
        FETCH cursor_descuentos INTO descuento_hoy;
        EXIT WHEN cursor_descuentos%NOTFOUND;

        suma_descuentos := suma_descuentos + NVL(descuento_hoy, 0);
    END LOOP;

    CLOSE cursor_descuentos;

    RETURN suma_descuentos;
END MMMB_SUMAR_DESCUENTOS_HOY;
/

CREATE OR REPLACE FUNCTION MMMB_TOTAL_VENTAS_HOY RETURN NUMBER IS
    CURSOR cursor_ventas IS
        SELECT TOTAL_VENTA
        FROM MMMB_VENTA
        WHERE TRUNC(FECHA_VENTA) = TRUNC(SYSDATE);
    total_venta_hoy MMMB_VENTA.TOTAL_VENTA%TYPE;
    suma_total NUMBER DEFAULT 0;
BEGIN
    OPEN cursor_ventas;

    LOOP
        FETCH cursor_ventas INTO total_venta_hoy;
        EXIT WHEN cursor_ventas%NOTFOUND;

        suma_total := suma_total + NVL(total_venta_hoy, 0);
    END LOOP;

    CLOSE cursor_ventas;

    RETURN suma_total;
END MMMB_TOTAL_VENTAS_HOY;
/

-- Diferencia entre precios, porcentual
CREATE OR REPLACE FUNCTION MMMB_CALCULAR_DIFERENCIA_PORCENTUAL(
  VALOR_ANTERIOR_P IN NUMBER,
  VALOR_NUEVO_P IN NUMBER
) RETURN NUMBER IS
  V_DIF_PORCENTUAL NUMBER;
BEGIN
  IF VALOR_ANTERIOR_P = 0 THEN
    V_DIF_PORCENTUAL := NULL;
  ELSE
    V_DIF_PORCENTUAL := ((VALOR_NUEVO_P - VALOR_ANTERIOR_P) / VALOR_ANTERIOR_P) * 100;
  END IF;

  RETURN V_DIF_PORCENTUAL;
END MMMB_CALCULAR_DIFERENCIA_PORCENTUAL;
/

-- Hay stock?
CREATE OR REPLACE FUNCTION MMMB_VALIDAR_STOCK(
    COD_SUCURSAL_P NUMBER,
    COD_PRODUCTO_P NUMBER,
    CANTIDAD_P NUMBER
) RETURN NUMBER AS
    v_stock_disponible NUMBER;
BEGIN
    -- Inicializar el stock_disponible a -1 para el caso en que no se encuentre ningún registro
    v_stock_disponible := -1;

    BEGIN
        -- Intentar obtener el stock disponible para el producto en la sucursal
        SELECT STOCK_SUCURSAL_PRODUCTO
        INTO v_stock_disponible
        FROM MMMB_DETALLE_SUCURSAL_PRODUCTO
        WHERE COD_SUCURSAL = COD_SUCURSAL_P
            AND COD_PRODUCTO = COD_PRODUCTO_P;

    EXCEPTION
        -- Manejar la excepción cuando no se encuentra ningún registro
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No se encuentra el producto en la sucursal.');
            v_stock_disponible := -1;

        -- Otras excepciones personalizadas según sea necesario
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error al intentar obtener el stock: ' || SQLERRM);
            v_stock_disponible := -1;
    END;

    -- Verificar si la cantidad supera el stock disponible
    IF v_stock_disponible = -1 THEN
        RETURN -1; -- No se pudo obtener el stock
    ELSE
        RETURN 1; -- La cantidad es válida
    END IF;
END;
/


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

-- Existe horario?
CREATE OR REPLACE FUNCTION MMMB_EXISTE_HORARIO(COD_HORARIO_P NUMBER)
RETURN NUMBER
IS
    v_horario_exists NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_horario_exists
    FROM MMMB_HORARIO
    WHERE COD_HORARIO = COD_HORARIO_P;

    RETURN v_horario_exists;
EXCEPTION
    WHEN OTHERS THEN
        RETURN -1;
END MMMB_EXISTE_HORARIO;
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
        STOCK_SUCURSAL1_P NUMBER DEFAULT NULL, -- Se ha agregado stock sucursal 1
        STOCK_SUCURSAL2_P NUMBER DEFAULT NULL, -- Se ha agregado stock sucursal 2
        RUT_PROVEEDOR_P NUMBER DEFAULT NULL,
        CONFIRM_OUTPUT OUT NUMBER 
    )
IS
BEGIN
    LOCK TABLE MMMB_PRODUCTO IN ROW EXCLUSIVE MODE;

    CASE OPCION
        WHEN 'I' THEN
            IF COALESCE(
                COD_MARCA_P, COD_CATEGORIA_P, NOMBRE_PRODUCTO_P, PRECIO_COMPRA_P, PRECIO_VENTA_P, STOCK_SUCURSAL1_P, STOCK_SUCURSAL2_P, RUT_PROVEEDOR_P
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
                    CONFIRM_OUTPUT := MMMB_PK_PRODUCTO.NEXTVAL;
                    -- Inserar en productos
                    INSERT INTO MMMB_PRODUCTO 
                        VALUES(
                            CONFIRM_OUTPUT, COD_MARCA_P, COD_CATEGORIA_P, NOMBRE_PRODUCTO_P,
                            PRECIO_COMPRA_P, PRECIO_VENTA_P, RUT_PROVEEDOR_P
                        );
                    -- Agregar stock a sucursal 1
                    INSERT INTO MMMB_DETALLE_SUCURSAL_PRODUCTO VALUES (1, CONFIRM_OUTPUT, STOCK_SUCURSAL1_P);
                    -- Agregar stock en sucursal 2
                    INSERT INTO MMMB_DETALLE_SUCURSAL_PRODUCTO VALUES (2, CONFIRM_OUTPUT, STOCK_SUCURSAL2_P);

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
            ELSIF MMMB_EXISTE_PRODUCTO(COD_PRODUCTO_P) = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Error: El producto no existe.');
                CONFIRM_OUTPUT := -1;
            ELSE
                -- Actualizar producto
                UPDATE MMMB_PRODUCTO 
                    SET COD_MARCA = COD_MARCA_P,
                        COD_CATEGORIA = COD_CATEGORIA_P,
                        NOMBRE_PRODUCTO = NOMBRE_PRODUCTO_P,
                        PRECIO_COMPRA = PRECIO_COMPRA_P,
                        PRECIO_VENTA = PRECIO_VENTA_P,
                        RUT_PROVEEDOR = RUT_PROVEEDOR_P
                    WHERE (COD_PRODUCTO = COD_PRODUCTO_P);
                -- Actualizar stock en sucursal 1
                UPDATE MMMB_DETALLE_SUCURSAL_PRODUCTO
                    SET STOCK_SUCURSAL_PRODUCTO = STOCK_SUCURSAL1_P
                    WHERE (COD_PRODUCTO = COD_PRODUCTO_P AND COD_SUCURSAL = 1);
                -- Actualizar stock en sucursal 2
                UPDATE MMMB_DETALLE_SUCURSAL_PRODUCTO
                    SET STOCK_SUCURSAL_PRODUCTO = STOCK_SUCURSAL2_P
                    WHERE (COD_PRODUCTO = COD_PRODUCTO_P AND COD_SUCURSAL = 2);
                CONFIRM_OUTPUT := 1;
            END IF;
        WHEN 'D' THEN
            -- Eliminar stock de sucursal 1
            DELETE FROM MMMB_DETALLE_SUCURSAL_PRODUCTO WHERE (COD_PRODUCTO = COD_PRODUCTO_P AND COD_SUCURSAL = 1);
            -- Eliminar stock de sucursal 2
            DELETE FROM MMMB_DETALLE_SUCURSAL_PRODUCTO WHERE (COD_PRODUCTO = COD_PRODUCTO_P AND COD_SUCURSAL = 2);
            -- Eliminar producto
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
                    CONFIRM_OUTPUT := MMMB_PK_HORARIO.NEXTVAL;
                    INSERT INTO MMMB_HORARIO 
                        VALUES(CONFIRM_OUTPUT, RUT_EMPLEADO_P, TO_DATE(FECHA_INICIO_P, 'DD/MM/YY'));   
                END IF;              
            END IF;
        WHEN 'U' THEN
            IF MMMB_EXISTE_EMPLEADO(RUT_EMPLEADO_P) = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Error: El empleado no existe.');
                CONFIRM_OUTPUT := -1;
            ELSE
                UPDATE MMMB_HORARIO 
                    SET RUT_EMPLEADO = RUT_EMPLEADO_P,
                        FECHA_INICIO = TO_DATE(FECHA_INICIO_P, 'DD/MM/YY')
                    WHERE (COD_HORARIO = COD_HORARIO_P);
                CONFIRM_OUTPUT := 1;
            END IF;
        WHEN 'D' THEN
            -- ELIMINA TAMBIÉN TODOS LOS TURNOS, PORQUE NO HAY TIEMPO PA IR DE A UNO.
            DELETE FROM MMMB_TURNO WHERE (COD_HORARIO = COD_HORARIO_P);
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
    COD_HORARIO_P NUMBER,
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
            IF COD_HORARIO_P IS NULL OR DIA_P IS NULL OR COALESCE(HORA_ENTRADA_P, HORA_SALIDA_P, INICIO_COLACION_P, TERMINO_COLACION_P) IS NULL THEN
                DBMS_OUTPUT.PUT_LINE('Error: Alguno de los parámetros contiene valores nulos.');
                CONFIRM_OUTPUT := -1;
            ELSE
                IF MMMB_EXISTE_HORARIO(COD_HORARIO_P) = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('Error: Horario no existe.');
                    CONFIRM_OUTPUT := -1;
                ELSE
                    CONFIRM_OUTPUT := MMMB_PK_TURNO.NEXTVAL;
                    INSERT INTO MMMB_TURNO 
                        VALUES(
                            CONFIRM_OUTPUT, COD_HORARIO_P, TO_DATE(DIA_P, 'DD/MM/YY'), HORA_ENTRADA_P, HORA_SALIDA_P,
                            INICIO_COLACION_P, TERMINO_COLACION_P
                        );
                END IF;
            END IF;
        WHEN 'U' THEN
            UPDATE MMMB_TURNO 
                SET DIA = TO_DATE(DIA_P, 'DD/MM/YY'),
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
/*
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
*/

-- Detalle cuadratura

CREATE OR REPLACE PROCEDURE MMMB_PROC_DETALLE_CUADRATURA(
    OPCION VARCHAR2,
    COD_DETALLE_CUADRATURA_P NUMBER,
    COD_CAJA_P NUMBER DEFAULT NULL,
    RUT_EMPLEADO_P NUMBER DEFAULT NULL,
    SALDO_INICIAL_P NUMBER DEFAULT NULL,
    VENTAS_EFECTIVO_P NUMBER DEFAULT NULL,
    SALDO_FINAL_P NUMBER DEFAULT NULL,
    DIFERENCIA_P NUMBER DEFAULT NULL,
    FECHA_P DATE DEFAULT NULL,
    CONFIRM_OUTPUT OUT NUMBER 
)
IS
BEGIN
    LOCK TABLE MMMB_DETALLE_CUADRATURA IN ROW EXCLUSIVE MODE;

    CASE OPCION
        WHEN 'I' THEN
            IF COALESCE(COD_CAJA_P, RUT_EMPLEADO_P, SALDO_INICIAL_P, VENTAS_EFECTIVO_P, SALDO_FINAL_P, DIFERENCIA_P) IS NULL THEN
                DBMS_OUTPUT.PUT_LINE('Error: Alguno de los parámetros contiene valores nulos.');
                CONFIRM_OUTPUT := -1;
            ELSE
                IF MMMB_EXISTE_CAJA(COD_CAJA_P) = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('Error: La caja no existe.');
                    CONFIRM_OUTPUT := -1;
                ELSE
                    INSERT INTO MMMB_DETALLE_CUADRATURA 
                        VALUES(MMMB_PK_DETALLE_CUADRATURA.NEXTVAL, COD_CAJA_P, RUT_EMPLEADO_P, SALDO_INICIAL_P, VENTAS_EFECTIVO_P, SALDO_FINAL_P, DIFERENCIA_P, SYSDATE);
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
                        RUT_EMPLEADO = RUT_EMPLEADO_P,
                        SALDO_INICIAL = SALDO_INICIAL_P,
                        VENTAS_EFECTIVO = VENTAS_EFECTIVO_P,
                        SALDO_FINAL = SALDO_FINAL_P,
                        DIFERENCIA = DIFERENCIA_P
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
                            TO_DATE(VALIDO_DESDE_P, 'DD/MM/YY'),
                            TO_DATE(VALIDO_HASTA_P, 'DD/MM/YY')
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
                        VALIDO_DESDE = TO_DATE(VALIDO_DESDE_P, 'DD/MM/YY'),
                        VALIDO_HASTA = TO_DATE(VALIDO_HASTA_P, 'DD/MM/YY')
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
    COD_SUCURSAL_P NUMBER DEFAULT NULL, 
    COD_CAJA_P NUMBER DEFAULT NULL,
    RUT_CLIENTE_P NUMBER DEFAULT NULL,
    RUT_EMPLEADO_P NUMBER DEFAULT NULL,
    COD_PAGO_P NUMBER DEFAULT NULL,
    TOTAL_VENTA_P NUMBER DEFAULT NULL,
    DESCUENTO_VENTA_P NUMBER DEFAULT NULL,
    CONFIRM_OUTPUT OUT NUMBER 
)
IS
BEGIN
    LOCK TABLE MMMB_VENTA IN ROW EXCLUSIVE MODE;

    CASE OPCION
        WHEN 'I' THEN
            IF COALESCE(COD_SUCURSAL_P, COD_CAJA_P, RUT_CLIENTE_P, RUT_EMPLEADO_P, COD_PAGO_P, TOTAL_VENTA_P) IS NULL THEN
                DBMS_OUTPUT.PUT_LINE('Error: Alguno de los parámetros contiene valores nulos.');
                CONFIRM_OUTPUT := -1;
            ELSE
                IF MMMB_EXISTE_SUCURSAL(COD_SUCURSAL_P) = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('Error: La sucursal no existe.');
                    CONFIRM_OUTPUT := -1;
                ELSIF MMMB_EXISTE_CAJA(COD_CAJA_P) = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('Error: La caja no existe.');
                    CONFIRM_OUTPUT := -1;
                ELSIF MMMB_EXISTE_CLIENTE(RUT_CLIENTE_P) = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('Error: El cliente no existe.');
                    CONFIRM_OUTPUT := -1;
                ELSIF MMMB_EXISTE_EMPLEADO(RUT_EMPLEADO_P) = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('Error: El empleado no existe.');
                    CONFIRM_OUTPUT := -1;
                ELSE
                    CONFIRM_OUTPUT := MMMB_PK_VENTA.NEXTVAL;
                    INSERT INTO MMMB_VENTA 
                        VALUES(
                            CONFIRM_OUTPUT,
                            COD_SUCURSAL_P,
                            COD_CAJA_P,
                            RUT_CLIENTE_P,
                            RUT_EMPLEADO_P,
                            COD_PAGO_P,
                            SYSDATE,
                            TOTAL_VENTA_P,
                            DESCUENTO_VENTA_P
                        );
                END IF;
            END IF;
        WHEN 'U' THEN -- NUNCA DEBERÍA USARSE, PORQUE NO ES LEGAL, PARA ESO, NOTAS DE CRÉDITO
            IF MMMB_EXISTE_SUCURSAL(COD_SUCURSAL_P) = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Error: La sucursal no existe.');
                CONFIRM_OUTPUT := -1;
            ELSIF MMMB_EXISTE_CAJA(COD_CAJA_P) = 0 THEN
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
                    SET COD_SUCURSAL = COD_SUCURSAL_P,
                        COD_CAJA = COD_CAJA_P,
                        RUT_CLIENTE = RUT_CLIENTE_P,
                        RUT_EMPLEADO = RUT_EMPLEADO_P,
                        COD_PAGO = COD_PAGO_P,
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

-- Trigger sobre MMMB_DETALLE_VENTA_PRODUCTO, debe capturar CANTIDAD de la venta
-- MMMB_DETALLE_SUCURSAL_PRODUCTO STOCK_SUCURSAL_PRODUCTO

CREATE OR REPLACE TRIGGER MMMB_TRG_ACTUALIZAR_STOCK
AFTER INSERT ON MMMB_DETALLE_VENTA_PRODUCTO
FOR EACH ROW
DECLARE
    v_cod_sucursal NUMBER;
BEGIN
    -- Obtener el código de sucursal desde la tabla MMMB_VENTA
    SELECT COD_SUCURSAL INTO v_cod_sucursal
    FROM MMMB_VENTA
    WHERE COD_VENTA = :NEW.COD_VENTA;

    -- Actualizar el stock en la tabla MMMB_DETALLE_SUCURSAL_PRODUCTO
    UPDATE MMMB_DETALLE_SUCURSAL_PRODUCTO
    SET STOCK_SUCURSAL_PRODUCTO = STOCK_SUCURSAL_PRODUCTO - :NEW.CANTIDAD
    WHERE COD_SUCURSAL = v_cod_sucursal AND COD_PRODUCTO = :NEW.COD_PRODUCTO;
END;
/


/*
    BASE DATA
*/

-- Inserts para añadir 2 sucursales (y 2 cajas para cada una)
INSERT INTO MMMB_SUCURSAL (COD_SUCURSAL, NOMBRE_SUCURSAL, TELEFONO_SUCURSAL)
    VALUES (1, 'Sucursal A', '+56954685222');
INSERT INTO MMMB_CAJA (COD_CAJA, COD_SUCURSAL)
    VALUES (1, 1);
INSERT INTO MMMB_CAJA (COD_CAJA, COD_SUCURSAL)
    VALUES (2, 1);

INSERT INTO MMMB_SUCURSAL (COD_SUCURSAL, NOMBRE_SUCURSAL, TELEFONO_SUCURSAL)
    VALUES (2, 'Sucursal B', '+56954685222');
INSERT INTO MMMB_CAJA (COD_CAJA, COD_SUCURSAL)
    VALUES (3, 2);
INSERT INTO MMMB_CAJA (COD_CAJA, COD_SUCURSAL)
    VALUES (4, 2);

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
        90529322,
        1, -- COD_SUCURSAL
        1, -- COD_CARGO (Dueño)
        'Juan',
        'Pérez',
        'González',
        '555-1234',
        'juan.perez@gmail.com',
        'juanperez',
        '$5$rounds=535000$3GueeYdLFXzw5iLT$MPejbFsCmthWh5r0mKd5bV1A4jJCCppegIagZqLNrp.',
        confirm_output
    );

    MMMB_PROC_EMPLEADO(
        'I',
        210463003,
        1, -- COD_SUCURSAL
        2, -- COD_CARGO (cajero)
        'Benjamin Nicolas',
        'Villablanca',
        'Zuniga',
        '968316402',
        'benjavz@gmail.com',
        'benjaminvillablanca',
        '$5$rounds=535000$3GueeYdLFXzw5iLT$MPejbFsCmthWh5r0mKd5bV1A4jJCCppegIagZqLNrp.',
        confirm_output
    );

    MMMB_PROC_EMPLEADO(
        'I',
        210463001,
        1, -- COD_SUCURSAL
        2, -- COD_CARGO (cajero)
        'Martin alfonso',
        'Ferrada',
        'Munoz',
        '555-134',
        'martin.ferrada@gmail.com',
        'martinferrada',
        '$5$rounds=535000$3GueeYdLFXzw5iLT$MPejbFsCmthWh5r0mKd5bV1A4jJCCppegIagZqLNrp.',
        confirm_output
    );

    MMMB_PROC_EMPLEADO(
        'I',
        199985819,
        2, -- COD_SUCURSAL
        2, -- COD_CARGO (cajero)
        'Andres Roberto',
        'Escalante',
        'Villegas',
        '555-124',
        'andres.escalante@gmail.com',
        'andresescalante',
        '$5$rounds=535000$3GueeYdLFXzw5iLT$MPejbFsCmthWh5r0mKd5bV1A4jJCCppegIagZqLNrp.',
        confirm_output
    );
    MMMB_PROC_EMPLEADO(
        'I',
        106474452,
        2, -- COD_SUCURSAL
        2, -- COD_CARGO (cajero)
        'Marcela',
        'Mendez',
        'Tapia',
        '555-122',
        'marcela.mendez@example.com',
        'marcelamendez',
        '$5$rounds=535000$3GueeYdLFXzw5iLT$MPejbFsCmthWh5r0mKd5bV1A4jJCCppegIagZqLNrp.',
        confirm_output
    );
    -- Insertar cliente nulo, RUT = 0, para los que no se logean
    MMMB_PROC_CLIENTE(
        'I',
        0,
        'SIN CUENTA',
        'SIN APELLIDO1',
        'SIN APELLIDO2',
        'SIN CORREO',
        confirm_output
    );

    MMMB_PROC_CLIENTE(
        'I',
        183995621,
        'Carlos Andres',
        'Castro',
        'Bustamante',
        'ccastro@gmail.com',
        confirm_output
    );
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
    MMMB_PROC_PRODUCTO('I', '', 1, 1, 'Coca-Cola Regular', 1500, 2500, 40,72, 75000001, out_val);
    MMMB_PROC_PRODUCTO('I', '', 1, 1, 'Coca-Cola Zero', 2500, 3000, 12,92, 75000001, out_val);
        -- Bebidas - Pepsi
    MMMB_PROC_PRODUCTO('I', '', 2, 1, 'Pepsi Regular', 1500, 2500, 50,47, 75000001, out_val);
    MMMB_PROC_PRODUCTO('I', '', 2, 1, 'Pepsi Max', 2500, 2800, 16,18, 75000001, out_val);
        -- Enlatados - San José
    MMMB_PROC_PRODUCTO('I', '', 3, 2, 'Atún San José', 2000, 3500, 35,80, 75000010, out_val);
    MMMB_PROC_PRODUCTO('I', '', 3, 2, 'Maíz enlatado', 1800, 2800, 99,45, 75000010, out_val);
        -- Enlatados - Robinson Crusoe
    MMMB_PROC_PRODUCTO('I', '', 4, 2, 'Sardinas kawai', 1700, 3000, 95,75, 75000010, out_val);
    MMMB_PROC_PRODUCTO('I', '', 4, 2, 'Choclo enlatado', 1900, 3200, 5,88, 75000010, out_val);
        -- Productos lácteos - Nestlé
    MMMB_PROC_PRODUCTO('I', '', 5, 3, 'Leche Nestlé', 2500, 3500, 36,45, 75000003, out_val);
    MMMB_PROC_PRODUCTO('I', '', 5, 3, 'Yogurt Nestlé', 1800, 2500, 87,78, 75000003, out_val);    
        -- Productos lácteos - Colun
    MMMB_PROC_PRODUCTO('I', '', 6, 3, 'Lache', 2200, 3000, 56,65, 75000003, out_val);
    MMMB_PROC_PRODUCTO('I', '', 6, 3, 'Queso de ayer', 3000, 4500, 12,21, 75000003, out_val);
        -- Panadería - Bimbo
    MMMB_PROC_PRODUCTO('I', '', 7, 4, 'Pan Blanco Bimbo', 1500, 2000, 85,58, 75000004, out_val);
    MMMB_PROC_PRODUCTO('I', '', 7, 4, 'Pan Integral Bimbo', 2000, 2500, 5,7, 75000004, out_val);
        -- Panadería - Ideal
    MMMB_PROC_PRODUCTO('I', '', 8, 4, 'Pan Blanco Ideal', 1800, 2200, 4,5, 75000004, out_val);
    MMMB_PROC_PRODUCTO('I', '', 8, 4, 'Pan Integral Ideal', 2200, 2800, 77,8, 75000004, out_val);
        -- Snacks - Costa
    MMMB_PROC_PRODUCTO('I', '', 9, 5, 'Papas Fritas', 1500, 2000, 98,78, 75000005, out_val);
    MMMB_PROC_PRODUCTO('I', '', 9, 5, 'Galletas Saladas', 1200, 1800, 23,54, 75000005, out_val);
        -- Snacks - Evercrisp
    MMMB_PROC_PRODUCTO('I', '', 10, 5, 'Chips HD', 2000, 2500, 78,74, 75000005, out_val);
    MMMB_PROC_PRODUCTO('I', '', 10, 5, 'Pretzels 2G', 1800, 2200, 44,55, 75000005, out_val);
        -- Cuidado personal - Dove
    MMMB_PROC_PRODUCTO('I', '', 11, 6, 'Shampoo 1L', 5000, 7000, 33,55, 75000006, out_val);
    MMMB_PROC_PRODUCTO('I', '', 11, 6, 'Acondicionador II', 4500, 6500, 23,32, 75000006, out_val);
        -- Cuidado personal - Pantene
    MMMB_PROC_PRODUCTO('I', '', 12, 6, 'Shampoo con instrucciones', 4800, 6800, 66,55, 75000006, out_val);
    MMMB_PROC_PRODUCTO('I', '', 12, 6, 'Acondicionador Palpelo', 4300, 6300, 23,56, 75000006, out_val);
        -- Limpieza - Clorox
    MMMB_PROC_PRODUCTO('I', '', 13, 7, 'Cloro 15L', 3000, 4500, 42,15, 75000007, out_val);
    MMMB_PROC_PRODUCTO('I', '', 13, 7, 'Limpiador Multiusos', 2500, 4000, 65,45, 75000007, out_val);
        -- Limpieza - Cif
    MMMB_PROC_PRODUCTO('I', '', 14, 7, 'Limpiador Baño', 2800, 4200, 32,65, 75000007, out_val);
    MMMB_PROC_PRODUCTO('I', '', 14, 7, 'Limpiador Cocina', 3200, 4800, 25,55, 75000007, out_val);
        -- Higiene - Colgate
    MMMB_PROC_PRODUCTO('I', '', 15, 8, 'Pasta Dental picante', 2000, 3500, 41,54, 75000008, out_val);
    MMMB_PROC_PRODUCTO('I', '', 15, 8, 'Cepillo Dental usado', 1500, 2800, 32,56, 75000008, out_val);
        -- Higiene - Johnson & Johnson
    MMMB_PROC_PRODUCTO('I', '', 16, 8, 'Jabón Líquido 2L', 4000, 5500, 75,85, 75000008, out_val);
    MMMB_PROC_PRODUCTO('I', '', 16, 8, 'Shampoo Bebé', 3500, 5000, 12,47, 75000008, out_val);
    -- Carnes y embutidos - Ariztía
    MMMB_PROC_PRODUCTO('I', '', 17, 9, 'Pollo fresco', 5000, 8000, 9,85, 75000010, out_val);
    MMMB_PROC_PRODUCTO('I', '', 17, 9, 'Embutidos en butido', 6000, 9000, 45,54, 75000010, out_val);
    -- Carnes y embutidos - Super Pollo
    MMMB_PROC_PRODUCTO('I', '', 18, 9, 'Pollo Super', 4500, 7500, 41,45, 75000010, out_val);
    MMMB_PROC_PRODUCTO('I', '', 18, 9, 'Embutidos embutibles', 5500, 8500, 25,21, 75000010, out_val);
    -- Artículos de Oficina - Proarte
    MMMB_PROC_PRODUCTO('I', '', 19, 10, 'Set Pinceles usados', 8000, 12000, 54,26, 75000006, out_val);
    MMMB_PROC_PRODUCTO('I', '', 19, 10, 'Bloc de Dibujo seminuevo', 6500, 10000, 12,45, 75000006, out_val);
    -- Artículos de Oficina - Torre
    MMMB_PROC_PRODUCTO('I', '', 20, 10, 'Lápices color blanco', 3000, 5000, 35,54, 75000006, out_val);
    MMMB_PROC_PRODUCTO('I', '', 20, 10, 'Libretas 50 hojas', 2500, 4000, 42,56, 75000006, out_val);
    -- Mascotas - Whiskas
    MMMB_PROC_PRODUCTO('I', '', 21, 11, 'Comida uwu', 7000, 10000, 35,56, 75000008, out_val);
    MMMB_PROC_PRODUCTO('I', '', 21, 11, 'Snacks Gatos', 4500, 7000, 24,45, 75000008, out_val);
    -- Mascotas - Master Dog
    MMMB_PROC_PRODUCTO('I', '', 22, 11, 'Comida Pa Kiltros', 8000, 12000, 35,65, 75000008, out_val);
    MMMB_PROC_PRODUCTO('I', '', 22, 11, 'Snacks Perros', 5500, 8000, 14,45, 75000008, out_val);
    -- Frutas y verduras
    MMMB_PROC_PRODUCTO('I', '', 23, 12, 'Manzana 1Kg', 500, 2100, 78,87, 75000008, out_val);
    MMMB_PROC_PRODUCTO('I', '', 23, 12, 'Tomate 1Kg', 800, 1000, 112,44, 75000008, out_val);
    MMMB_PROC_PRODUCTO('I', '', 23, 12, 'Zanahoria 1Kg', 500, 700, 41,14, 75000008, out_val);

    -- Actualización de precios (para el MMMB_HISTORIAL_PRECIOS)
    -- Coca-Cola Zero
    UPDATE MMMB_PRODUCTO SET PRECIO_VENTA = 6000 WHERE (COD_PRODUCTO = 2);
    -- Atún San José
    UPDATE MMMB_PRODUCTO SET PRECIO_COMPRA = 3000 WHERE (COD_PRODUCTO = 5);
    -- Queso de ayer
    UPDATE MMMB_PRODUCTO SET PRECIO_VENTA = 4800 WHERE (COD_PRODUCTO = 2);

    -- Descuentos

    MMMB_PROC_DESCUENTO('I', NULL, 3, 2, TO_DATE('12/12/23', 'DD/MM/YY'), TO_DATE('15/12/23', 'DD/MM/YY'), out_val);
    MMMB_PROC_DESCUENTO('I', NULL, 4, 10, TO_DATE('12/12/23', 'DD/MM/YY'), TO_DATE('15/12/23', 'DD/MM/YY'), out_val);
    MMMB_PROC_DESCUENTO('I', NULL, 4, 2, TO_DATE('12/11/23', 'DD/MM/YY'), TO_DATE('10/12/23', 'DD/MM/YY'), out_val);
    MMMB_PROC_DESCUENTO('I', NULL, 4, 7, TO_DATE('12/12/23', 'DD/MM/YY'), TO_DATE('25/12/23', 'DD/MM/YY'), out_val);
    MMMB_PROC_DESCUENTO('I', NULL, 5, 6, TO_DATE('12/12/23', 'DD/MM/YY'), TO_DATE('25/12/23', 'DD/MM/YY'), out_val);
    MMMB_PROC_DESCUENTO('I', NULL, 6, 15, TO_DATE('12/12/23', 'DD/MM/YY'), TO_DATE('25/12/23', 'DD/MM/YY'), out_val);

END;
/
----