package com.supermercado.controller;

import com.supermercado.service.ProductoService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/consultas")
public class ConsultaController {

    private final ProductoService productoService;

    public ConsultaController(ProductoService productoService) {
        this.productoService = productoService;
    }

    @GetMapping("/listado")
    public String listado(Model model) {
        var productos = productoService.getProductos(false);
        model.addAttribute("productos", productos);
        return "/consultas/listado";
    }

    //Consulta Derivada
    @PostMapping("/busquedaPrecio")
    public String busquedaPrecio(@RequestParam() double precioInf,
            @RequestParam() double precioSup,
            Model model) {
        var productos = productoService.consultaDerivada(precioInf, precioSup);
        model.addAttribute("productos", productos);
        model.addAttribute("precioInf", precioInf);
        model.addAttribute("precioSup", precioSup);
        return "/consultas/listado";
    }

    @PostMapping("/consultaNombre")
    public String consultaNombre(@RequestParam() String descripcion,
            Model model) {

        var productos = productoService.consultaPorNombre(descripcion);

        model.addAttribute("productos", productos);
        model.addAttribute("nombre", descripcion);

        return "/consultas/listado";
    }
}
