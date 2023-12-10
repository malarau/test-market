# -*- encoding: utf-8 -*-
"""
Copyright (c) 2019 - present AppSeed.us
"""

from flask_wtf import FlaskForm
from wtforms import IntegerField, StringField, PasswordField, SubmitField, SelectField
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
    cargo=IntegerField('Cargo del Empleado')
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
    Codigo_Sucursal = SelectField('Codigo Sucursal', validators=[DataRequired()])
    Codigo_cargo = SelectField('Cargo', validators=[DataRequired()])
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