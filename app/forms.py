# -*- encoding: utf-8 -*-
"""
Copyright (c) 2019 - present AppSeed.us
"""

from flask_wtf import FlaskForm
from wtforms import IntegerField, StringField, PasswordField, SubmitField, SelectField
from wtforms.fields import DateField
from wtforms.validators import Email, DataRequired

# login and registration


class LoginForm(FlaskForm):
    username = StringField('Username',
                         id='username_login',
                         validators=[DataRequired()])
    password = PasswordField('Password',
                             id='pwd_login',
                             validators=[DataRequired()])


class CreateAccountForm(FlaskForm):
    username = StringField('Username',
                         id='username_create',
                         validators=[DataRequired()])
    email = StringField('Email',
                      id='email_create',
                      validators=[DataRequired(), Email()])
    password = PasswordField('Password',
                             id='pwd_create',
                             validators=[DataRequired()])
    
class AgregarEmpleado(FlaskForm):
    rut=IntegerField('Rut del Empleado')
    cod_sucursal=SelectField('Codigo de sucursal del Empleado',choices=[])
    cargo=SelectField('Cargo del Empleado', choices=[], validators=[DataRequired()])
    nombre_empleado = StringField('Nombre del Empleado')
    apellido1_empleado = StringField('Apellido 1 del Empleado')
    apellido2_empleado = StringField('Apellido 2 del Empleado')
    Telefono = StringField('Telefono')
    Email = StringField('Email Empleado')
    user = StringField('Usuario Empleado')
    passwd = StringField('Contraseña Empleado')
class AgregarProducto(FlaskForm):
    cod_marca = IntegerField('Codigo Marca', validators=[DataRequired()])
    cod_categoria = IntegerField('Codigo Categoria', validators=[DataRequired()])
    nombre_producto = StringField('Nombre Producto', validators=[DataRequired()])
    precio_compra = IntegerField('Precio Compra', validators=[DataRequired()])
    precio_venta = IntegerField('Precio Venta', validators=[DataRequired()])
    stock_producto = IntegerField('Stock Producto', validators=[DataRequired()])
    rut_proveedor = IntegerField('Rut Proveedor', validators=[DataRequired()])
class ModificarProductoForm(FlaskForm):
    cod_marca = IntegerField('Codigo Marca', validators=[DataRequired()])
    cod_categoria = IntegerField('Codigo Categoria', validators=[DataRequired()])
    nombre_producto = StringField('Nombre Producto', validators=[DataRequired()])
    precio_compra = IntegerField('Precio Compra', validators=[DataRequired()])
    precio_venta = IntegerField('Precio Venta', validators=[DataRequired()])
    stock_producto = IntegerField('Stock Producto', validators=[DataRequired()])
    rut_proveedor = IntegerField('Rut Proveedor', validators=[DataRequired()])
    cod_lote = IntegerField('Codigo Lote', validators=[DataRequired()])
    guardar_cambios = SubmitField('Guardar Cambios')

class ModificarEmpleadoForm(FlaskForm):
    cod_sucursal = SelectField('Codigo Sucursal', choices=[], validators=[DataRequired()])
    cargo = SelectField('Cargo', choices=[], validators=[DataRequired()])
    nombre_empleado = StringField('Nombre Empleado', validators=[DataRequired()])
    apellido1_empleado= StringField('Primer apellido Empleado', validators=[DataRequired()])
    apellido2_empleado=StringField('Segundo apellido Empleado', validators=[DataRequired()])
    Telefono = StringField('Telefono', validators=[DataRequired()])
    Email = StringField('Email', validators=[DataRequired()])
    Usuario = StringField('Usuario Empleado', validators=[DataRequired()])
    contraseña = PasswordField('Password',
                             id='pwd_create',
                             validators=[DataRequired()])
    guardar_cambios = SubmitField('Guardar Cambios')
    
class AgregarCliente(FlaskForm):
    rut_cliente = IntegerField('Rut del Cliente', validators=[DataRequired()])
    nombre_cliente = StringField('Nombre del Cliente', validators=[DataRequired()])
    apellido1_cliente = StringField('Apellido 1 del Cliente', validators=[DataRequired()])
    apellido2_cliente = StringField('Apellido 2 del Cliente', validators=[DataRequired()])
    correo_cliente = StringField('Correo del Cliente', validators=[DataRequired()])
    
class ModificarClienteForm(FlaskForm):
    Nombre = StringField('Nombre del Cliente', validators=[DataRequired()])
    Apellido1 = StringField('Primer Apellido del Cliente', validators=[DataRequired()])
    Apellido2 = StringField('Segundo Apellido del Cliente', validators=[DataRequired()])
    Correo = StringField('Correo del Cliente', validators=[DataRequired()])
    guardar_cambios = SubmitField('Guardar Cambios')
    
class AgregarProveedor(FlaskForm):
    rut_proveedor = IntegerField('Rut del Proveedor', validators=[DataRequired()])
    nombre_proveedor = StringField('Nombre del Proveedor', validators=[DataRequired()])
    correo_proveedor = StringField('Correo del Proveedor', validators=[DataRequired()])
    telefono_proveedor = StringField('Teléfono del Proveedor', validators=[DataRequired()])
    
class ModificarProveedorForm(FlaskForm):
    Nombre = StringField('Nombre del Proveedor', validators=[DataRequired()])
    Correo = StringField('Correo del Proveedor', validators=[DataRequired()])
    Telefono= StringField('Teléfono del Proveedor', validators=[DataRequired()])
    guardar_cambios = SubmitField('Guardar Cambios')

class AgregarMarca(FlaskForm):
    nombre_marca = StringField('Nombre de Marca', validators=[DataRequired()])

class ModificarMarcaForm(FlaskForm):
    Cod_Marca = IntegerField('Código de Marca', validators=[DataRequired()])
    Nombre = StringField('Nombre de Marca', validators=[DataRequired()])
    guardar_cambios = SubmitField('Guardar Cambios')

class AgregarCategoria(FlaskForm):
    nombre_categoria = StringField('Nombre de Categoria', validators=[DataRequired()])
    
class ModificarCategoriaForm(FlaskForm):
    Cod_Categoria = IntegerField('Código de Categoria', validators=[DataRequired()])
    Nombre = StringField('Nombre de Categoria', validators=[DataRequired()])
    guardar_cambios = SubmitField('Guardar Cambios')

class AgregarDescuentoForm(FlaskForm):
    cod_producto = IntegerField('Código de Producto', validators=[DataRequired()])
    porcentaje_descuento = IntegerField('Porcentaje de Descuento', validators=[DataRequired()])
    valido_desde = DateField('Válido Desde', format='%Y-%m-%d', validators=[DataRequired()])
    valido_hasta = DateField('Válido Hasta', format='%Y-%m-%d', validators=[DataRequired()])
    agregar_descuento = SubmitField('Agregar Descuento')

class ModificarDescuentoForm(FlaskForm):
    PorcentajeDescuento = IntegerField('Porcentaje de Descuento', validators=[DataRequired()])
    ValidoDesde = DateField('Válido Desde', format='%Y-%m-%d', validators=[DataRequired()])
    ValidoHasta = DateField('Válido Hasta', format='%Y-%m-%d', validators=[DataRequired()])
    guardar_cambios = SubmitField('Guardar Cambios')