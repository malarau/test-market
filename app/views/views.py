from flask import current_app, redirect, render_template, request, session, url_for
from app import app
from passlib.hash import sha256_crypt
from app.forms import * #AgregarProducto, CreateAccountForm, LoginForm, ModificarProductoForm, AgregarEmpleado
import random

@app.context_processor
def utility_processor():
    # Puedes definir lógica para determinar si mostrar o no el sidebar
    def mostrar_sidebar():
        return True if request.endpoint != 'index' else False

    return dict(mostrar_sidebar=mostrar_sidebar)

@app.route('/logout')
def logout():
    session.pop('username', None)
    return redirect(url_for('index'))

@app.route('/productos', methods=['GET', 'POST'])
def productos():

    # Si no está logeado, chao!
    if not 'username' in session:
        return redirect(url_for('index'))
    
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

    return render_template('productos.html',username=session['username'],cargo=session['cargo'],rut_empleado=session['rut_empleado'],sucursal=session['sucursal'],caja=session['caja'], productos=productos, agregar_producto_form=agregar_producto_form)

@app.route('/modificar_producto/<codigo>', methods=['GET', 'POST'])
def modificar_producto(codigo):
    if not 'username' in session:
        return redirect(url_for('index'))
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
            return render_template('modificar_producto.html',username=session['username'],cargo=session['cargo'],rut_empleado=session['rut_empleado'],sucursal=session['sucursal'],caja=session['caja'], error_msg=error_msg, stock_sucursales=stock_sucursales, producto=producto, modificar_producto_form=modificar_producto_form)
    else:
        for field, errors in modificar_producto_form.errors.items():
            for error in errors:
                print(f"Error en el campo '{field}': {error}")
                error_msg = error
                break

    # Renderizar el formulario de modificación con los datos del producto
        
    return render_template('modificar_producto.html',username=session['username'],cargo=session['cargo'],rut_empleado=session['rut_empleado'],sucursal=session['sucursal'],caja=session['caja'], error_msg=error_msg, stock_sucursales=stock_sucursales, producto=producto, modificar_producto_form=modificar_producto_form)

@app.route('/empleados', methods=['GET', 'POST'])
def empleados():

    # Si no está logeado, chao!
    if not 'username' in session:
        return redirect(url_for('index'))
    
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
        password  = sha256_crypt.hash(agregar_empleado_form.passwd.data)
        a=oracle_db_connector.agregar_empleado('I',rut,cod_sucursal,cargo,nombre_empleado,apellido1,apellido2,Telefono,Email,user,password)
        print(a)
        print(password, len(password))
    # Desde acá es un GET:    
        # Locate user
    productos = oracle_db_connector.get_all_employees()
    
    return render_template('empleados.html',username=session['username'],cargo=session['cargo'],rut_empleado=session['rut_empleado'],sucursal=session['sucursal'],caja=session['caja'], productos=productos, agregar_empleado_form=agregar_empleado_form,sucursales=sucursales_opciones)

@app.route('/eliminar_producto/<codigo>', methods=['GET', 'POST'])
def eliminar_producto(codigo):
    if not 'username' in session:
        return redirect(url_for('index'))
    oracle_db_connector = current_app.config['oracle_db_connector']
    output=oracle_db_connector.eliminar_producto(codigo)  
    return render_template('eliminar_producto.html',username=session['username'],cargo=session['cargo'],rut_empleado=session['rut_empleado'],sucursal=session['sucursal'],caja=session['caja'],codigo=codigo,output=output)


@app.route('/eliminar_empleado/<rut>', methods=['GET', 'POST'])
def eliminar_empleado(rut):
    if not 'username' in session:
        return redirect(url_for('index'))
    oracle_db_connector = current_app.config['oracle_db_connector']
    output=oracle_db_connector.eliminar_empleado('D',rut)    
    
    return render_template('eliminar_empleado.html',username=session['username'],cargo=session['cargo'],rut_empleado=session['rut_empleado'],sucursal=session['sucursal'],caja=session['caja'] ,rut=rut)

