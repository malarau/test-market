# -*- encoding: utf-8 -*-
"""
Copyright (c) 2019 - present AppSeed.us
"""

from flask_wtf import FlaskForm
from wtforms import IntegerField, StringField, PasswordField, SubmitField, SelectField,EmailField
from wtforms.validators import Email, DataRequired,Length

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
    email = EmailField('Email',
                      id='email_create',
                      validators=[DataRequired(), Email()])
    password = PasswordField('Password',
                             id='pwd_create',
                             validators=[DataRequired()])
    
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

class AgregarMarca(FlaskForm):
    nombre_marca = StringField('Nombre de Marca', validators=[DataRequired(),Length(max=30)])

class ModificarMarcaForm(FlaskForm):
    Cod_Marca = IntegerField('Código de Marca', validators=[DataRequired()])
    Nombre = StringField('Nombre de Marca', validators=[DataRequired(),Length(max=30)])
    guardar_cambios = SubmitField('Guardar Cambios')

class AgregarCategoria(FlaskForm):
    nombre_categoria = StringField('Nombre de Categoria', validators=[DataRequired(),Length(max=30)])
    
class ModificarCategoriaForm(FlaskForm):
    Cod_Categoria = IntegerField('Código de Categoria', validators=[DataRequired()])
    Nombre = StringField('Nombre de Categoria', validators=[DataRequired(),Length(max=30)])
    guardar_cambios = SubmitField('Guardar Cambios')