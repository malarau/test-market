from flask import current_app, redirect, render_template, request, session, url_for
from app import app
from app.forms import * #AgregarProducto, CreateAccountForm, LoginForm, ModificarProductoForm, AgregarEmpleado


class MyForm(FlaskForm):
    choices = [('opcion1', 'Opción 1'), ('opcion2', 'Opción 2')]
    select_field = SelectField('Selecciona una opción', choices=choices)

@app.route('/')
def index():
    # DB Conn
    oracle_db_connector = current_app.config['oracle_db_connector']
    # Locate user
    username = None
    if 'username' in session:
        username = session['username']

    # Lógica de la ruta de la página de inicio
    return render_template('index.html', username=username)

@app.route('/logout')
def logout():
    session.pop('username', None)
    return redirect(url_for('index'))

@app.route('/productos', methods=['GET', 'POST'])
def productos():

    # Si no está logeado, chao!
    #if not 'username' in session:
    #    return redirect(url_for('index'))
    
    agregar_producto_form = AgregarProducto()
    # DB Conn
    oracle_db_connector = current_app.config['oracle_db_connector']

    if request.method == 'POST' and agregar_producto_form.validate_on_submit():
        # Obtener valores del formulario
        cod_marca = agregar_producto_form.cod_marca.data
        cod_categoria = agregar_producto_form.cod_categoria.data
        nombre_producto = agregar_producto_form.nombre_producto.data
        precio_compra = agregar_producto_form.precio_compra.data
        precio_venta = agregar_producto_form.precio_venta.data
        stock_s1 = agregar_producto_form.stock_sucursal1.data
        stock_s2 = agregar_producto_form.stock_sucursal2.data
        rut_proveedor = agregar_producto_form.rut_proveedor.data
        oracle_db_connector.agregar_producto(cod_marca,cod_categoria,nombre_producto,precio_compra,precio_venta,stock_s1,stock_s2,rut_proveedor)

    # Desde acá es un GET:    
        # Locate user
    productos = oracle_db_connector.get_all_products()

    print(productos[0])

    return render_template('productos.html', productos=productos, agregar_producto_form=agregar_producto_form)

@app.route('/modificar_producto/<codigo>', methods=['GET', 'POST'])
def modificar_producto(codigo):
    modificar_producto_form = ModificarProductoForm(request.form)
    error_msg = None
    # Lógica para obtener el producto por su nombre desde la base de datos
    # DB Conn
    oracle_db_connector = current_app.config['oracle_db_connector']

    producto = oracle_db_connector.get_product_by_cod(codigo)
    stock_sucursales = oracle_db_connector.get_stock_sucursales_by_cod_producto(codigo)

    # Si no existe:
    if producto == None or producto == []:
        redirect(url_for('productos'))
    producto = list(producto[0])
    print("producto", producto)
    if request.method == 'POST' and modificar_producto_form.validate_on_submit():
        # Lógica para procesar el formulario de modificación y actualizar la base de datos
        cod_marca = request.form['cod_marca']
        cod_categoria = request.form['cod_categoria']
        nombre_producto = request.form['nombre_producto']
        precio_compra = request.form['precio_compra']
        precio_venta = request.form['precio_venta']
        stock_sucursal1 = request.form['stock_sucursal1']
        stock_sucursal2 = request.form['stock_sucursal2']
        rut_proveedor = request.form['rut_proveedor']

        result = oracle_db_connector.modificar_producto(producto[0], cod_marca,cod_categoria,nombre_producto,precio_compra,precio_venta,stock_sucursal1,stock_sucursal2,rut_proveedor)

        print("result:", result)

        if result > 0:
            # Redirigir a la página de lista de productos después de la modificación
            return redirect(url_for('productos'))
        else:
            error_msg = "Ha ocurrido un error intentando modificar el producto."
            return render_template('modificar_producto.html', error_msg=error_msg, stock_sucursales=stock_sucursales, producto=producto, modificar_producto_form=modificar_producto_form)
    else:
        for field, errors in modificar_producto_form.errors.items():
            for error in errors:
                print(f"Error en el campo '{field}': {error}")
                error_msg = error
                break

    # Renderizar el formulario de modificación con los datos del producto
        
    return render_template('modificar_producto.html', error_msg=error_msg, stock_sucursales=stock_sucursales, producto=producto, modificar_producto_form=modificar_producto_form)