@app.route('/modificar_empleado/<rut>', methods=['GET', 'POST'])
def modificar_empleado(rut):
    if not 'username' in session:
        return redirect(url_for('index'))
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
    return render_template('modificar_empleado.html',username=session['username'],cargo=session['cargo'],rut_empleado=session['rut_empleado'],sucursal=session['sucursal'],caja=session['caja'], Rut=Rut, sucursales=sucursales,modificar_empleado_form=modificar_empleado_form)

@app.route('/', methods=['GET', 'POST'])
def index():
    login_form = LoginForm(request.form)
    info_msg = None
    error_msg = None
    if 'username' in session:
        # consulta si es empleado o admin
        if session['cargo']==1:
            return redirect(url_for('empleados'))
        return redirect(url_for('get_sucursal'))
    if request.method== 'POST':
        # read form data
        username = 'juanperez'  #request.form['username']  
        password = 'hashed_password' #request.form['password']
        print('user= ',username,'pass', password)
        # DB Conn
        oracle_db_connector = current_app.config['oracle_db_connector']
        # Locate user
        user = oracle_db_connector.get_user_by_username(username=username)
        password_data = oracle_db_connector.get_hash_by_username(username=username)[0][0]
        cargo=oracle_db_connector.get_cargo_by_user(username=username)[0][0]
        rut_empleado=oracle_db_connector.get_rut_by_user(username=username)[0][0]
        sucursal = oracle_db_connector.get_sucursal_by_user(username=username)[0][0]
        caja = oracle_db_connector.get_caja_by_sucursal(sucursal=sucursal)
        caja = [elemento for tupla in caja for elemento in tupla]

        #if (password_data and sha256_crypt.verify(password, password_data)):
        if (username == 'juanperez'):
            session['username'] = username
            session['cargo'] = cargo
            session['rut_empleado'] = rut_empleado
            session['sucursal'] = sucursal
            session['caja'] = random.choice(list(caja))
            if (session['cargo'] == 1):
                return redirect(url_for('empleados'))
            return redirect(url_for('get_sucursal'))
    
        if not user:
            return render_template( 'index.html',
                                    msg='Usuario no encontrado',
                                    form=login_form)
    return render_template('index.html',
                                form=login_form, error_msg=error_msg)


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

    return render_template('clientes.html',username=session['username'],cargo=session['cargo'],rut_empleado=session['rut_empleado'],sucursal=session['sucursal'],caja=session['caja'], clientes=clientes, agregar_cliente_form=agregar_cliente_form)

@app.route('/modificar_cliente/<rut>', methods=['GET', 'POST'])
def modificar_cliente(rut):
    if not 'username' in session:
        return redirect(url_for('index'))
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
    return render_template('modificar_cliente.html',username=session['username'],cargo=session['cargo'],rut_empleado=session['rut_empleado'],sucursal=session['sucursal'],caja=session['caja'], Rut=Rut, modificar_cliente_form=modificar_cliente_form)

@app.route('/eliminar_cliente/<rut_cliente>', methods=['GET', 'POST'])
def eliminar_cliente(rut_cliente):
    if not 'username' in session:
        return redirect(url_for('index'))
    oracle_db_connector = current_app.config['oracle_db_connector']
    output=oracle_db_connector.eliminar_cliente('D',rut_cliente)
    return render_template('eliminar_cliente.html',username=session['username'],cargo=session['cargo'],rut_empleado=session['rut_empleado'],sucursal=session['sucursal'],caja=session['caja'], rut_cliente=rut_cliente,output=output)

