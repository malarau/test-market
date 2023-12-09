from flask import current_app, redirect, render_template, request, session, url_for
from app import app
from app.forms import * #AgregarProducto, CreateAccountForm, LoginForm, ModificarProductoForm, AgregarEmpleado

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

@app.route('/user/<name>')
def user(name):
    return render_template('user.html', name=name)

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
        cod_lote = agregar_producto_form.cod_lote.data
        oracle_db_connector.agregar_producto(cod_marca,cod_categoria,nombre_producto,precio_compra,precio_venta,stock_producto,rut_proveedor,cod_lote)

    # Desde acá es un GET:    
        # Locate user
    productos = oracle_db_connector.get_all_products()

    return render_template('productos.html', productos=productos, agregar_producto_form=agregar_producto_form)

@app.route('/empleados', methods=['GET', 'POST'])
def empleados():

    # Si no está logeado, chao!
    if not 'username' in session:
        return redirect(url_for('index'))
    
    agregar_empleado_form = AgregarEmpleado()
    # DB Conn
    oracle_db_connector = current_app.config['oracle_db_connector']

    if request.method == 'POST' and agregar_empleado_form.validate_on_submit():
        # Obtener valores del formulario
        rut=agregar_empleado_form.rut.data
        cod_sucursal= agregar_empleado_form.cod_sucursal.data 
        cargo=agregar_empleado_form.cargo.data
        nombre_empleado = agregar_empleado_form.nombre_empleado.data
        apellido1 = agregar_empleado_form.apellido1_empleado.data
        apellido2 = agregar_empleado_form.apellido2_empleado.data
        Telefono = agregar_empleado_form.Telefono.data
        Email = agregar_empleado_form.Email.data

        oracle_db_connector.agregar_empleado(rut,cod_sucursal,cargo,nombre_empleado,apellido1,apellido2,Telefono,Email)

    # Desde acá es un GET:    
        # Locate user
    productos = oracle_db_connector.get_all_employees()
    sucursales = oracle_db_connector.get_all_sucursals()
    sucursales = [(sucursales[i][0]) for i in range(len(sucursales))]
    return render_template('empleados.html', productos=productos, agregar_empleado_form=agregar_empleado_form,sucursales=sucursales)

@app.route('/eliminar_producto/<codigo>', methods=['GET', 'POST'])
def eliminar_producto(codigo):
    oracle_db_connector = current_app.config['oracle_db_connector']
    oracle_db_connector.eliminar_producto(codigo)  
    return render_template('eliminar_producto.html',codigo=codigo)


@app.route('/eliminar_empleado/<rut>', methods=['GET', 'POST'])
def eliminar_empleado(rut):
    oracle_db_connector = current_app.config['oracle_db_connector']
    oracle_db_connector.eliminar_empleado(rut)    
    
    return render_template('eliminar_empleado.html' , rut=rut)

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

    Rut = oracle_db_connector.get_employee_by_rut(rut)
    Rut = list(Rut[0])
    # Si no existe:
    if Rut == []:
        redirect(url_for('empleados'))

    if request.method == 'POST':
        # Lógica para procesar el formulario de modificación y actualizar la base de datos
        Codigo_Sucursal = request.form['Codigo_Sucursal']
        Codigo_cargo = request.form['Codigo_cargo']
        nombre_empleado = request.form['nombre_empleado']
        apellido1_empleado= request.form['apellido1_empleado']
        apellido2_empleado=request.form['apellido2_empleado']
        Telefono=request.form['Telefono']
        Email=request.form['Email']
        Usuario=request.form['Usuario']
        contraseña=request.form['contraseña']
        oracle_db_connector.actualizar_empleado(rut, Codigo_Sucursal, Codigo_cargo, nombre_empleado,apellido1_empleado ,apellido2_empleado ,Telefono ,Email,Usuario,contraseña )

        # Redirigir a la página de lista de productos después de la modificación
        return redirect(url_for('empleados'))

    # Renderizar el formulario de modificación con los datos del producto
    return render_template('modificar_empleado.html', Rut=Rut, modificar_empleado_form=modificar_empleado_form)

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

@app.route('/sucursal', methods=['GET', 'POST'])
def get_sucursal():
    oracle_db_connector = current_app.config['oracle_db_connector']
    sucursales = oracle_db_connector.get_all_sucursals()
    print(sucursales)
    return render_template('sucursal.html',sucursales=sucursales)


@app.errorhandler(404)
def page_not_found(e):
    return render_template('404.html'), 404

@app.errorhandler(500)
def internal_server_error(e):
    return render_template('500.html'), 500