@app.route('/empleados', methods=['GET', 'POST'])
def empleados():

    # Si no está logeado, chao!
    #if not 'username' in session:
     #return redirect(url_for('index'))
    
    agregar_empleado_form = AgregarEmpleado()
    # DB Conn
    oracle_db_connector = current_app.config['oracle_db_connector']
    sucursales = oracle_db_connector.get_all_sucursals()
    cargos = oracle_db_connector.get_all_cargos()
    sucursales_opciones = [(f"{sucursales[i][0]},{sucursales[i][2]}") for i in range(len(sucursales))]
    cargo_opciones = [(f"{cargos[i][0]},{cargos[i][1]}") for i in range(len(cargos))]
    agregar_empleado_form.cod_sucursal.choices=sucursales_opciones
    agregar_empleado_form.cargo.choices=cargo_opciones
    if request.method == 'POST' and agregar_empleado_form.validate_on_submit():
        # Obtener valores del formulario
        rut=agregar_empleado_form.rut.data
        cod_sucursal= agregar_empleado_form.cod_sucursal.data.split(',')[0]
        cargo=agregar_empleado_form.cargo.data.split(',')[0]
        nombre_empleado = agregar_empleado_form.nombre_empleado.data
        apellido1 = agregar_empleado_form.apellido1_empleado.data
        apellido2 = agregar_empleado_form.apellido2_empleado.data
        Telefono = agregar_empleado_form.Telefono.data
        Email = agregar_empleado_form.Email.data
        user = agregar_empleado_form.user.data
        password = agregar_empleado_form.passwd.data
        oracle_db_connector.agregar_empleado('I',rut,cod_sucursal,cargo,nombre_empleado,apellido1,apellido2,Telefono,Email,user,password)

    # Desde acá es un GET:    
        # Locate user
    productos = oracle_db_connector.get_all_employees()
    
    return render_template('empleados.html', productos=productos, agregar_empleado_form=agregar_empleado_form,sucursales=sucursales_opciones)

@app.route('/eliminar_producto/<codigo>', methods=['GET', 'POST'])
def eliminar_producto(codigo):
    oracle_db_connector = current_app.config['oracle_db_connector']
    result = oracle_db_connector.eliminar_producto(codigo)  
    print("result", result)
    return render_template('eliminar_producto.html',codigo=codigo)


@app.route('/eliminar_empleado/<rut>', methods=['GET', 'POST'])
def eliminar_empleado(rut):
    oracle_db_connector = current_app.config['oracle_db_connector']
    oracle_db_connector.eliminar_empleado('D',rut)    
    
    return render_template('eliminar_empleado.html' ,rut=rut)

@app.route('/modificar_empleado/<rut>', methods=['GET', 'POST'])
def modificar_empleado(rut):
    modificar_empleado_form = ModificarEmpleadoForm(request.form)
    # Lógica para obtener el producto por su nombre desde la base de datos
    # DB Conn
    oracle_db_connector = current_app.config['oracle_db_connector']
    sucursales = oracle_db_connector.get_all_sucursals()
    cargos = oracle_db_connector.get_all_cargos()
    cargo_opciones = [(f"{cargos[i][0]},{cargos[i][1]}") for i in range(len(cargos))]
    modificar_empleado_form.cargo.choices=cargo_opciones
    sucursales_opciones = [(f"{sucursales[i][0]},{sucursales[i][2]}") for i in range(len(sucursales))]
    modificar_empleado_form.cod_sucursal.choices=sucursales_opciones
    Rut = oracle_db_connector.get_employee_by_rut(rut)
    Rut = list(Rut[0])
    # Si no existe:
    if Rut == []:
        redirect(url_for('empleados'))

    if request.method == 'POST':
        # Lógica para procesar el formulario de modificación y actualizar la base de datos
        Codigo_Sucursal = request.form['cod_sucursal'].split(',')[0]
        cargo = request.form['cargo'].split(',')[0]
        nombre_empleado = request.form['nombre_empleado']
        apellido1_empleado= request.form['apellido1_empleado']
        apellido2_empleado=request.form['apellido2_empleado']
        Telefono=request.form['Telefono']
        Email=request.form['Email']
        Usuario=request.form['Usuario']
        contraseña=request.form['contraseña']
        oracle_db_connector.actualizar_empleado('U',rut, Codigo_Sucursal, cargo, nombre_empleado,apellido1_empleado ,apellido2_empleado ,Telefono ,Email,Usuario,contraseña )

        # Redirigir a la página de lista de productos después de la modificación
        return redirect(url_for('empleados'))
    
    sucursales = [(f"{sucursales[i][0]},{sucursales[i][2]}") for i in range(len(sucursales))]    
    # Renderizar el formulario de modificación con los datos del producto
    return render_template('modificar_empleado.html', Rut=Rut, sucursales=sucursales,modificar_empleado_form=modificar_empleado_form)

