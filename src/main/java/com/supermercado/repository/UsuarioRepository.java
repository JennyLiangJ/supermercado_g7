package com.supermercado.repository;

import com.supermercado.domain.Usuario;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UsuarioRepository extends JpaRepository<Usuario, Integer> {
    
    public Optional<Usuario> findByUsernameAndActivoTrue(String username);
    
     //Recupera la lista completa de usuarios activos
    public List<Usuario> findByActivoTrue();

    //Se utiliza para ubicar un usuario por el username de manera genérica
    public Optional<Usuario> findByUsername(String username);

    //Se utiliza para finalizar el proceso de registro de un nuevo usuario después de enviarle un correo.
    public Optional<Usuario> findByUsernameAndPassword(String username, String Password);

    //Se utiliza cuando el usuario quiere recordar la clave e indicao username o correo para enviar el enlace de reactivación
    public Optional<Usuario> findByUsernameOrCorreo(String username, String correo);
    
    //Se utiliza para saber si ya hay un registro con el username o el correo. Si existe no se puede crear.
    public boolean existsByUsernameOrCorreo(String username, String correo);
}
