class Remarshal < Formula
  include Language::Python::Virtualenv

  desc "Convert between TOML, YAML and JSON"
  homepage "https://github.com/remarshal-project/remarshal"
  url "https://files.pythonhosted.org/packages/26/6b/9817fbf9cabb8914313c546b5d55653148a7dbe612a8dbaa992d05a6dff7/remarshal-2.1.4.tar.gz"
  sha256 "510caa7f2aa48437e8fa6a316782bbec5235f3fad09f20ae246e4e372a53902d"
  license "MIT"
  head "https://github.com/remarshal-project/remarshal.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7c84287f2315b534728121437eee283e2af1a04e49e2fb959320bb920d395de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c0ba21996cb4d714193dca86c9f73316f5c39451f4aca90ca877830d0704364"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78a6b00c4ed321b4238560371fc574ebc1915f27b7c8b168d044255d6ac723d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed395fa36d5f5ea3ed7bd4193b6b7ac8aee25063eb58170e5f717e0a10302811"
    sha256 cellar: :any,                 arm64_linux:   "cb238cae65a309c17c65d24a20bd86fef8a1d74b1d8825004e212efa51d4db4a"
    sha256 cellar: :any,                 x86_64_linux:  "e2ec990791f0aecc0b6f0774b64fc91f5d1f669fa10425feba271ccb441ef9c6"
  end

  depends_on "python@3.14"

  conflicts_with "msgpack-tools", because: "both install 'json2msgpack' binary"
  conflicts_with "toml2json", because: "both install `toml2json` binaries"
  conflicts_with "yaml2json", because: "both install `yaml2json` binaries"

  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/bd/cb/09939728be094d155b5d4ac262e39877875f5f7e36eea66beb359f647bd0/cbor2-5.9.0.tar.gz"
    sha256 "85c7a46279ac8f226e1059275221e6b3d0e370d2bb6bd0500f9780781615bcea"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/c7/3b/ebda527b56beb90cb7652cb1c7e4f91f48649fbcd8d2eb2fb6e77cd3329b/ruamel_yaml-0.19.1.tar.gz"
    sha256 "53eb66cd27849eff968ebf8f0bf61f46cdac2da1d1f3576dd4ccee9b25c31993"
  end

  resource "starlark" do
    url "https://files.pythonhosted.org/packages/0c/1c/f7bd41150c9ab4aa4bd02de46a0af88afa8d4da7af73e76aeb209e473ac2/starlark-0.5.0.tar.gz"
    sha256 "321e1d07dffc8c89eb37945573a59e8e4a965a6f88cb87141010fdf52478eb91"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/46/79/cf31d7a93a8fdc6aa0fbb665be84426a8c5a557d9240b6239e9e11e35fc5/termcolor-3.3.0.tar.gz"
    sha256 "348871ca648ec6a9a983a13ab626c0acce02f515b9e1983332b17af7979521c5"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/22/de/48c59722572767841493b26183a0d1cc411d54fd759c5607c4590b6563a6/tomli-2.4.1.tar.gz"
    sha256 "7c7e1a961a0b2f2472c1ac5b69affa0ae1132c39adcb67aba98568702b9cc23f"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/94/96/e07752635b98536177fa1f37671c8f3cdde2e724c6bcf6034b2cfb571565/tomlkit-0.15.1.tar.gz"
    sha256 "e25bbf38843005246210a12982776f27f99cb9be67160e14434d0c0d21ee1e97"
  end

  resource "u-msgpack-python" do
    url "https://files.pythonhosted.org/packages/36/9d/a40411a475e7d4838994b7f6bcc6bfca9acc5b119ce3a7503608c4428b49/u-msgpack-python-2.8.0.tar.gz"
    sha256 "b801a83d6ed75e6df41e44518b4f2a9c221dc2da4bcd5380e3a0feda520bc61a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    json = <<~JSON
      {"foo.bar":"baz","qux":1}
    JSON
    yaml = <<~YAML
      foo.bar: baz
      qux: 1
    YAML
    toml = <<~TOML
      "foo.bar" = "baz"
      qux = 1
    TOML
    assert_equal yaml, pipe_output("#{bin}/remarshal -if=json -of=yaml", json, 0)
    assert_equal yaml, pipe_output("#{bin}/json2yaml", json, 0)
    assert_equal toml, pipe_output("#{bin}/remarshal -if=yaml -of=toml", yaml, 0)
    assert_equal toml, pipe_output("#{bin}/yaml2toml", yaml, 0)
    assert_equal json, pipe_output("#{bin}/remarshal -if=toml -of=json", toml, 0)
    assert_equal json, pipe_output("#{bin}/toml2json", toml, 0)
    assert_equal pipe_output("#{bin}/remarshal -if=yaml -of=msgpack", yaml, 0),
                 pipe_output("#{bin}/remarshal -if=json -of=msgpack", json, 0)

    assert_match version.to_s, shell_output("#{bin}/remarshal --version")
  end
end
