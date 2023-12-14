# -*- encoding: utf-8 -*-
"""
Copyright (c) 2019 - present AppSeed.us
"""

from datetime import timedelta
from flask import current_app
from flask_wtf import FlaskForm
from wtforms import DateField, DecimalField, FieldList, FormField, HiddenField, IntegerField, StringField, PasswordField, SubmitField, SelectField, TimeField, ValidationError,EmailField
from wtforms.validators import Email, DataRequired,Length, NumberRange, InputRequired

# login and registration


class LoginForm(FlaskForm):
    username = StringField('Username',
                         id='username_login',
                         validators=[DataRequired()])
    password = PasswordField('Password',
                             id='pwd_login',
                             validators=[DataRequired()])



#
# Empleado
#
class AgregarEmpleado(FlaskForm):
    rut=IntegerField('Rut del Empleado')
    cod_sucursal=SelectField('Codigo de sucursal del Empleado',choices=[],validators=[DataRequired()])
    cargo=SelectField('Cargo del Empleado', choices=[], validators=[DataRequired()])
    nombre_empleado = StringField('Nombre del Empleado', validators=[DataRequired(),Length(max=40)])
    apellido1_empleado = StringField('Apellido 1 del Empleado', validators=[DataRequired(),Length(max=30)])
    apellido2_empleado = StringField('Apellido 2 del Empleado', validators=[DataRequired(),Length(max=30)])
    Telefono = StringField('Telefono', validators=[DataRequired(),Length(max=15)])
    Email = EmailField('Email Empleado', validators=[DataRequired(),Length(max=50)])
    user = StringField('Usuario Empleado', validators=[DataRequired(),Length(max=30)])
    passwd = PasswordField('Contraseña Empleado', validators=[DataRequired(),Length(max=64)])
    
class AgregarProducto(FlaskForm):
    cod_marca = IntegerField('Codigo Marca', validators=[DataRequired()])
    cod_categoria = IntegerField('Codigo Categoria', validators=[DataRequired()])
    nombre_producto = StringField('Nombre Producto', validators=[DataRequired(),Length(max=50)])
    precio_compra = IntegerField('Precio Compra', validators=[DataRequired()])
    precio_venta = IntegerField('Precio Venta', validators=[DataRequired()])
    stock_producto = IntegerField('Stock Producto', validators=[DataRequired()])
    rut_proveedor = IntegerField('Rut Proveedor', validators=[DataRequired()])
    
class ModificarProductoForm(FlaskForm):
    cod_marca = IntegerField('Codigo Marca', validators=[DataRequired()])
    cod_categoria = IntegerField('Codigo Categoria', validators=[DataRequired()])
    nombre_producto = StringField('Nombre Producto', validators=[DataRequired(),Length(max=50)])
    precio_compra = IntegerField('Precio Compra', validators=[DataRequired()])
    precio_venta = IntegerField('Precio Venta', validators=[DataRequired()])
    stock_producto = IntegerField('Stock Producto', validators=[DataRequired()])
    rut_proveedor = IntegerField('Rut Proveedor', validators=[DataRequired()])
    cod_lote = IntegerField('Codigo Lote', validators=[DataRequired()])
    guardar_cambios = SubmitField('Guardar Cambios')

class ModificarEmpleadoForm(FlaskForm):
    cod_sucursal = SelectField('Codigo Sucursal', choices=[], validators=[DataRequired()])
    cargo = SelectField('Cargo', choices=[], validators=[DataRequired()])
    nombre_empleado = StringField('Nombre Empleado', validators=[DataRequired(),Length(max=40)])
    apellido1_empleado= StringField('Primer apellido Empleado', validators=[DataRequired(),Length(max=30)])
    apellido2_empleado=StringField('Segundo apellido Empleado', validators=[DataRequired(),Length(max=30)])
    Telefono = StringField('Telefono', validators=[DataRequired(),Length(max=15)])
    Email = EmailField('Email', validators=[DataRequired(),Length(max=50)])
    Usuario = StringField('Usuario Empleado', validators=[DataRequired(),Length(max=30)])
    contraseña = PasswordField('Password', id='pwd_create',validators=[DataRequired(),Length(max=64)])
    guardar_cambios = SubmitField('Guardar Cambios')

