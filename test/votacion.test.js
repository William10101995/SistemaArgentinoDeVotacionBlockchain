const Votacion = artifacts.require("Votacion");

contract("Votacion", () => {
  before(async () => {
    this.votacion = await Votacion.deployed();
  });

  it("Se deployo el contrato", async () => {
    const address = this.votacion.address;
    assert.typeOf(address, "string");
  });

  it("Cargaron las propuestas", async () => {
    const propuestas = await this.votacion.obtenerPropuestas();
    assert.equal(propuestas.length, 2);
  });

  it("Abrir Mesa", async () => {
    const mesa = await this.votacion.darAltaMesa(39179119, "William", "Lopez");
    assert.typeOf(mesa.logs[0].args[1], "string");
    assert.typeOf(mesa.logs[0].args[2], "string");
  });
});
