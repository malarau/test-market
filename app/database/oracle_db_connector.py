import datetime
import oracledb
from datetime import datetime

class OracleDBConnector:
    _instance = None

    #
    # DOCUMENTACIÓN:
    #          https://python-oracledb.readthedocs.io/en/latest/index.html
    #    

    def __new__(cls, username, password, connect_string, mode=oracledb.SYSDBA):
        #print(F'username, password, connect_string: {(username, password, connect_string)}')
        print(F'username, password, connect_string: OCULTO (100% SEGURO)')
        if not cls._instance:
            cls._instance = super(OracleDBConnector, cls).__new__(cls)
            cls._instance._username = username
            cls._instance._password = password
            cls._instance._connect_string = connect_string
            cls._instance._mode = mode
            cls._instance._pool = oracledb.create_pool(
                user=username,
                password=password,
                dsn=connect_string,
                min=1,
                max=2,
                increment=1
            )
        return cls._instance

    # EJECUTA UNA QUERY PARA TRAER COSAS
    def execute_query(self, query, *args):
        try:
            with self._pool.acquire() as connection:
                with connection.cursor() as cursor:
                    cursor.execute(query, args)
                    result = cursor.fetchall()                    
                    return result
        except Exception as e:
            print(f"Error executing query: {e}")
            return -1
        
    # EJECUTA UNA QUERY PARA INSERTAR COSAS, IMAGINO QUE FUNCIONA PARA UPDATE
    # TODO: NO USAR ESTO, CREAR PROCEDIMIENTOS ESPECIALES
    def execute_insert(self, query, *args):
        try:
            with self._pool.acquire() as connection:
                with connection.cursor() as cursor:
                    cursor.execute(query, args)
                    connection.commit()  # MUCHO MUY IMPORTANTE
        except Exception as e:
            print(f"Error executing insert: {e}")

    ########

    def get_user_by_id(self, id):
        query = "SELECT * FROM USUARIO WHERE username = :1"
        print("query: ", query)
        return self.execute_query(query, id)

    def get_user_by_username(self, username):
        query = "SELECT USUARIO_EMPLEADO FROM MMMB_EMPLEADO WHERE USUARIO_EMPLEADO = :1"
        print("query: ", query)
        return self.execute_query(query, username)
    
    def get_cargo_by_user(self, username):
        query = "SELECT COD_CARGO FROM MMMB_EMPLEADO WHERE USUARIO_EMPLEADO = :1"
        return self.execute_query(query, username)
    def get_rut_by_user(self, username):
        query = "SELECT RUT_EMPLEADO FROM MMMB_EMPLEADO WHERE USUARIO_EMPLEADO = :1"
        return self.execute_query(query, username)
    def get_sucursal_by_user(self, username):
        query = "SELECT COD_SUCURSAL FROM MMMB_EMPLEADO WHERE USUARIO_EMPLEADO = :1"
        return self.execute_query(query, username)
    def get_caja_by_sucursal(self, sucursal):
        query = "SELECT COD_CAJA FROM MMMB_CAJA WHERE COD_SUCURSAL = :1"
        return self.execute_query(query, sucursal)
    
    def get_hash_by_username(self, username):
        query = "SELECT CONTRASEÑA_EMPLEADO FROM MMMB_EMPLEADO WHERE USUARIO_EMPLEADO = :1"
        print("query: ", query)
        return self.execute_query(query, username)
    
    # USO DE PROCEDIMIENTO
    def crear_usuario(self, username, email, password):
        try:
            with self._pool.acquire() as connection:
                with connection.cursor() as cursor:

                    out_val = cursor.var(int)
                    
                    cursor.callproc('proc_crear_usuario', [username, email, password, out_val])

                    result = out_val.getvalue()              
                    return result
        except Exception as e:
            print(f"Error executing query: {e}")
            return None

    def agregar_empleado(self,opcion, rut,cod_sucursal,cargo,nombre_empleado,apellido1,apellido2,Telefono,Email,user,passwd):
        try:
            with self._pool.acquire() as connection:
                with connection.cursor() as cursor:
  
                    out_val = cursor.var(int)
                    
                    cursor.callproc('MMMB_PROC_EMPLEADO', [opcion,rut,cod_sucursal,cargo,nombre_empleado,apellido1,apellido2,Telefono,Email,user,passwd,out_val])

                    result = out_val.getvalue()              
                    return result
        except Exception as e:
            print(f"Error executing query: {e}")
            return None
    
    # Productos
    def get_all_products(self):
        query = "SELECT P.COD_PRODUCTO,P.COD_MARCA,P.COD_CATEGORIA,P.NOMBRE_PRODUCTO,P.PRECIO_COMPRA,P.PRECIO_VENTA,SUM(D.STOCK_SUCURSAL_PRODUCTO) AS STOCK_PRODUCTO,P.RUT_PROVEEDOR FROM MMMB_PRODUCTO P JOIN MMMB_DETALLE_SUCURSAL_PRODUCTO D ON P.COD_PRODUCTO = D.COD_PRODUCTO GROUP BY P.COD_PRODUCTO, P.COD_MARCA, P.COD_CATEGORIA, P.NOMBRE_PRODUCTO, P.PRECIO_COMPRA, P.PRECIO_VENTA, P.RUT_PROVEEDOR"
        return self.execute_query(query)
    
    # "cod_producto, nombre_producto, precio_venta, %_descuento"
    #       OBVIAMENTE QUEDARÍA MÁS LINDO SI SE SACARA DE AQUÍ O SE ORDENADA COMO TOOOODO LO DE ESTE ARCHIVO, PA LA OTRA A MENOS QUE DEJE LA CARRERA
    def get_all_concat_products_with_discounts(self):
        query = "SELECT P.COD_PRODUCTO || ',' || REPLACE(P.NOMBRE_PRODUCTO, ',', '') || ',' || P.PRECIO_VENTA || ',' || COALESCE(SUM(D.PORCENTAJE_DESCUENTO), 0) AS SUMA_DESCUENTOS FROM MMMB_PRODUCTO P LEFT JOIN MMMB_DESCUENTO D ON P.COD_PRODUCTO = D.COD_PRODUCTO AND VALIDO_DESDE <= SYSDATE AND VALIDO_HASTA >= SYSDATE GROUP BY P.COD_PRODUCTO, P.NOMBRE_PRODUCTO, P.PRECIO_VENTA"
        return self.execute_query(query)

    def get_all_employees(self):
        query = "SELECT * FROM MMMB_EMPLEADO"
        return self.execute_query(query)
    
    def get_product_by_cod(self, COD):
        query = "SELECT COD_PRODUCTO, COD_MARCA, COD_CATEGORIA, NOMBRE_PRODUCTO, PRECIO_COMPRA, PRECIO_VENTA, (SELECT SUM(STOCK_SUCURSAL_PRODUCTO) FROM MMMB_DETALLE_SUCURSAL_PRODUCTO WHERE COD_PRODUCTO = :1) STOCK_PRODUCTO, RUT_PROVEEDOR FROM MMMB_PRODUCTO WHERE COD_PRODUCTO = :1"
        return self.execute_query(query, COD, COD)
    
    def get_stock_sucursales_by_cod_producto(self, COD):
        query = "SELECT STOCK_SUCURSAL_PRODUCTO FROM MMMB_DETALLE_SUCURSAL_PRODUCTO WHERE COD_PRODUCTO = :1"
        return self.execute_query(query, COD)
    
    def get_employee_by_rut(self, RUT):
        query = "SELECT * FROM MMMB_EMPLEADO WHERE RUT_EMPLEADO = :1"
        return self.execute_query(query, RUT)
    # MAL, USAR PROCEDIMIENTO

    def actualizar_empleado(self,opcion, rut,cod_sucursal,cargo,nombre_empleado,apellido1,apellido2,Telefono,Email,Usuario,contraseña):
        try:
            with self._pool.acquire() as connection:
                with connection.cursor() as cursor:

                    out_val = cursor.var(int)
                    
                    cursor.callproc('MMMB_PROC_EMPLEADO',[opcion,int(rut),int(cod_sucursal),int(cargo),nombre_empleado,apellido1,apellido2,Telefono,Email,Usuario,contraseña,out_val])

                    result = out_val.getvalue()              
                    return result
        except Exception as e:
            print(f"Error executing query: {e}")
            return None
           
    def eliminar_empleado(self,opcion,rut):
        try:
            with self._pool.acquire() as connection:
                with connection.cursor() as cursor:

                    out_val = cursor.var(int)
                    
                    cursor.callproc('MMMB_PROC_EMPLEADO', [opcion,rut,None,None,None,None,None,None,None,None,None,out_val])

                    result = out_val.getvalue()              
                    return result
        except Exception as e:
            print(f"Error executing query: {e}")
            return None
            
     # MALO MALO, VALIDAR ANTES
    
    def agregar_producto(self,cod_marca,cod_categoria,nombre_producto,precio_compra,precio_venta,stock_s1, stock_s2,rut_proveedor):
        try:
            result = 1
            with self._pool.acquire() as connection:
                with connection.cursor() as cursor:

                    args = [cod_marca,cod_categoria,nombre_producto,precio_compra,precio_venta,stock_s1, stock_s2,rut_proveedor]
                    for a in args:
                        print(a)

                    out_val = cursor.var(int)
                    
                    cursor.callproc('MMMB_PROC_PRODUCTO', ['I', None, int(cod_marca),int(cod_categoria),nombre_producto,int(precio_compra),int(precio_venta),int(stock_s1),int(stock_s2),int(rut_proveedor), out_val])

                    result = out_val.getvalue()              
                    return result
        except Exception as e:
            print(f"Error executing query: {e}")
            return result  

    def modificar_producto(self,cod_producto, cod_marca,cod_categoria,nombre_producto,precio_compra,precio_venta,stock_s1, stock_s2,rut_proveedor):
        try:
            result = 1
            with self._pool.acquire() as connection:
                with connection.cursor() as cursor:

                    args = [cod_marca,cod_categoria,nombre_producto,precio_compra,precio_venta,stock_s1, stock_s2,rut_proveedor]
                    for a in args:
                        print(type(a))

                    out_val = cursor.var(int)
                    
                    cursor.callproc(
                        'MMMB_PROC_PRODUCTO',
                        ['U', cod_producto, int(cod_marca),int(cod_categoria),nombre_producto,int(precio_compra),int(precio_venta),int(stock_s1),int(stock_s2),int(rut_proveedor), out_val])

                    """
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
                    """

                    result = out_val.getvalue()              
                    return result
        except Exception as e:
            print(f"Error executing query: {e}")
            return result        
    
    def eliminar_producto(self, cod_producto):
        try:
            with self._pool.acquire() as connection:
                result = 1
                with connection.cursor() as cursor:

                    out_val = cursor.var(int)
                    
                    cursor.callproc(
                        'MMMB_PROC_PRODUCTO',
                        ['D', cod_producto, None,None,None,None,None,None,None,None, out_val])

                    result = out_val.getvalue()              
                    return result
        except Exception as e:
            print(f"Error executing query: {e}")
            return result

    def get_all_sucursals(self):
        query = "SELECT * FROM MMMB_SUCURSAL"
        return self.execute_query(query)
    def get_cod_sucursals(self):
        query = "SELECT COD_SUCURSAL FROM MMMB_SUCURSAL"
        return self.execute_query(query)
    
    def agregar_cliente(self,opcion, rut_cliente, nombre_cliente, apellido1_cliente, apellido2_cliente, correo_cliente):
            try:
                with self._pool.acquire() as connection:
                    with connection.cursor() as cursor:
                        out_val = cursor.var(int)
                        # No necesitas una variable de salida (out_val) en este caso
                        cursor.callproc('MMMB_PROC_CLIENTE', [opcion,int(rut_cliente), nombre_cliente, apellido1_cliente, apellido2_cliente, correo_cliente,out_val])

                        result = out_val.getvalue()              
                    return result

            except Exception as e:
                print(f"Error executing query: {e}")
                return None
            
    def eliminar_cliente(self,opcion, rut_cliente):
        try:
            with self._pool.acquire() as connection:
                with connection.cursor() as cursor:
                    out_val = cursor.var(int)
                    cursor.callproc('MMMB_PROC_CLIENTE', [opcion,int(rut_cliente),None,None,None,None,out_val])
                    result = out_val.getvalue()
                    return result
        except Exception as e:
            print(f"Error executing query: {e}")
            return None
        
    def actualizar_cliente(self,opcion, rut, nombre_cliente, apellido1_cliente, apellido2_cliente, correo_cliente):
        try:
            with self._pool.acquire() as connection:
                with connection.cursor() as cursor:

                    out_val = cursor.var(int)
                    
                    cursor.callproc('MMMB_PROC_CLIENTE',[opcion,int(rut),nombre_cliente, apellido1_cliente, apellido2_cliente, correo_cliente,out_val])

                    result = out_val.getvalue()              
                    return result
        except Exception as e:
            print(f"Error executing query: {e}")
            return None
    
    
    def agregar_marca(self,opcion, nombre):
        try:
            with self._pool.acquire() as connection:
                with connection.cursor() as cursor:
                    out_val = cursor.var(int)
                    cursor.callproc('MMMB_PROC_MARCA', [opcion,221334,nombre,out_val])
                    result = out_val.getvalue()              
                return result

        except Exception as e:
            print(f"Error executing query: {e}")
            return None
            
    def actualizar_marca(self, opcion, cod_marca, nombre_marca):
        try:
            with self._pool.acquire() as connection:
                with connection.cursor() as cursor:
                    out_val = cursor.var(int)

                    cursor.callproc('MMMB_PROC_MARCA', [opcion, int(cod_marca), nombre_marca, out_val])

                    result = out_val.getvalue()
                    return result
        except Exception as e:
            print(f"Error executing query: {e}")
            return None
    
    def eliminar_marca(self, opcion, cod_marca):
        try:
            with self._pool.acquire() as connection:
                with connection.cursor() as cursor:
                    out_val = cursor.var(int)

                    cursor.callproc('MMMB_PROC_MARCA', [opcion, int(cod_marca), None, out_val])

                    result = out_val.getvalue()
                    return result
        except Exception as e:
            print(f"Error executing query: {e}")
            return None

    def agregar_categoria(self,opcion, nombre):
        try:
            with self._pool.acquire() as connection:
                with connection.cursor() as cursor:
                    out_val = cursor.var(int)
                    cursor.callproc('MMMB_PROC_categoria', [opcion,221334,nombre,out_val])
                    result = out_val.getvalue()              
                return result

        except Exception as e:
            print(f"Error executing query: {e}")
            return None
            
    def actualizar_categoria(self, opcion, cod_categoria, nombre_categoria):
        try:
            with self._pool.acquire() as connection:
                with connection.cursor() as cursor:
                    out_val = cursor.var(int)

                    cursor.callproc('MMMB_PROC_categoria', [opcion, int(cod_categoria), nombre_categoria, out_val])

                    result = out_val.getvalue()
                    return result
        except Exception as e:
            print(f"Error executing query: {e}")
            return None
    
    def eliminar_categoria(self, opcion, cod_categoria):
        try:
            with self._pool.acquire() as connection:
                with connection.cursor() as cursor:
                    out_val = cursor.var(int)

                    cursor.callproc('MMMB_PROC_CATEGORIA', [opcion, int(cod_categoria), None, out_val])

                    result = out_val.getvalue()
                    return result
        except Exception as e:
            print(f"Error executing query: {e}")
            return None
    
    def agregar_proveedor(self, opcion, rut_proveedor, nombre_proveedor, correo_proveedor, telefono_proveedor):
        try:
            with self._pool.acquire() as connection:
                with connection.cursor() as cursor:
                    out_val = cursor.var(int)
                    cursor.callproc('MMMB_PROC_PROVEEDOR', [opcion, int(rut_proveedor), nombre_proveedor, correo_proveedor, telefono_proveedor, out_val])

                    result = out_val.getvalue()
                    return result

        except Exception as e:
            print(f"Error executing query: {e}")
            return None

    def eliminar_proveedor(self, opcion, rut_proveedor):
        try:
            with self._pool.acquire() as connection:
                with connection.cursor() as cursor:
                    out_val = cursor.var(int)
                    cursor.callproc('MMMB_PROC_PROVEEDOR', [opcion, int(rut_proveedor), None, None, None, out_val])
                    result = out_val.getvalue()
                    return result

        except Exception as e:
            print(f"Error executing query: {e}")
            return None
    
    def actualizar_proveedor(self, opcion, rut_proveedor, nombre_proveedor, correo_proveedor, telefono_proveedor):
        try:
            with self._pool.acquire() as connection:
                with connection.cursor() as cursor:
                    out_val = cursor.var(int)
                    cursor.callproc('MMMB_PROC_PROVEEDOR', [opcion, int(rut_proveedor), nombre_proveedor, correo_proveedor, telefono_proveedor, out_val])

                    result = out_val.getvalue()
                    return result

        except Exception as e:
            print(f"Error executing query: {e}")
            return None
        
    #
    #   Horario
    #
    def agregar_horario(self, opcion, rut_empleado, fecha_inicio, turnos):
        try:
            with self._pool.acquire() as connection:
                with connection.cursor() as cursor:
                    out_val = cursor.var(int)
                    connection.autocommit = False

                    cursor.callproc('MMMB_PROC_HORARIO', [opcion, None, rut_empleado, fecha_inicio, out_val])
                    cod_horario = out_val.getvalue()
                    if cod_horario < 0: # Es un error!
                        connection.autocommit = True
                        connection.rollback() # No tiene sentido
                        return out_val
                    else:
                        result = 1
                        for turno in turnos:
                            print("turno:", turno)
                            print("Combine:", datetime.datetime.combine(turno['fecha'], turno['hora_entrada'])) 
                            cursor.callproc('MMMB_PROC_TURNO', 
                                [opcion, 
                                 None,
                                 cod_horario,
                                 turno['fecha'],
                                 datetime.datetime.combine(turno['fecha'], turno['hora_entrada']).replace(microsecond=0),
                                 datetime.datetime.combine(turno['fecha'], turno['hora_salida']).replace(microsecond=0),
                                 datetime.datetime.combine(turno['fecha'], turno['inicio_colacion']).replace(microsecond=0),
                                 datetime.datetime.combine(turno['fecha'], turno['termino_colacion']).replace(microsecond=0),
                                 out_val])
                            result = out_val.getvalue()
                            if result < 0: # Es un error!
                                connection.rollback() # No tiene sentido

                        connection.autocommit = True
                        connection.commit() # No tiene sentido
                    return result

        except Exception as e:
            print(f"Error executing query: {e}")
            return -1
        
    def eliminar_horario(self, opcion, cod_horario):
        try:
            result = 1
            with self._pool.acquire() as connection:
                with connection.cursor() as cursor:
                    out_val = cursor.var(int)
                    cursor.callproc('MMMB_PROC_HORARIO', [opcion, int(cod_horario), None, None, out_val])
                    result = out_val.getvalue()
                    return result

        except Exception as e:
            print(f"Error executing query: {e}")
            return -1

    #
    #   VENTA
    #

    """
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
    """
    def agregar_venta(self, cod_sucursal, cod_caja, rut_cliente, rut_empleado, cod_medio_de_pago, total, detalles_venta):

        try:
            with self._pool.acquire() as connection:
                with connection.cursor() as cursor:
                    out_val = cursor.var(int)
                    connection.autocommit = False

                    # 1.- Ingresar venta MMMB_VENTA creando un procedimiento (para calcular descuentos dentro)
                        # FECHA_VENTA = SYSDATE
                        # DESCUENTO_VENTA = Calcular diferencia entre precio_venta y subtotal para cada item de form.detalles.data
                    total = 0
                    total_con_descuento = 0
                    for detalle in detalles_venta:
                        total += int(detalle['producto'])*int(detalle['cantidad'])
                        total_con_descuento += int(detalle['subtotal'])

                    diferencia_total_descuento = total - total_con_descuento

                    cursor.callproc('MMMB_PROC_VENTA', ['I', None, int(cod_sucursal), int(cod_caja), int(rut_cliente), int(rut_empleado), int(cod_medio_de_pago), int(total), diferencia_total_descuento, out_val])

                    cod_result = out_val.getvalue()
                    print("cod_result", cod_result)
                    if cod_result < 0:
                        return cod_result
                    
                    """
                            COD_VENTA NUMBER,
                            COD_PRODUCTO NUMBER,
                            CANTIDAD NUMBER
                    """
                    # 2.- Ingresar detalles de venta MMMB_DETALLE_VENTA_PRODUCTO (un FOR sobre detalles_venta)
                    for detalle in detalles_venta:
                        query = "INSERT INTO MMMB_DETALLE_VENTA_PRODUCTO VALUES(:1, :2, :3)"
                        cursor.execute(query, (cod_result, int(detalle['cod_producto']), int(detalle['cantidad'])))

                    # 3.- Trigges para disminuir stock según sucursal -----> OK
                        # Trigger sobre MMMB_DETALLE_VENTA_PRODUCTO que modifican MMMB_DETALLE_SUCURSAL_PRODUCTO
                        # Usar :NEW para obtener cod_venta
 
                    # 4.- Rezar y esperar que salga todo bien
                    
                    connection.autocommit = True
                    connection.commit() # No tiene sentido
                    return cod_result

        except Exception as e:
            print(f"Error executing query: {e}")
            return -1

    def agregar_descuento(self, opcion, cod_descuento, cod_producto, porcentaje_descuento, valido_desde, valido_hasta):
        try:
            with self._pool.acquire() as connection:
                with connection.cursor() as cursor:
                    out_val = cursor.var(int)

                    # Ajustar formato de fechas


                    cursor.callproc('MMMB_PROC_DESCUENTO', [opcion, cod_descuento, int(cod_producto), porcentaje_descuento, valido_desde, valido_hasta, out_val])

                    result = out_val.getvalue()
                return result
        except Exception as e:
            print(f"Error executing query: {e}")
            return None


    def eliminar_descuento(self, opcion, cod_descuento):
        try:
            with self._pool.acquire() as connection:
                with connection.cursor() as cursor:
                    out_val = cursor.var(int)
                    cursor.callproc('MMMB_PROC_DESCUENTO', [opcion, int(cod_descuento), None, None, None, None, out_val])
                    result = out_val.getvalue()
                return result
        except Exception as e:
            print(f"Error executing query: {e}")
            return None

    def actualizar_descuento(self, cod_descuento, cod_producto, porcentaje_descuento, valido_desde, valido_hasta):
        try:
            with self._pool.acquire() as connection:
                with connection.cursor() as cursor:
                    out_val = cursor.var(int)
                    print(["U", int(cod_descuento), int(cod_producto), int(porcentaje_descuento), valido_desde, valido_hasta, out_val])
                    cursor.callproc('MMMB_PROC_DESCUENTO', ["U", int(cod_descuento), int(cod_producto), int(porcentaje_descuento), valido_desde, valido_hasta, out_val])


                    result = out_val.getvalue()
                return result
        except Exception as e:
            print(f"Error executing query: {e}")
            return None
    def agregar_cuadratura(self, cod_caja, rut_empleado,saldo_inicial,venta_efectivo,saldo_final,diferencia):
        print(int(cod_caja), int(rut_empleado), int(saldo_inicial), int(venta_efectivo),int(saldo_final),int(diferencia))
        try:
            with self._pool.acquire() as connection:
                with connection.cursor() as cursor:
                    out_val = cursor.var(int)
                    cursor.callproc('MMMB_PROC_DETALLE_CUADRATURA', ['I', None, int(cod_caja), int(rut_empleado), int(saldo_inicial), int(venta_efectivo),int(saldo_final),int(diferencia),None,out_val])

                    result = out_val.getvalue()
                    return result

        except Exception as e:
            print(f"Error executing query: {e}")
            return None
        
    # Get all    
    def get_all_clients(self):
        query = "SELECT * FROM MMMB_CLIENTE"
        return self.execute_query(query)
    def get_all_providers(self):
        query = "SELECT * FROM MMMB_PROVEEDOR"
        return self.execute_query(query)
    def get_all_cargos(self):
        query = "SELECT * FROM MMMB_CARGO"
        return self.execute_query(query)
    def get_all_marcas(self):
        query = "SELECT * FROM MMMB_MARCA"
        return self.execute_query(query)
    def get_all_categorias(self):
        query = "SELECT * FROM MMMB_CATEGORIA"
        return self.execute_query(query)
    def get_all_bodegas(self):
        query = "SELECT * FROM MMMB_BODEGA"
        return self.execute_query(query)
    def get_all_medio_de_pago(self):
        query = "SELECT * FROM MMMB_MEDIO_PAGO"
        return self.execute_query(query)
    def get_all_horarios_y_turnos(self, RUT, limite):
        if limite == False:
            horarios_result = self.get_horarios_by_rut(RUT)
        else:
            horarios_result = self.get_last_5_horarios_by_rut(RUT)
        horarios = []
        for horario in horarios_result:
            horario = list(horario)
            # Obtener turnos
            turnos = self.get_turnos_by_cod_horario(horario[0])
            horario.append(list(turnos))
            # Añadir
            horarios.append(horario)
            
        return horarios
    def get_all_descuentos(self):
        query = "SELECT * FROM MMMB_DESCUENTO"
        return self.execute_query(query)
    
    # Get by Id
    def get_categoria_by_cod(self, COD):
        query = "SELECT * FROM MMMB_CATEGORIA WHERE COD_CATEGORIA = :1"
    
    def get_marca_by_cod(self, RUT):
        query = "SELECT * FROM MMMB_MARCA WHERE COD_MARCA = :1"
        return self.execute_query(query, RUT)
    def get_cliente_by_rut(self, RUT):
        query = "SELECT * FROM MMMB_CLIENTE WHERE RUT_CLIENTE = :1"
        return self.execute_query(query, RUT)
    def get_proveedor_by_rut(self, RUT):
        query = "SELECT * FROM MMMB_PROVEEDOR WHERE RUT_PROVEEDOR = :1"
        return self.execute_query(query, RUT)
    def get_turnos_by_cod_horario(self, COD_HORARIO):
        query = "SELECT * FROM MMMB_TURNO WHERE COD_HORARIO = :1"
        return self.execute_query(query, COD_HORARIO)
    def get_horarios_by_rut(self, RUT):
        query = "SELECT * FROM MMMB_HORARIO WHERE RUT_EMPLEADO = :1"
        return self.execute_query(query, RUT)
    def get_last_5_horarios_by_rut(self, RUT):
        query = "SELECT COD_HORARIO, RUT_EMPLEADO, FECHA_INICIO FROM MMMB_HORARIO WHERE RUT_EMPLEADO = :1 ORDER BY FECHA_INICIO DESC FETCH FIRST 5 ROWS ONLY"
        return self.execute_query(query, RUT)
    
    # Nuevamente, podría existir una función general a la que le enviemos los prámetros, pero pa la otra
    #
    #   1   Hay stock
    #   2   No alcanza
    def validar_stock(self, sucursal, cod_producto, cantidad):
        try:
            with self._pool.acquire() as connection:
                with connection.cursor() as cursor:
                    return_val = cursor.callfunc("MMMB_VALIDAR_STOCK", int, [sucursal, cod_producto, cantidad])           
                    return return_val
        except Exception as e:
            print(f"Error executing query: {e}")
            return -1
        
    def ventas_hoy(self):
        try:
            with self._pool.acquire() as connection:
                with connection.cursor() as cursor:
                    return_val = cursor.callfunc("MMMB_TOTAL_VENTAS_HOY", int)           
                    return return_val
        except Exception as e:
            print(f"Error executing query: {e}")
            return -1
    def descuentos_hoy(self):
        try:
            with self._pool.acquire() as connection:
                with connection.cursor() as cursor:
                    return_val = cursor.callfunc("MMMB_SUMAR_DESCUENTOS_HOY", int)           
                    return return_val
        except Exception as e:
            print(f"Error executing query: {e}")
            return -1
    def get_descuento_by_cod(self, COD):
        query="SELECT * FROM MMMB_DESCUENTO WHERE COD_DESCUENTO = :1"
        return self.execute_query(query, COD)
    
    def get_productos_en_bajo_stock_by_sucursal(self, cod_sucursal):
        query = "SELECT P.COD_PRODUCTO, P.NOMBRE_PRODUCTO, DS.STOCK_SUCURSAL_PRODUCTO, P.PRECIO_COMPRA, P.PRECIO_VENTA FROM MMMB_PRODUCTO P JOIN MMMB_DETALLE_SUCURSAL_PRODUCTO DS ON P.COD_PRODUCTO = DS.COD_PRODUCTO WHERE DS.COD_SUCURSAL = :1 ORDER BY DS.STOCK_SUCURSAL_PRODUCTO ASC FETCH FIRST 5 ROWS ONLY"
        return self.execute_query(query, cod_sucursal)
    
    def get_historial_precios_con_variacion(self, TIPO_PRECIO):
        query = "SELECT P.COD_PRODUCTO,P.NOMBRE_PRODUCTO,H.TIPO_PRECIO,H.VALOR_ANTERIOR,H.VALOR_NUEVO,H.FECHA,MMMB_CALCULAR_DIFERENCIA_PORCENTUAL(H.VALOR_ANTERIOR, H.VALOR_NUEVO) AS DIFERENCIA_PORCENTUAL FROM MMMB_HISTORIAL_PRECIOS H JOIN MMMB_PRODUCTO P ON H.COD_PRODUCTO = P.COD_PRODUCTO WHERE H.TIPO_PRECIO = :1"
        return self.execute_query(query, TIPO_PRECIO)
    
    def get_ventas_ultima_semana_by_sucursal(self, cod_sucursal):
        query = "SELECT COD_VENTA,COD_SUCURSAL,COD_CAJA,RUT_CLIENTE,RUT_EMPLEADO,COD_PAGO,FECHA_VENTA,TOTAL_VENTA,DESCUENTO_VENTA FROM MMMB_VENTA WHERE FECHA_VENTA >= SYSDATE - 7 AND FECHA_VENTA < SYSDATE AND COD_SUCURSAL = :1"
        return self.execute_query(query, cod_sucursal)

    def get_cuadratura(self, cod_sucursal,cod_caja):
        query = "SELECT COD_VENTA,COD_SUCURSAL,COD_CAJA,RUT_CLIENTE,RUT_EMPLEADO,COD_PAGO,FECHA_VENTA,TOTAL_VENTA,DESCUENTO_VENTA FROM MMMB_VENTA WHERE FECHA_VENTA >= SYSDATE - 7 AND FECHA_VENTA < SYSDATE AND COD_SUCURSAL = :1"
        return self.execute_query(query,cod_caja)
    # def agregar_cuadratura(self,)

    def get_total_venta_efectivo_by_caja(self, cod_caja):
        query = "SELECT SUM(total_venta) FROM MMMB_VENTA WHERE COD_CAJA = :1 AND COD_PAGO = 1 AND FECHA_VENTA LIKE SYSDATE"
        return self.execute_query(query,cod_caja)

    def get_all_cuadraturas_by_caja(self, cod_caja):
        query = "SELECT * FROM MMMB_DETALLE_CUADRATURA WHERE COD_CAJA = :1"
        return self.execute_query(query,cod_caja)

