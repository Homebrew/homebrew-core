class Remarshal < Formula
  include Language::Python::Virtualenv

  desc "Convert between TOML, YAML and JSON"
  homepage "https://github.com/dbohdan/remarshal"
  url "https://files.pythonhosted.org/packages/55/39/d638b7d8012468fe13c072bfb283cd917b12dbcb8e7a10b414d5109b0852/remarshal-0.17.1.tar.gz"
  sha256 "826a41d3e3ed9d45422811488d7b28cc146a8d5b2583b18db36302f87091a86d"
  license "MIT"
  head "https://github.com/dbohdan/remarshal.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fbc4d08801da5f3502afb1ef7a87e91141d9920414cbb79be206670df6a8cc80"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "509df010573b5c4850255938b1fd4c92e885252a0310029f4a4d3f977218b575"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbd77782401027ea9519f3df181ae8d34443a37f1c0c4868ea0616d8760ab3bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "1fe139e6d7f125f0f1b1ed4f07af2f6eeadd84297055bf8b84251ca3a32dfa5b"
    sha256 cellar: :any_skip_relocation, ventura:        "f13d13779df302074bd7daf26dd7ee4156d08bf59ad8ef78673afabf67db2120"
    sha256 cellar: :any_skip_relocation, monterey:       "b58c1be20919590386fea2de12a7de953ee18092ea99d7e2d0c8a1b6ec58e96e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afdd307624aeeb6c87190a12ca40e900d6979ed7b7de0e9fb389f314e53c5e58"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  conflicts_with "msgpack-tools", because: "both install 'json2msgpack' binary"

  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/d9/69/de486293f5211d2e8fe1a19854e69f2811a18448162c52b48c67f8fbcac3/cbor2-5.4.6.tar.gz"
    sha256 "b893500db0fe033e570c3adc956af6eefc57e280026bd2d86fd53da9f1e594d7"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/d7/4b/cbd8e699e64a6f16ca3a8220661b5f83792b3017d0f79807cb8708d33913/iniconfig-2.0.0.tar.gz"
    sha256 "2d91e135bf72d31a410b17c16da610a82cb55f6b0477d1a902134b24a455b8b3"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/36/51/04defc761583568cae5fd533abda3d40164cbdcf22dee5b7126ffef68a40/pluggy-1.3.0.tar.gz"
    sha256 "cf61ae8f126ac6f7c451172cf30e3e43d3ca77615509771b3a984a0730651e12"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/5b/a2/4db5b065b0694b330f2b3c47e64abda0a470839da5119a404610d6349a11/pytest-7.4.1.tar.gz"
    sha256 "2f2301e797521b23e4d2585a0a3d7b5e50fdddaaf7e7d6773ea26ddb17c213ab"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/0d/07/d34a911a98e64b07f862da4b10028de0c1ac2222ab848eaf5dd1877c4b1b/tomlkit-0.12.1.tar.gz"
    sha256 "38e1ff8edb991273ec9f6181244a6a391ac30e9f5098e7535640ea6be97a7c86"
  end

  resource "u-msgpack-python" do
    url "https://files.pythonhosted.org/packages/36/9d/a40411a475e7d4838994b7f6bcc6bfca9acc5b119ce3a7503608c4428b49/u-msgpack-python-2.8.0.tar.gz"
    sha256 "b801a83d6ed75e6df41e44518b4f2a9c221dc2da4bcd5380e3a0feda520bc61a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    json = "{\"foo.bar\":\"baz\",\"qux\":1}"
    yaml = <<~EOS.chomp
      foo.bar: baz
      qux: 1

    EOS
    toml = <<~EOS.chomp
      "foo.bar" = "baz"
      qux = 1

    EOS
    assert_equal yaml, pipe_output("#{bin}/remarshal -if=json -of=yaml", json)
    assert_equal yaml, pipe_output("#{bin}/json2yaml", json)
    assert_equal toml, pipe_output("#{bin}/remarshal -if=yaml -of=toml", yaml)
    assert_equal toml, pipe_output("#{bin}/yaml2toml", yaml)
    assert_equal json, pipe_output("#{bin}/remarshal -if=toml -of=json", toml).chomp
    assert_equal json, pipe_output("#{bin}/toml2json", toml).chomp
    assert_equal pipe_output("#{bin}/remarshal -if=yaml -of=msgpack", yaml),
      pipe_output("#{bin}/remarshal -if=json -of=msgpack", json)

    assert_match version.to_s, shell_output("#{bin}/remarshal --version")
  end
end
