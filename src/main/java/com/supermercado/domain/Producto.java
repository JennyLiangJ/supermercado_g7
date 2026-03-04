/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.supermercado.domain;

import jakarta.persistence.Column;
import lombok.Data;
import jakarta.persistence.*;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import java.math.BigDecimal;

@Data
@Entity
@Table(name="producto")

public class Producto implements Serializable {
    private static final long serialVersionUID = 1L;
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="id_producto")
    private Integer idProducto;
    //private Integer idCategoria;   Ahora esta dentro del objeto categoria
    
    @Column(unique=true, nullable=false, length=50)
    @NotNull
    @Size(max=50)
    private String descripcion;
    private String detalle;
    
    @Column(precision=12, scale=2)
    @NotNull(message="El precio no puede estar vacio")
    @DecimalMin(value="0.01", inclusive=true, message="El precio debe ser mayor o igual a cero.")
    private BigDecimal precio;
    
    @NotNull(message="Las existencias no puede estar vacio")
    @Min(value=0, message="Las existencias debe ser mayor o igual a cero.")
    private Integer existencias;
    
    @Column(length=1024)
    @Size(max=1024)
    private String rutaImagen;
    
    @Column(name="activo")
    private boolean activo;
    
    @ManyToOne
    @JoinColumn(name="id_categoria")
    private Categoria categoria;
}

