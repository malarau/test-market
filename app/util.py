# -*- encoding: utf-8 -*-
"""
Copyright (c) 2019 - present AppSeed.us
"""

from io import BytesIO
import os
import hashlib
import binascii
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import A5

# Inspiration -> https://www.vitoshacademy.com/hashing-passwords-in-python/


def hash_pass(password):
    """Hash a password for storing."""

    salt = hashlib.sha256(os.urandom(60)).hexdigest().encode('ascii')
    pwdhash = hashlib.pbkdf2_hmac('sha512', password.encode('utf-8'),
                                  salt, 100000)
    pwdhash = binascii.hexlify(pwdhash)
    return (salt + pwdhash)  # return bytes


def verify_pass(provided_password, stored_password):
    """Verify a stored password against one provided by user"""

    stored_password = stored_password.decode('ascii')
    salt = stored_password[:64]
    stored_password = stored_password[64:]
    pwdhash = hashlib.pbkdf2_hmac('sha512',
                                  provided_password.encode('utf-8'),
                                  salt.encode('ascii'),
                                  100000)
    pwdhash = binascii.hexlify(pwdhash).decode('ascii')
    return pwdhash == stored_password


def generar_pdf(nombre_archivo, nombre_negocio, rut_sucursal, cod_sucursal, cod_caja, rut_empleado, cod_medio_de_pago, medio_de_pago, total, total_descuentos, detalle_venta):
    buffer = BytesIO()

    # Crear el objeto canvas con tamaño de página A5
    c = canvas.Canvas(buffer, pagesize=A5)

    # Configuración de fuente y tamaño
    c.setFont("Helvetica", 10)

    # Agregar cabecera
    c.drawString(72, A5[1] - 25, f"Sucursal: {nombre_negocio}")
    c.drawString(72, A5[1] - 40, f"RUT: {rut_sucursal} - Código Sucursal: {cod_sucursal}")
    c.drawString(72, A5[1] - 55, f"Caja: {cod_caja} - Empleado: {rut_empleado}")
    c.drawString(72, A5[1] - 70, f"Medio de Pago: {medio_de_pago} - Código Medio de Pago: {cod_medio_de_pago}")
    c.drawString(72, A5[1] - 85, f"Total Venta: ${total} - Total Descuentos: ${total_descuentos}")

    # Doble línea divisoria entre la cabecera y el detalle
    c.line(72, A5[1] - 100, 322, A5[1] - 100)
    c.line(72, A5[1] - 101, 322, A5[1] - 101)

    # Agregar cuerpo (detalle_venta)
    y_position = A5[1] - 120  # Posición inicial en el eje Y

    for item in detalle_venta:
        c.drawString(72, y_position, f"Código Producto: {item['cod_producto']}")
        c.drawString(72, y_position - 15, f"Nombre Producto: {item['nombre_producto']}")
        c.drawString(72, y_position - 30, f"Valor Unitario: ${item['producto']}") # Entrega el valor del producto
        c.drawString(72, y_position - 45, f"Cantidad:  {item['cantidad']}")
        c.drawString(72, y_position - 60, f"Descuento: ${item['descuento']}")
        c.drawString(72, y_position - 75, f"Subtotal:  ${item['subtotal']}")
        y_position -= 90  # Ajustar posición para la siguiente fila

        # Línea divisoria entre los detalles de venta
        c.line(72, y_position + 10, 252, y_position + 10)

    # Guardar el PDF
    c.save()

    # Obtener el directorio donde se guardará el archivo
    directorio = os.path.dirname(nombre_archivo)

    # Crear el directorio si no existe
    os.makedirs(directorio, exist_ok=True)

    # Show
    with open(nombre_archivo, 'wb') as f:
        f.write(buffer.getvalue())

    buffer.seek(0)
    return buffer