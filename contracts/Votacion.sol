// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Elecciones {
    // Propiedades del Votante
    struct Votante {
        string apellido; // Se puede cambiar por una direccion de Ethereum
        string nombre; // Se puede cambiar por una direccion de Ethereum
        address billetera;
        bool voto;
        uint256 pesoVoto; // Se hace con peso del voto ya que podria delegarse el voto entonces el pesos seria 2 | 3 | 4 etc
    }

    // Propiedades de la propuesta electoral
    struct Propuesta {
        string lista; //Se puede optimizar usando bytes32
        uint256 contadorVotos;
    }

    // Presidente de Mesa
    uint256 public presidenteMesa;

    // Arreglo de propuestas
    Propuesta[] public propuestas;

    // Mapeo de votantes
    mapping(uint256 => Votante) public votantes;

    // Solo se ejecuta por unica vez cuando se deploya el contrato
    constructor() {
        propuestas.push(Propuesta({lista: "Lista 501R", contadorVotos: 0}));
        propuestas.push(Propuesta({lista: "Lista 503A", contadorVotos: 0}));
    }

    // Funcion para dar de alta la mesa
    function darAltaMesa(
        uint256 _dni,
        string memory _nombre,
        string memory _apellido
    ) public {
        presidenteMesa = _dni;
        votantes[presidenteMesa].nombre = _nombre;
        votantes[presidenteMesa].apellido = _apellido;
        votantes[presidenteMesa].billetera = msg.sender;
    }

    // Funcion para autorizar el voto
    function autorizarVoto(
        uint256 _dni,
        string memory _nombre,
        string memory _apellido
    ) public {
        // Ve si el presidente de mesa es el que esta habilidato a votar
        require(votantes[presidenteMesa].billetera == msg.sender); //Ture | False

        // Ve si el votante ya voto
        require(votantes[_dni].voto == false); //True | False

        //verifica que el voto solo valga 0
        require(votantes[_dni].pesoVoto == 0); //True | False

        //Asigna peso al voto y otros parametros
        votantes[_dni].nombre = _nombre;
        votantes[_dni].apellido = _apellido;
        votantes[_dni].pesoVoto = 1;
    }

    // Funcion para votar
    function votar(uint256 _dni, uint256 _idPropuesta) public {
        if (_dni == presidenteMesa) {
            require(
                votantes[_dni].billetera == votantes[presidenteMesa].billetera
            ); //True | False
            require(votantes[_dni].voto == false); //True | False
            require(votantes[presidenteMesa].pesoVoto == 1); //True | False
            votantes[presidenteMesa].voto = true;
        } else {
            votantes[_dni].billetera = msg.sender; // Asigna la billetera del Votante
            require(
                votantes[_dni].billetera != votantes[presidenteMesa].billetera
            ); // Verifica si las billeteres son diferentes
            require(votantes[_dni].voto == false); // Verifica que el votante no haya votado
            require(votantes[_dni].pesoVoto == 1); // Si el peso del voto no es 1, no esta autorizado
            votantes[_dni].voto = true; // Voto
        }

        propuestas[_idPropuesta].contadorVotos += votantes[_dni].pesoVoto; // Asigna el peso del voto a la propuesta
    }

    // Funcion que obtine el resultado de las propuestas
    function obtenerResultado() public view returns (Propuesta memory) {
        Propuesta memory ganador; // variable para controlar el ganador
        // Recorre las propuestas viendo cual tine mas votos
        for (uint256 i = 0; i < propuestas.length; i++) {
            if (propuestas[i].contadorVotos > ganador.contadorVotos) {
                ganador = propuestas[i]; // Asigna la propuesta con mas votos
            }
        }
        return ganador;
    }

    // Funcion que obtine todas las propuestas
    function obtenerPropuestas() public view returns (Propuesta[] memory) {
        return propuestas;
    }

    // Funcion que verifica si el votante ya voto
    function verificarVoto(uint256 _dni) public view returns (bool) {
        return votantes[_dni].voto;
    }
}
