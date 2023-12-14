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
        stock_producto = agregar_producto_form.stock_producto.data
        rut_proveedor = agregar_producto_form.rut_proveedor.data
        oracle_db_connector.agregar_producto(cod_marca,cod_categoria,nombre_producto,precio_compra,precio_venta,stock_producto,rut_proveedor)

    # Desde acá es un GET:    
        # Locate user
    productos = oracle_db_connector.get_all_products()

    return render_template('productos.html', productos=productos, agregar_producto_form=agregar_producto_form)

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
    oracle_db_connector.eliminar_producto(codigo)  
    return render_template('eliminar_producto.html',codigo=codigo)


@app.route('/eliminar_empleado/<rut>', methods=['GET', 'POST'])
def eliminar_empleado(rut):
    oracle_db_connector = current_app.config['oracle_db_connector']
    oracle_db_connector.eliminar_empleado('D',rut)    
    
    return render_template('eliminar_empleado.html' ,rut=rut)

@app.route('/modificar_producto/<codigo>', methods=['GET', 'POST'])
def modificar_producto(codigo):
    modificar_producto_form = ModificarProductoForm(request.form)
    # Lógica para obtener el producto por su nombre desde la base de datos
    # DB Conn
    oracle_db_connector = current_app.config['oracle_db_connector']

    producto = oracle_db_connector.get_product_by_cod(codigo)

    print(producto)

    # Si no existe:
    if producto == []:
        redirect(url_for('productos'))
    producto = list(producto[0])
    if request.method == 'POST':
        # Lógica para procesar el formulario de modificación y actualizar la base de datos
        nuevo_nombre = request.form['nombre_producto']
        nueva_cantidad = request.form['cantidad']
        nueva_marca = request.form['marca']

        # Redirigir a la página de lista de productos después de la modificación
        return redirect(url_for('productos'))

    # Renderizar el formulario de modificación con los datos del producto
        
    return render_template('modificar_producto.html', producto=producto, modificar_producto_form=modificar_producto_form)

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
    #bodegas = oracle_db_connector.get_all_bodegas()
    #cargos = oracle_db_connector.get_all_cargos()

    # Derecha
    medio_de_pagos = oracle_db_connector.get_all_medio_de_pago()

    print(sucursales)
    return render_template('informaciones.html',sucursales=sucursales, medio_de_pagos=medio_de_pagos) #bodegas=bodegas, cargos=cargos

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

@app.route('/descuentos', methods=['GET', 'POST'])
def descuentos():
    #if 'username' not in session:
    #    return redirect(url_for('index'))

    agregar_descuento_form = AgregarDescuentoForm()
    oracle_db_connector = current_app.config['oracle_db_connector']

    if request.method == 'POST' and agregar_descuento_form.validate_on_submit():
        cod_producto = agregar_descuento_form.cod_producto.data
        porcentaje_descuento = agregar_descuento_form.porcentaje_descuento.data
        valido_desde = agregar_descuento_form.valido_desde.data
        valido_hasta = agregar_descuento_form.valido_hasta.data
        oracle_db_connector.agregar_descuento('I', None, cod_producto, porcentaje_descuento, valido_desde, valido_hasta)
        resultado = oracle_db_connector.agregar_descuento('I', None, cod_producto, porcentaje_descuento, valido_desde, valido_hasta)
        print("Resultado de agregar_descuento:", resultado)

    descuentos = oracle_db_connector.get_all_descuentos()

    return render_template('descuentos.html', descuentos=descuentos, agregar_descuento_form=agregar_descuento_form)

@app.route('/modificar_descuento/<cod_descuento>', methods=['GET', 'POST'])
def modificar_descuento(cod_descuento):
    modificar_descuento_form = ModificarDescuentoForm(request.form)
    oracle_db_connector = current_app.config['oracle_db_connector']

    descuento = oracle_db_connector.get_descuento_by_cod(cod_descuento)
    descuento = list(descuento[0])

    if not descuento:
        return redirect(url_for('descuentos'))

    if request.method == 'POST':
        porcentaje_descuento = modificar_descuento_form.PorcentajeDescuento.data
        valido_desde = modificar_descuento_form.ValidoDesde.data
        valido_hasta = modificar_descuento_form.ValidoHasta.data
        print(valido_hasta)
        print(valido_desde)
        print(descuento)
        oracle_db_connector.actualizar_descuento(cod_descuento,descuento[1], porcentaje_descuento, valido_desde, valido_hasta)

        return redirect(url_for('descuentos'))
    modificar_descuento_form.PorcentajeDescuento.data = descuento[2]
    modificar_descuento_form.ValidoDesde.data = descuento[3]
    modificar_descuento_form.ValidoHasta.data = descuento[4]

    return render_template('modificar_descuento.html', descuento=descuento, modificar_descuento_form=modificar_descuento_form)

@app.route('/eliminar_descuento/<cod_descuento>', methods=['GET', 'POST'])
def eliminar_descuento(cod_descuento):
    oracle_db_connector = current_app.config['oracle_db_connector']
    oracle_db_connector.eliminar_descuento('D', cod_descuento)
    return render_template('eliminar_descuento.html', cod_descuento=cod_descuento)


@app.errorhandler(404)
def page_not_found(e):
    return render_template('404.html'), 404

@app.errorhandler(500)
def internal_server_error(e):
    return render_template('500.html'), 500