def validador_rut_proveedor(form, field):
    oracle_db_connector = current_app.config['oracle_db_connector']
    result = oracle_db_connector.get_proveedor_by_rut(field.data)
    if len(result) == 0:
        raise ValidationError('El proveedor no existe.') 

#
# Producto
#
class AgregarProducto(FlaskForm):
    cod_marca = IntegerField('Codigo Marca', validators=[DataRequired()])
    cod_categoria = IntegerField('Codigo Categoria', validators=[DataRequired()])
    nombre_producto = StringField('Nombre Producto', validators=[DataRequired()])
    precio_compra = IntegerField('Precio Compra', validators=[DataRequired()])
    precio_venta = IntegerField('Precio Venta', validators=[DataRequired()])
    stock_sucursal1 = IntegerField('Stock sucursal 1', validators=[DataRequired()])
    stock_sucursal2 = IntegerField('Stock sucursal 2', validators=[DataRequired()])
    rut_proveedor = IntegerField('Rut Proveedor', validators=[DataRequired()])

def validador_marca(form, field):
    oracle_db_connector = current_app.config['oracle_db_connector']
    result = oracle_db_connector.get_marca_by_cod(field.data)
    if len(result) == 0:
        raise ValidationError('La marca no existe.') 
    
def validador_categoria(form, field):
    oracle_db_connector = current_app.config['oracle_db_connector']
    result = oracle_db_connector.get_categoria_by_cod(field.data)
    if len(result) == 0:
        raise ValidationError('La categoría no existe.') 

class ModificarProductoForm(FlaskForm):
    cod_marca = IntegerField('Codigo Marca', validators=[DataRequired(), validador_marca])
    cod_categoria = IntegerField('Codigo Categoria', validators=[DataRequired(), validador_categoria])
    nombre_producto = StringField('Nombre Producto', validators=[DataRequired()])
    precio_compra = IntegerField('Precio Compra', validators=[DataRequired()])
    precio_venta = IntegerField('Precio Venta', validators=[DataRequired()])
    stock_sucursal1 = IntegerField('Stock sucursal 1', validators=[DataRequired()])
    stock_sucursal2 = IntegerField('Stock sucursal 2', validators=[DataRequired()])
    rut_proveedor = IntegerField('Rut Proveedor', validators=[DataRequired()])
    guardar_cambios = SubmitField('Guardar Cambios')
    
#
# Cliente
#
class AgregarCliente(FlaskForm):
    rut_cliente = IntegerField('Rut del Cliente', validators=[DataRequired()])
    nombre_cliente = StringField('Nombre del Cliente', validators=[DataRequired(),Length(max=40)])
    apellido1_cliente = StringField('Apellido 1 del Cliente', validators=[DataRequired(),Length(max=30)])
    apellido2_cliente = StringField('Apellido 2 del Cliente', validators=[DataRequired(),Length(max=30)])
    correo_cliente = EmailField('Correo del Cliente', validators=[DataRequired(),Length(max=50)])
    
class ModificarClienteForm(FlaskForm):
    Nombre = StringField('Nombre del Cliente', validators=[DataRequired(),Length(max=40)])
    Apellido1 = StringField('Primer Apellido del Cliente', validators=[DataRequired(),Length(max=30)])
    Apellido2 = StringField('Segundo Apellido del Cliente', validators=[DataRequired(),Length(max=30)])
    Correo = EmailField('Correo del Cliente', validators=[DataRequired(),Length(max=50)])
    guardar_cambios = SubmitField('Guardar Cambios')

def validador_rut_cliente(form, field):
    # Complementar con DataRequired si es requerido (en venta no es requerido, pero si se incluye, que exista).
    if field.data != None and field.data != 0: # IF 0, ENTONCES DEFAULT
        oracle_db_connector = current_app.config['oracle_db_connector']
        result = oracle_db_connector.get_cliente_by_rut(field.data)
        if len(result) == 0:
            raise ValidationError('El cliente no existe.') 

#
# Proveedor
#
class AgregarProveedor(FlaskForm):
    rut_proveedor = IntegerField('Rut del Proveedor', validators=[DataRequired()])
    nombre_proveedor = StringField('Nombre del Proveedor', validators=[DataRequired(),Length(max=30)])
    correo_proveedor = EmailField('Correo del Proveedor', validators=[DataRequired(),Length(max=50)])
    telefono_proveedor = StringField('Teléfono del Proveedor', validators=[DataRequired(),Length(max=15)])
    
