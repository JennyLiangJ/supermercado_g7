package com.supermercado.repository;

import com.supermercado.domain.Rol;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RolRepository extends JpaRepository<Rol, Integer> {
    //Se utiliza en el momento de crear un usuario que por defecto tendrá el rol de "USER"
    public Optional<Rol> findByRol(String rol);

}
