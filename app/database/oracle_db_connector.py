import oracledb

class OracleDBConnector:
    _instance = None

    def __new__(cls, username, password, connect_string, mode=oracledb.SYSDBA):
        print(F'username, password, connect_string: {(username, password, connect_string)}')
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
            return None
        
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
        query = "SELECT * FROM USUARIO WHERE username = :1"
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
                    print(type(opcion))
                    print(type(rut))
                    print(type(cod_sucursal))
                    print(type(cargo))
                    print(type(nombre_empleado))
                    print(type(apellido1))
                    print(type(apellido2))
                    print(type(Telefono))
                    print(type(Email))
                    out_val = cursor.var(int)
                    
                    cursor.callproc('MMMB_PROC_EMPLEADO', [opcion,rut,cod_sucursal,cargo,nombre_empleado,apellido1,apellido2,Telefono,Email,user,passwd,out_val])

                    result = out_val.getvalue()              
                    return result
        except Exception as e:
            print(f"Error executing query: {e}")
            return None
    
    # Productos
    def get_all_products(self):
        query = "SELECT * FROM MMMB_PRODUCTO"
        return self.execute_query(query)
    
    def get_all_employees(self):
        query = "SELECT * FROM MMMB_EMPLEADO"
        return self.execute_query(query)
    
   
    
    
    def get_product_by_cod(self, COD):
        query = "SELECT * FROM MMMB_PRODUCTO WHERE COD_PRODUCTO = :1"
        return self.execute_query(query, COD)
    
    def get_employee_by_rut(self, RUT):
        query = "SELECT * FROM MMMB_EMPLEADO WHERE RUT_EMPLEADO = :1"
        return self.execute_query(query, RUT)
    # MAL, USAR PROCEDIMIENTO
    def update_product(self, nombre, nuevo_nombre, nueva_cantidad, nueva_marca):
        query = "UPDATE PRODUCTOS SET nombre = :2, cantidad = :3, marca = :4 WHERE nombre = :1"
        return self.execute_insert(query, nombre, nuevo_nombre, nueva_cantidad, nueva_marca)

    def actualizar_empleado(self, rut,cod_sucursal,cargo,nombre_empleado,apellido1,apellido2,Telefono,Email,Usuario,contraseña):
            try:
                with self._pool.acquire() as connection:
                    with connection.cursor() as cursor:

                        out_val = cursor.var(int)
                        
                        cursor.callproc('MMMB_UPDATE_EMPLEADO', [rut,cod_sucursal,cargo,nombre_empleado,apellido1,apellido2,Telefono,Email,Usuario,contraseña])

                        result = out_val.getvalue()              
                        return result
            except Exception as e:
                print(f"Error executing query: {e}")
                return None
    def eliminar_empleado(self, rut):
            try:
                with self._pool.acquire() as connection:
                    with connection.cursor() as cursor:

                        out_val = cursor.var(int)
                        
                        cursor.callproc('MMMB_DELETE_EMPLEADO', [rut])

                        result = out_val.getvalue()              
                        return result
            except Exception as e:
                print(f"Error executing query: {e}")
                return None
            
            
    def eliminar_producto(self, codigo):
            try:
                with self._pool.acquire() as connection:
                    with connection.cursor() as cursor:

                        out_val = cursor.var(int)
                        
                        cursor.callproc('MMMB_DELETE_producto', [codigo])

                        result = out_val.getvalue()              
                        return result
            except Exception as e:
                print(f"Error executing query: {e}")
                return None
            
     # MALO MALO, VALIDAR ANTES
    
    def agregar_producto(self,cod_marca,cod_categoria,nombre_producto,precio_compra,precio_venta,stock_producto,rut_proveedor,cod_lote ):
            try:
                with self._pool.acquire() as connection:
                    with connection.cursor() as cursor:

                        out_val = cursor.var(int)
                        
                        cursor.callproc('MMMB_CARGA_PRODUCTO', [cod_marca,cod_categoria,nombre_producto,precio_compra,precio_venta,stock_producto,rut_proveedor,cod_lote])

                        result = out_val.getvalue()              
                        return result
            except Exception as e:
                print(f"Error executing query: {e}")
                return None        
    
    def get_all_sucursals(self):
        query = "SELECT * FROM MMMB_SUCURSAL"
        return self.execute_query(query)
    def get_cod_sucursals(self):
        query = "SELECT COD_SUCURSAL FROM MMMB_SUCURSAL"
        return self.execute_query(query)