class ModificarProveedorForm(FlaskForm):
    Nombre = StringField('Nombre del Proveedor', validators=[DataRequired(),Length(max=30)])
    Correo = EmailField('Correo del Proveedor', validators=[DataRequired(),Length(max=50)])
    Telefono= StringField('Teléfono del Proveedor', validators=[DataRequired(),Length(max=15)])
    guardar_cambios = SubmitField('Guardar Cambios')

#
# Marca
#
class AgregarMarca(FlaskForm):
    nombre_marca = StringField('Nombre de Marca', validators=[DataRequired(),Length(max=30)])

class ModificarMarcaForm(FlaskForm):
    Cod_Marca = IntegerField('Código de Marca', validators=[DataRequired()])
    Nombre = StringField('Nombre de Marca', validators=[DataRequired(),Length(max=30)])
    guardar_cambios = SubmitField('Guardar Cambios')

#
# Categoría
#
class AgregarCategoria(FlaskForm):
    nombre_categoria = StringField('Nombre de Categoria', validators=[DataRequired(),Length(max=30)])
    
class ModificarCategoriaForm(FlaskForm):
    Cod_Categoria = IntegerField('Código de Categoria', validators=[DataRequired()])
    Nombre = StringField('Nombre de Categoria', validators=[DataRequired(),Length(max=30)])
    guardar_cambios = SubmitField('Guardar Cambios')

#
# Horario
#
class TurnoBase():
    def __init__(self) -> None:
        hora_entrada = 'HH:MM'
        hora_salida = ''
        inicio_colacion = ''
        termino_colacion = ''

class TurnoForm(FlaskForm):
    class Meta:
        csrf = False
    fecha = DateField('Fecha')
    hora_entrada = TimeField('Hora Entrada', validators=[DataRequired()], format='%H:%M')
    hora_salida = TimeField('Hora Salida', validators=[DataRequired()], format='%H:%M')
    inicio_colacion = TimeField('Inicio Colación', validators=[DataRequired()], format='%H:%M')
    termino_colacion = TimeField('Termino Colación', validators=[DataRequired()], format='%H:%M')

def validador_horario(form, field):
    fechas_vistas = set()
    turnos_contados = 0

    for turno_form in field.entries:
        # Caso 1: Existen 2 turnos con la misma fecha
        if turno_form.fecha.data in fechas_vistas:
            raise ValidationError('No se permiten dos turnos con la misma fecha.')

        # Caso 2: Hay más de 7 turnos (el horario cubre 7 días desde la fecha de inicio)
        turnos_contados += 1
        if turnos_contados > 7:
            raise ValidationError('No se permiten más de 7 turnos.')

        # Caso 3: Existe un turno con una fecha superior a una semana
        fecha_limite = form.fecha_inicio.data + timedelta(days=7)
        if turno_form.fecha.data > fecha_limite:
            raise ValidationError('No se permiten turnos con fecha superior a una semana desde la fecha de inicio.')

        # Caso 4: Existe un turno con fecha anterior a la fecha de inicio
        if turno_form.fecha.data < form.fecha_inicio.data:
            raise ValidationError('Cada uno de los turnos debe contener una fecha igual o posterior a la fecha de inicio.')

        # Caso 5: Validar que hora_entrada sea anterior a hora_salida
        if turno_form.hora_entrada.data >= turno_form.hora_salida.data:
            raise ValidationError('La hora de entrada debe ser anterior a la hora de salida.')
        
        # Caso 6: Validar que inicio_colacion sea una hora anterior a termino_colacion
        if turno_form.inicio_colacion.data >= turno_form.termino_colacion.data:
            raise ValidationError('La hora de inicio de colación debe ser anterior a la hora de término de colación.')

        # Caso 7: Validar que inicio_colacion y termino_colacion estén entre hora_entrada y hora_salida
        if not (turno_form.hora_entrada.data <= turno_form.inicio_colacion.data <= turno_form.termino_colacion.data <= turno_form.hora_salida.data):
            raise ValidationError('Las horas de colación deben estar entre la hora de entrada y la hora de salida.')

        fechas_vistas.add(turno_form.fecha.data)