@app.route('/ingresar', methods=['GET', 'POST'])
def ingresar():
    login_form = LoginForm(request.form)

    if 'username' in session:
        print("username!!")
        return redirect(url_for('index'))
    else:
        print("NOT username!!")

    if 'login' in request.form:
        # read form data
        username  = request.form['username'] # we can have here username OR email
        password = request.form['password']

        # DB Conn
        oracle_db_connector = current_app.config['oracle_db_connector']
        # Locate user
        user = oracle_db_connector.get_user_by_username(username=username)

        print("user: ", user)
        
        # if user not found
        if not user:
            return render_template( 'ingresar.html',
                                    msg='Usuario no encontrado',
                                    form=login_form)

        """
        # Check the password
        if verify_pass(password, user.password):

            login_user(user)
            return redirect(url_for('authentication_blueprint.route_default'))
        """
        
        print("username ", username)
        session['username'] = username
        return redirect(url_for('index'))
            
        # Something (user or pass) is not ok
        return render_template('ingresar.html',
                               msg='Wrong user or password',
                               form=login_form)
    else:
        return render_template('ingresar.html',
                                form=login_form)

@app.route('/registrar', methods=['GET', 'POST'])
def registrar():

    if 'username' in session:
        print("username!!")
        return redirect(url_for('index'))

    create_account_form = CreateAccountForm(request.form)

    # IT'S A POST!
    if 'register' in request.form:

        username = request.form['username']
        email = request.form['email']
        password = request.form['password']

        print("type(username): ", type(username))

        # DB Conn
        oracle_db_connector = current_app.config['oracle_db_connector']

        # Check usename exists
        user = oracle_db_connector.get_user_by_username(username=username)

        print("user: ", user)
        
        if user:
            return render_template('registrar.html',
                                   msg='Username already registered',
                                   success=False,
                                   form=create_account_form)

        # Else we can create the user
        # SAVE USER ON DB HERE
        result = oracle_db_connector.crear_usuario(username,  email, password)
        print("result: ", result)

        if result == None:
            return render_template('registrar.html',
                                   msg='Ha ocurrido un error intentando crear usuario',
                                   success=False,
                                   form=create_account_form)

        # Delete user from session
        #logout_user()

        return render_template('registrar.html',
                               msg='User created successfully.',
                               success=True,
                               form=create_account_form)
    # IT'S A GET
    else:
        return render_template('registrar.html', form=create_account_form)

##
@app.route('/cliente', methods=['GET', 'POST'])
def clientes():
    if not 'username' in session:
        return redirect(url_for('index'))

    agregar_cliente_form = AgregarCliente()
    oracle_db_connector = current_app.config['oracle_db_connector']

    if request.method == 'POST' and agregar_cliente_form.validate_on_submit():
        rut_cliente = agregar_cliente_form.rut_cliente.data
        nombre_cliente = agregar_cliente_form.nombre_cliente.data
        apellido1_cliente = agregar_cliente_form.apellido1_cliente.data
        apellido2_cliente = agregar_cliente_form.apellido2_cliente.data
        correo_cliente = agregar_cliente_form.correo_cliente.data
        oracle_db_connector.agregar_cliente('I',rut_cliente, nombre_cliente, apellido1_cliente, apellido2_cliente, correo_cliente)

    clientes = oracle_db_connector.get_all_clients()

    return render_template('clientes.html', clientes=clientes, agregar_cliente_form=agregar_cliente_form)