@app.route('/informaciones', methods=['GET', 'POST'])
def get_sucursal():
    if not 'username' in session:
        return redirect(url_for('index'))
    oracle_db_connector = current_app.config['oracle_db_connector']
    # Izquierda
    sucursales = oracle_db_connector.get_all_sucursals()
    medio_de_pagos = oracle_db_connector.get_all_medio_de_pago()

    # Derecha
    rut_cajero = 15_000_001 # TODO: Recuperar desde la sesión!
    horarios = oracle_db_connector.get_all_horarios_y_turnos(rut_cajero, True) # Es una lista

    print(sucursales)
    return render_template('informaciones.html',username=session['username'],cargo=session['cargo'],rut_empleado=session['rut_empleado'],sucursal=session['sucursal'],caja=session['caja'],sucursales=sucursales, medio_de_pagos=medio_de_pagos, horarios=horarios) #bodegas=bodegas, cargos=cargos

@app.route('/categorias', methods=['GET', 'POST'])
def categoria():
    if not 'username' in session:
        return redirect(url_for('index'))
    agregar_categoria_form = AgregarCategoria()
    oracle_db_connector = current_app.config['oracle_db_connector']

    if request.method == 'POST' and agregar_categoria_form.validate_on_submit():
        nombre_categoria = agregar_categoria_form.nombre_categoria.data
        i=oracle_db_connector.agregar_categoria('I',nombre_categoria)
        print(i)
    categorias = oracle_db_connector.get_all_categorias()

    return render_template('categorias.html',username=session['username'],cargo=session['cargo'],rut_empleado=session['rut_empleado'],sucursal=session['sucursal'],caja=session['caja'], categorias=categorias, agregar_categoria_form=agregar_categoria_form)

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
    return render_template('modificar_categoria.html',username=session['username'],cargo=session['cargo'],rut_empleado=session['rut_empleado'],sucursal=session['sucursal'],caja=session['caja'], Cod_categoria=Cod_categoria, modificar_categoria_form=modificar_categoria_form)

@app.route('/eliminar_categoria/<cod_categoria>', methods=['GET', 'POST'])
def eliminar_categoria(cod_categoria):
    if not 'username' in session:
        return redirect(url_for('index'))
    oracle_db_connector = current_app.config['oracle_db_connector']
    output=oracle_db_connector.eliminar_categoria('D', cod_categoria)
    return render_template('eliminar_categoria.html', username=session['username'],cargo=session['cargo'],rut_empleado=session['rut_empleado'],sucursal=session['sucursal'],caja=session['caja'],cod_categoria=cod_categoria, output=output)

@app.route('/marcas', methods=['GET', 'POST'])
def marcas():
    if not 'username' in session:
        return redirect(url_for('index'))
    agregar_marca_form = AgregarMarca()
    oracle_db_connector = current_app.config['oracle_db_connector']

    if request.method == 'POST' and agregar_marca_form.validate_on_submit():
        nombre_marca = agregar_marca_form.nombre_marca.data
        i=oracle_db_connector.agregar_marca('I',nombre_marca)
        print(i)
    marcas = oracle_db_connector.get_all_marcas()

    return render_template('marca.html',username=session['username'],cargo=session['cargo'],rut_empleado=session['rut_empleado'],sucursal=session['sucursal'],caja=session['caja'], marcas=marcas, agregar_marca_form=agregar_marca_form)

@app.route('/modificar_marca/<cod_marca>', methods=['GET', 'POST'])
def modificar_marca(cod_marca):
    if not 'username' in session:
        return redirect(url_for('index'))
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
    return render_template('modificar_marca.html',username=session['username'],cargo=session['cargo'],rut_empleado=session['rut_empleado'],sucursal=session['sucursal'],caja=session['caja'], Cod_Marca=Cod_Marca, modificar_marca_form=modificar_marca_form)

@app.route('/eliminar_marca/<cod_marca>', methods=['GET', 'POST'])
def eliminar_marca(cod_marca):
    if not 'username' in session:
        return redirect(url_for('index'))
    oracle_db_connector = current_app.config['oracle_db_connector']
    output=oracle_db_connector.eliminar_marca('D', cod_marca)
    return render_template('eliminar_marca.html',username=session['username'],cargo=session['cargo'],rut_empleado=session['rut_empleado'],sucursal=session['sucursal'],caja=session['caja'], cod_marca=cod_marca,output=output)

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

    return render_template('proveedores.html',username=session['username'],cargo=session['cargo'],rut_empleado=session['rut_empleado'],sucursal=session['sucursal'],caja=session['caja'], proveedores=proveedores, agregar_proveedor_form=agregar_proveedor_form)