def validador_rut_empleado(form, field):
    oracle_db_connector = current_app.config['oracle_db_connector']
    result = oracle_db_connector.get_employee_by_rut(field.data)
    if len(result) == 0:
        raise ValidationError('El empleado no existe.')    

class HorarioForm(FlaskForm):
    rut_empleado = StringField('RUT Empleado', validators=[DataRequired(), validador_rut_empleado])
    fecha_inicio = DateField('Fecha de Inicio', validators=[DataRequired()])
    turnos = FieldList(FormField(TurnoForm, default=TurnoBase), min_entries=1, max_entries=7, validators=[DataRequired(), validador_horario])
    guardar = SubmitField('Guardar')

#
#   Ventas
#
class DetalleVentaBase():
    def __init__(self) -> None:
        producto = ''
        cantidad = 0
        subtotal = 0

class DetalleVentaForm(FlaskForm):
    class Meta:
        csrf = False
    cod_producto = IntegerField('Código', validators=[DataRequired()], render_kw={'readonly': True})
    # producto -> validate_choice=False
    #       Es horrible porque no supe como agregar/quitar elemento dinámicamente y que
    #       el SelectField funcionara sin que form.validate_on_submit() me pateara, así que chao
    #       Se podría validar que exista la elección igualmente, se debe.
    producto = SelectField('Producto', choices=[], validators=[DataRequired()], validate_choice=False)
    cantidad = IntegerField('Cantidad', validators=
                            [DataRequired(),
                             InputRequired(message= "Se debe ingresar la cantidad en todos los productos."),
                             NumberRange(min=1, message="La cantidad de uno de los productos, no es correcta.")])
    subtotal = DecimalField('Subtotal', validators=[DataRequired()], render_kw={'readonly': True})

def validador_venta(form, field):
    oracle_db_connector = current_app.config['oracle_db_connector']

    # TODO: 
    # Desde sesión, obtener la sucursal, según quién logeó
    # Con la sucursal, calcular si cierto producto, puede ser vendido en X cantidad.

    print("validador_venta:")
    productos_agregados = set()
    for detalle in field:

        if detalle.data == None:
            continue

        # Validación base
        #
        # Que el cod no sea nulo
        print("cod_producto: ", detalle.cod_producto.data)
        if detalle.cod_producto.data == None:
            raise ValidationError(f"El código de uno de los productos es nulo.")
        # Que la cantidad no sea nula
        if detalle.cantidad.data == None:
            raise ValidationError(f"La cantidad en el producto código {detalle.cod_producto.data} es nula.") 
        # Que 2 detalles sean del mismo producto
        if detalle.cod_producto.data in productos_agregados:
            raise ValidationError('Dos detalles contienen el mismo producto.')

        # Validar con base de datos
        #
        # Validar que tengamos stock
        sucursal = 1 # TODO: Obtener desde la session['sucursal'], que se asigna al logearse un empleado
        result = oracle_db_connector.validar_stock(sucursal, detalle.cod_producto.data, detalle.cantidad.data)
        if (result == -1):
            raise ValidationError(f"No hay stock suficiente ({detalle.cantidad.data}) para el producto código {detalle.cod_producto.data}.") 

        productos_agregados.add(detalle.cod_producto.data)

class VentaForm(FlaskForm):
    cod_caja = IntegerField('Código de caja', validators=[]) # Al azar, input bloqueado. # DataRequired()
    rut_cliente = IntegerField('RUT Cliente', validators=[validador_rut_cliente], default=0)
    rut_empleado = IntegerField('RUT Empleado', validators=[validador_rut_empleado]) # Input bloqueado # DataRequired()
    medio_de_pago = SelectField('Medio de pago', choices=[], validators=[]) # DataRequired()
    detalles = FieldList(FormField(DetalleVentaForm, default=DetalleVentaBase), min_entries=0, validators=[validador_venta]) # DataRequired()
    total = IntegerField('Total general:', validators=[DataRequired()], render_kw={'readonly': True}) # Requerido y bloqueado, se calcula automáticamente
    guardar = SubmitField('Enviar')