@app.route('/modificar_cliente/<rut>', methods=['GET', 'POST'])
def modificar_cliente(rut):
    modificar_cliente_form = ModificarClienteForm(request.form)
    # Lógica para obtener el cliente por su rut desde la base de datos
    # DB Conn
    oracle_db_connector = current_app.config['oracle_db_connector']

    Rut = oracle_db_connector.get_cliente_by_rut(rut)
    Rut = list(Rut[0])
    print("hola",Rut)
    # Si no existe:
    if Rut == []:
        redirect(url_for('clientes'))

    if request.method == 'POST':
        # Lógica para procesar el formulario de modificación y actualizar la base de datos
        nombre_cliente = request.form['Nombre']
        apellido1_cliente = request.form['Apellido1']
        apellido2_cliente = request.form['Apellido2']
        correo_cliente = request.form['Correo']
        oracle_db_connector.actualizar_cliente('U',rut, nombre_cliente, apellido1_cliente, apellido2_cliente, correo_cliente)

        # Redirigir a la página de lista de clientes después de la modificación
        return redirect(url_for('clientes'))

    # Renderizar el formulario de modificación con los datos del cliente
    return render_template('modificar_cliente.html', Rut=Rut, modificar_cliente_form=modificar_cliente_form)

@app.route('/eliminar_cliente/<rut_cliente>', methods=['GET', 'POST'])
def eliminar_cliente(rut_cliente):
    oracle_db_connector = current_app.config['oracle_db_connector']
    oracle_db_connector.eliminar_cliente('D',rut_cliente)
    return render_template('eliminar_cliente.html', rut_cliente=rut_cliente)

@app.route('/informaciones', methods=['GET', 'POST'])
def get_sucursal():
    oracle_db_connector = current_app.config['oracle_db_connector']
    # Izquierda
    sucursales = oracle_db_connector.get_all_sucursals()
    medio_de_pagos = oracle_db_connector.get_all_medio_de_pago()

    # Derecha
    rut_cajero = 15_000_001 # TODO: Recuperar desde la sesión!
    horarios = oracle_db_connector.get_all_horarios_y_turnos(rut_cajero) # Es una lista


    print(sucursales)
    return render_template('informaciones.html',sucursales=sucursales, medio_de_pagos=medio_de_pagos, horarios=horarios) #bodegas=bodegas, cargos=cargos

@app.route('/categorias', methods=['GET', 'POST'])
def categoria():
    agregar_categoria_form = AgregarCategoria()
    oracle_db_connector = current_app.config['oracle_db_connector']

    if request.method == 'POST' and agregar_categoria_form.validate_on_submit():
        nombre_categoria = agregar_categoria_form.nombre_categoria.data
        i=oracle_db_connector.agregar_categoria('I',nombre_categoria)
        print(i)
    categorias = oracle_db_connector.get_all_categorias()

    return render_template('categorias.html', categorias=categorias, agregar_categoria_form=agregar_categoria_form)

@app.route('/modificar_categoria/<cod_categoria>', methods=['GET', 'POST'])
def modificar_categoria(cod_categoria):
    modificar_categoria_form = ModificarCategoriaForm(request.form)
    
    oracle_db_connector = current_app.config['oracle_db_connector']

    Cod_categoria = oracle_db_connector.get_categoria_by_cod(cod_categoria)
    print(Cod_categoria)
    Cod_categoria = list(Cod_categoria[0])
    
   
    if not Cod_categoria:
        redirect(url_for('categorias'))

    if request.method == 'POST':
        nombre_categoria = request.form['Nombre']
        oracle_db_connector.actualizar_categoria('U',cod_categoria, nombre_categoria)
        return redirect(url_for('categoria'))
    return render_template('modificar_categoria.html', Cod_categoria=Cod_categoria, modificar_categoria_form=modificar_categoria_form)