@app.route('/modificar_proveedor/<rut_proveedor>', methods=['GET', 'POST'])
def modificar_proveedor(rut_proveedor):
    if not 'username' in session:
        return redirect(url_for('index'))
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

    return render_template('modificar_proveedor.html',username=session['username'],cargo=session['cargo'],rut_empleado=session['rut_empleado'],sucursal=session['sucursal'],caja=session['caja'], proveedor=proveedor, modificar_proveedor_form=modificar_proveedor_form)

@app.route('/eliminar_proveedor/<rut_proveedor>', methods=['GET', 'POST'])
def eliminar_proveedor(rut_proveedor):
    if not 'username' in session:
        return redirect(url_for('index'))
    oracle_db_connector = current_app.config['oracle_db_connector']
    output=oracle_db_connector.eliminar_proveedor('D', rut_proveedor)
    return render_template('eliminar_proveedor.html', username=session['username'],cargo=session['cargo'],rut_empleado=session['rut_empleado'],sucursal=session['sucursal'],caja=session['caja'],rut_proveedor=rut_proveedor,output=output)

@app.route('/descuentos', methods=['GET', 'POST'])
def descuentos():
    if 'username' not in session:
        return redirect(url_for('index'))

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

    return render_template('descuentos.html',username=session['username'],cargo=session['cargo'],rut_empleado=session['rut_empleado'],sucursal=session['sucursal'],caja=session['caja'], descuentos=descuentos, agregar_descuento_form=agregar_descuento_form)

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

    return render_template('modificar_descuento.html',username=session['username'],cargo=session['cargo'],rut_empleado=session['rut_empleado'],sucursal=session['sucursal'],caja=session['caja'], descuento=descuento, modificar_descuento_form=modificar_descuento_form)

@app.route('/eliminar_descuento/<cod_descuento>', methods=['GET', 'POST'])
def eliminar_descuento(cod_descuento):
    oracle_db_connector = current_app.config['oracle_db_connector']
    oracle_db_connector.eliminar_descuento('D', cod_descuento)
    return render_template('eliminar_descuento.html',username=session['username'],cargo=session['cargo'],rut_empleado=session['rut_empleado'],sucursal=session['sucursal'],caja=session['caja'], cod_descuento=cod_descuento)

@app.route('/horarios', methods=['GET', 'POST'])
def horarios():
    if not 'username' in session:
        return redirect(url_for('index'))
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
            return render_template('horarios.html', username=session['username'],cargo=session['cargo'],rut_empleado=session['rut_empleado'],sucursal=session['sucursal'],caja=session['caja'],form=form, error_msg=error_msg, info_msg=info_msg)
        else:
            # Obtener todos los horarios
            horarios = oracle_db_connector.get_all_horarios_y_turnos(rut_ingresado, False) # Es una lista
            return render_template('horarios.html', username=session['username'],cargo=session['cargo'],rut_empleado=session['rut_empleado'],sucursal=session['sucursal'],caja=session['caja'],form=form, error_msg=error_msg, info_msg=info_msg, horarios=horarios)
            

    # Post eliminando
    if request.method == 'POST':
        codigo_horario_eliminar = request.form.get('eliminar_horario')
        if codigo_horario_eliminar:
            print("Eliminar horario cod:", codigo_horario_eliminar)
            result = oracle_db_connector.eliminar_horario('D', codigo_horario_eliminar)
            if result > 0:
                info_msg = f"Horario código {codigo_horario_eliminar} y sus turnos dependientes han sido eliminados"
                return render_template('horarios.html',username=session['username'],cargo=session['cargo'],rut_empleado=session['rut_empleado'],sucursal=session['sucursal'],caja=session['caja'], form=form, info_msg=info_msg)
            else:
                info_msg = f"No fue posible eliminar el horario código {codigo_horario_eliminar}."
                return render_template('horarios.html', username=session['username'],cargo=session['cargo'],rut_empleado=session['rut_empleado'],sucursal=session['sucursal'],caja=session['caja'],form=form, error_msg=error_msg)
            
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
            return render_template('horarios.html', username=session['username'],cargo=session['cargo'],rut_empleado=session['rut_empleado'],sucursal=session['sucursal'],caja=session['caja'],form=form, error_msg=error_msg)
    else:
        for field, errors in form.errors.items():
            for error in errors:
                print(f"Error en el campo '{field}': {error}")
                error_msg = error
                break

    return render_template('horarios.html',username=session['username'],cargo=session['cargo'],rut_empleado=session['rut_empleado'],sucursal=session['sucursal'],caja=session['caja'], form=form, error_msg=error_msg, info_msg=info_msg)

