/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package com.supermercado.repository;

import com.supermercado.domain.Producto;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 *
 * @author jenny
 */
@Repository
public interface ProductoRepository extends JpaRepository<Producto, Integer> {
    public List<Producto> findByActivoTrue();
    
    //Consulta Derivada para recuperar los productos de un rango de precios, ordenados por precio ascendente
    public List<Producto> findByPrecioBetweenOrderByPrecioAsc(double precioInf, double precioSup);
}