@app.route('/eliminar_categoria/<cod_categoria>', methods=['GET', 'POST'])
def eliminar_categoria(cod_categoria):
    oracle_db_connector = current_app.config['oracle_db_connector']
    i=oracle_db_connector.eliminar_categoria('D', cod_categoria)
    print(i)
    return render_template('eliminar_categoria.html', cod_categoria=cod_categoria)

@app.route('/marcas', methods=['GET', 'POST'])
def marcas():
    agregar_marca_form = AgregarMarca()
    oracle_db_connector = current_app.config['oracle_db_connector']

    if request.method == 'POST' and agregar_marca_form.validate_on_submit():
        nombre_marca = agregar_marca_form.nombre_marca.data
        i=oracle_db_connector.agregar_marca('I',nombre_marca)
        print(i)
    marcas = oracle_db_connector.get_all_marcas()

    return render_template('marca.html', marcas=marcas, agregar_marca_form=agregar_marca_form)

@app.route('/modificar_marca/<cod_marca>', methods=['GET', 'POST'])
def modificar_marca(cod_marca):
    modificar_marca_form = ModificarMarcaForm(request.form)
    # Lógica para obtener la marca por su código desde la base de datos
    # DB Conn
    oracle_db_connector = current_app.config['oracle_db_connector']

    Cod_Marca = oracle_db_connector.get_marca_by_cod(cod_marca)
    Cod_Marca = list(Cod_Marca[0])
    
    # Si no existe:
    if not Cod_Marca:
        redirect(url_for('marcas'))

    if request.method == 'POST':
        # Lógica para procesar el formulario de modificación y actualizar la base de datos
        nombre_marca = request.form['Nombre']
        oracle_db_connector.actualizar_marca('U',cod_marca, nombre_marca)

        # Redirigir a la página de lista de marcas después de la modificación
        return redirect(url_for('marcas'))

    # Renderizar el formulario de modificación con los datos de la marca
    return render_template('modificar_marca.html', Cod_Marca=Cod_Marca, modificar_marca_form=modificar_marca_form)

@app.route('/eliminar_marca/<cod_marca>', methods=['GET', 'POST'])
def eliminar_marca(cod_marca):
    oracle_db_connector = current_app.config['oracle_db_connector']
    oracle_db_connector.eliminar_marca('D', cod_marca)
    return render_template('eliminar_marca.html', cod_marca=cod_marca)

@app.route('/proveedor', methods=['GET', 'POST'])
def proveedores():
    if 'username' not in session:
        return redirect(url_for('index'))

    agregar_proveedor_form = AgregarProveedor()
    oracle_db_connector = current_app.config['oracle_db_connector']

    if request.method == 'POST' and agregar_proveedor_form.validate_on_submit():
        rut_proveedor = agregar_proveedor_form.rut_proveedor.data
        nombre_proveedor = agregar_proveedor_form.nombre_proveedor.data
        correo_proveedor = agregar_proveedor_form.correo_proveedor.data
        telefono_proveedor = agregar_proveedor_form.telefono_proveedor.data
        oracle_db_connector.agregar_proveedor('I', rut_proveedor, nombre_proveedor, correo_proveedor, telefono_proveedor)

    proveedores = oracle_db_connector.get_all_providers()

    return render_template('proveedores.html', proveedores=proveedores, agregar_proveedor_form=agregar_proveedor_form)

@app.route('/modificar_proveedor/<rut_proveedor>', methods=['GET', 'POST'])
def modificar_proveedor(rut_proveedor):
    modificar_proveedor_form = ModificarProveedorForm(request.form)
    oracle_db_connector = current_app.config['oracle_db_connector']

    proveedor = oracle_db_connector.get_proveedor_by_rut(rut_proveedor)
    proveedor = list(proveedor[0])

    if not proveedor:
        return redirect(url_for('proveedores'))

    if request.method == 'POST':
        nombre_proveedor = request.form['Nombre']
        correo_proveedor = request.form['Correo']
        telefono_proveedor = request.form['Telefono']
        oracle_db_connector.actualizar_proveedor('U', rut_proveedor, nombre_proveedor, correo_proveedor, telefono_proveedor)

        return redirect(url_for('proveedores'))

    return render_template('modificar_proveedor.html', proveedor=proveedor, modificar_proveedor_form=modificar_proveedor_form)