@app.route('/ventas', methods=['GET', 'POST'])
def ventas():
    if not 'username' in session:
        return redirect(url_for('index'))
    form = VentaForm(request.form)
    info_msg = None
    error_msg = None

    # DB
    oracle_db_connector = current_app.config['oracle_db_connector']

    # TODO: Cod caja random según sucursal
    cod_caja = session['caja']
    form.cod_caja.data = cod_caja
    # RUT empleado, TODO: Consultar según logeo
    rut_empleado = session['rut_empleado']
    form.rut_empleado.data = rut_empleado
    # Asignar lista de productos (enviados al template y usados por JS para cargar un bloque de "detalle de venta")
    productos = oracle_db_connector.get_all_concat_products_with_discounts()
    product_choices = [producto[0] for producto in productos]
    # Medios de pago
    medios_de_pago = oracle_db_connector.get_all_medio_de_pago()
    form.medio_de_pago.choices = [f"{medio[0]}, {medio[1]}" for medio in medios_de_pago]

    if request.method == 'POST':
        if form.validate_on_submit(): # significa que todo está validado y OK, no? No??

            print("form.rut_cliente: ", form.rut_cliente.data)
            print("form.medio_de_pago: ", form.medio_de_pago.data[0])
            print("form.total: ", form.total.data)
            print("post, detalles.data:\n\t", form.detalles.data) # Detalle de venta

            result = oracle_db_connector.agregar_venta(
                cod_caja,
                form.rut_cliente.data,
                rut_empleado,
                form.medio_de_pago.data[0],
                # FECHA_VENTA = SYSDATE
                # DESCUENTO_VENTA = Calcular diferencia entre precio_venta y subtotal para cada item de form.detalles.data
                form.total.data,
                form.detalles.data
            )

            if result < 0:
                print("aaaaaaaaaaaaaaaaaaaaaaaa")

        else:
            for field, errors in form.errors.items():
                for error in errors:
                    if field == 'total' and 'required' in error:
                        error_msg = "El total no puede estar vacío."
                        break    
                    print(f"Error en el campo '{field}': {error}")
                    if len(error) == 0:
                        error_msg = f"Error en el campo {field}"
                        break
                    error_msg = error
                    break

    return render_template('ventas.html',username=session['username'],cargo=session['cargo'],rut_empleado=session['rut_empleado'],sucursal=session['sucursal'],caja=session['caja'], productos=product_choices, form=form, info_msg=info_msg, error_msg=error_msg)

@app.errorhandler(404)
def page_not_found(e):
    return render_template('404.html',username=session['username'],cargo=session['cargo'],rut_empleado=session['rut_empleado'],sucursal=session['sucursal'],caja=session['caja'],), 404

@app.errorhandler(500)
def internal_server_error(e):
    return render_template('500.html',username=session['username'],cargo=session['cargo'],rut_empleado=session['rut_empleado'],sucursal=session['sucursal'],caja=session['caja'],), 500