@app.route('/eliminar_proveedor/<rut_proveedor>', methods=['GET', 'POST'])
def eliminar_proveedor(rut_proveedor):
    oracle_db_connector = current_app.config['oracle_db_connector']
    oracle_db_connector.eliminar_proveedor('D', rut_proveedor)
    return render_template('eliminar_proveedor.html', rut_proveedor=rut_proveedor)

@app.route('/horarios', methods=['GET', 'POST'])
def horarios():
    # Conexión DB
    oracle_db_connector = current_app.config['oracle_db_connector']
    # Formulario
    form = HorarioForm()
    # Posible mensaje de error al validar datos
    error_msg = None
    info_msg = None

    # Solo buscando horarios?
    print(request.args)
    if request.method == 'GET' and 'inputRUT' in request.args:
        # Se ha presionado el botón para buscar horarios
        rut_ingresado = request.args.get('inputRUT')
        print("Se ha ingresado: ", rut_ingresado)

        result_by_rut = oracle_db_connector.get_employee_by_rut(rut_ingresado)
        if result_by_rut == None or len(result_by_rut) != 1:
            error_msg = "El RUT ingresado no existe."
            return render_template('horarios.html', form=form, error_msg=error_msg, info_msg=info_msg)
        else:
            # Obtener todos los horarios
            horarios = oracle_db_connector.get_all_horarios_y_turnos(rut_ingresado, False) # Es una lista
            return render_template('horarios.html', form=form, error_msg=error_msg, info_msg=info_msg, horarios=horarios)
            

    # Acá está ingresando
    if request.method == 'POST':
        codigo_horario_eliminar = request.form.get('eliminar_horario')
        if codigo_horario_eliminar:
            print("Eliminar horario cod:", codigo_horario_eliminar)
            result = oracle_db_connector.eliminar_horario('D', codigo_horario_eliminar)
            if result > 0:
                info_msg = f"Horario código {codigo_horario_eliminar} y sus turnos dependientes han sido eliminados"
                return render_template('horarios.html', form=form, info_msg=info_msg)
            else:
                info_msg = f"No fue posible eliminar el horario código {codigo_horario_eliminar}."
                return render_template('horarios.html', form=form, error_msg=error_msg)
            
    if request.method == 'POST' and form.validate_on_submit():
        # Acceder a los datos del formulario y procesarlos
        rut_empleado = form.rut_empleado.data
        fecha_inicio = form.fecha_inicio.data
        turnos = []

        # Iterar sobre los turnos del formulario
        for turno_form in form.turnos.entries:
            turno = {
                'fecha': turno_form.fecha.data,
                'hora_entrada': turno_form.hora_entrada.data,
                'hora_salida': turno_form.hora_salida.data,
                'inicio_colacion': turno_form.inicio_colacion.data,
                'termino_colacion': turno_form.termino_colacion.data,
            }
            turnos.append(turno)
 
        # Todo OK, enviar para guardar en DB
        result = oracle_db_connector.agregar_horario('I', rut_empleado, fecha_inicio, turnos)

        if result > 0:
            info_msg = "Horario ingresado con éxito." # No se usa por algunos problemillas al resetear/limpiar el form, mejor redirect
            # Limpiar turnos
            form.rut_empleado.data = ""
            form.fecha_inicio.data = ""
            for _ in range(len(form.turnos.entries)):
                form.turnos.pop_entry()
            return redirect(url_for('horarios'))
        else:
            error_msg = "Ha ocurrido un error intentando ingresar el horario."
            return render_template('horarios.html', form=form, error_msg=error_msg)
    else:
        for field, errors in form.errors.items():
            for error in errors:
                print(f"Error en el campo '{field}': {error}")
                error_msg = error
                break

    return render_template('horarios.html', form=form, error_msg=error_msg, info_msg=info_msg)

@app.route('/ventas', methods=['GET', 'POST'])
def ventas():
    info_msg = None
    error_msg = None

    return render_template('ventas.html', info_msg=info_msg, error_msg=error_msg)

@app.errorhandler(404)
def page_not_found(e):
    return render_template('404.html'), 404

@app.errorhandler(500)
def internal_server_error(e):
    return render_template('500.html'), 500
