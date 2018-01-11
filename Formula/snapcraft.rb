class Snapcraft < Formula
  include Language::Python::Virtualenv

  desc "Package any app for every Linux desktop, server, cloud or device"
  homepage "https://snapcraft.io/"
  url "https://files.pythonhosted.org/packages/bb/9c/a4361b89e478e5459678908692251636d43d14d88c56b8ff53dd239cadec/snapcraft-2.33.tar.gz"
  sha256 "269ed290dc7853e812852b24a5ffb7cdae5f8351afee17769f0c849043c70ac9"
  revision 3

  bottle do
    cellar :any
    sha256 "e7783e63a50412da745187e8e2150a963da2737d7736c83c151d8b7241088553" => :high_sierra
    sha256 "04f2bd4eecd0e7dcd997dea87ecf7d097c0f8ab758e04a967f13b9666f3f8e29" => :sierra
    sha256 "e4d3a6d1403abea233c5bf2b93709652b2ed47846c1811b2aa69dcc850e48676" => :el_capitan
  end

  depends_on "libmagic"
  depends_on "libsodium"
  depends_on "libyaml"
  depends_on "lxc"
  depends_on "squashfs"
  depends_on "python3"

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/5b/b9/790f8eafcdab455bcd3bd908161f802c9ce5adbf702a83aa7712fcc345b7/cffi-1.10.0.tar.gz"
    sha256 "b3b02911eb1f6ada203b0763ba924234629b51586f72a21faacc638269f4ced5"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/7d/87/4e3a3f38b2f5c578ce44f8dc2aa053217de9f0b6d737739b0ddac38ed237/chardet-2.3.0.tar.gz"
    sha256 "e53e38b3a4afe6d1132de62b7400a4ac363452dc5dfcf8d88e8e0cce663c68aa"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/95/d9/c3336b6b5711c3ab9d1d3a80f1a3e2afeb9d8c02a7166462f6cc96570897/click-6.7.tar.gz"
    sha256 "f15516df478d5a56180fbf80e68f206010e6d160fc39fa508b65e035fd75130b"
  end

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/7c/69/c2ce7e91c89dc073eb1aa74c0621c3eefbffe8216b3f9af9d3885265c01c/configparser-3.5.0.tar.gz"
    sha256 "5308b47021bc2340965c371f0f058cc6971a04502638d4244225c49d80db273a"
  end

  resource "cookies" do
    url "https://files.pythonhosted.org/packages/f3/95/b66a0ca09c5ec9509d8729e0510e4b078d2451c5e33f47bd6fc33c01517c/cookies-2.2.1.tar.gz"
    sha256 "d6b698788cae4cfa4e62ef8643a9ca332b79bd96cb314294b864ae8d7eb3ee8e"
  end

  resource "file-magic" do
    url "https://files.pythonhosted.org/packages/b5/7b/e488ef8f41976ed69d0bee6da8e3229f78f0b9b4cedb988f4bbaa2ff23f1/file-magic-0.3.0.tar.gz"
    sha256 "c8654256900eb696b52f7a5d4b3c672e737541ba4ff466d2fcc2b9fb1844c7f5"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/58/0d/c816f5ea5adaf1293a1d81d32e4cdfdaf8496973aa5049786d7fdb14e7e7/jsonschema-2.5.1.tar.gz"
    sha256 "36673ac378feed3daa5956276a829699056523d7961027911f064b52255ead41"
  end

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/34/1b/ccf26e9d785722bbf8b08a3585022ef5efeaff5d4057804e2ceba24f2ca0/libarchive-c-2.5.tar.gz"
    sha256 "98660daa2501d2da51ab6f39893dc24e88916e72b2d80c205641faa5bce66859"
  end

  resource "libnacl" do
    url "https://files.pythonhosted.org/packages/b4/8c/9ac55c791821998b4a8c963c5834a8073328b01574c7bc7e3e2b4b18f670/libnacl-1.3.6.tar.gz"
    sha256 "d8045a4b82f23ae4d6a07732b4998029ac51957bed16534c2b12d926ead35188"
  end

  resource "petname" do
    url "https://files.pythonhosted.org/packages/48/d7/a276a49c3527c1f4962869bb99f2b160003fccdd96a13fcb0e8c20d13356/petname-1.12.tar.gz"
    sha256 "5555129677425950efccb297c4e1681e759ccd48621121f710aa12a18bf2732d"
  end

  resource "progressbar33" do
    url "https://files.pythonhosted.org/packages/71/fc/7c8e01f41a6e671d7b11be470eeb3d15339c75ce5559935f3f55890eec6b/progressbar33-2.4.tar.gz"
    sha256 "51fe0d9b3b4023db2f983eeccdfc8c9846b84db8443b9bee002c7f58f4376eff"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/8c/2d/aad7f16146f4197a11f8e91fb81df177adcc2073d36a17b1491fd09df6ed/pycparser-2.18.tar.gz"
    sha256 "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226"
  end

  resource "pymacaroons" do
    url "https://files.pythonhosted.org/packages/32/bd/7d155b6d95a30ace3fcb30f9951f181fcc135c9f29e2ef265a4d7eb2017c/pymacaroons-0.9.2.tar.gz"
    sha256 "9a3de55308e41abdbc05f6e205c20ed36f928860cce490fa9835231ab9cb3c32"
  end

  resource "pymacaroons" do
    url "https://files.pythonhosted.org/packages/1e/ee/ffbb4204e44893157a90fe8bbfd4f816aea462e703fa62d12cf088ecebb5/pymacaroons-0.10.0.tar.gz"
    sha256 "abadd32fe4152873dba99c439e1a6dfee3f2ab1b38882a14de014436b6008402"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/8d/f3/02605b056e465bf162508c4d1635a2bccd9abd1ee3ed2a1bb4e9676eac33/PyNaCl-1.1.2.tar.gz"
    sha256 "32f52b754abf07c319c04ce16905109cab44b0e7f7c79497431d3b2000f8af8c"
  end

  resource "python-debian" do
    url "https://files.pythonhosted.org/packages/fc/84/a637f063d0632edfad36044e97e2a7d1ee13c1d68aa4b3b85b4054977663/python-debian-0.1.28.tar.gz"
    sha256 "1e4441548598b8dfd2b61bc36db64bfa5a7b93a65ae04641d3e998fe3b702544"
  end

  resource "pymacaroons-pynacl" do
    url "https://github.com/matrix-org/pymacaroons/archive/v0.9.3.tar.gz"
    sha256 "871399c4dc1dfab7a435df2d5f2954cbba51d275ca2e93a96abb8b35d348fe5a"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/26/28/ee953bd2c030ae5a9e9a0ff68e5912bd90ee50ae766871151cd2572ca570/pyxdg-0.25.tar.gz"
    sha256 "81e883e0b9517d624e8b0499eb267b82a815c0b7146d5269f364988ae031279d"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/75/5e/b84feba55e20f8da46ead76f14a3943c8cb722d40360702b2365b91dec00/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/f9/6d/07c44fb1ebe04d069459a189e7dab9e4abfe9432adcd4477367c25332748/requests-2.9.1.tar.gz"
    sha256 "c577815dd00f1394203fc44eb979724b098f88264a9ef898ee45b8e5e9cf587f"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/95/af/d18f76bd931a92dfe614dd7f613527d5447145260e335188b418f8385226/requests-toolbelt-0.6.0.tar.gz"
    sha256 "cc4e9c0ef810d6dfd165ca680330b65a4cf8a3f08f5f08ecd50a0253a08e541f"
  end

  resource "responses" do
    url "https://files.pythonhosted.org/packages/09/e4/ae639e37d9d35903fdeda416d7f9c9e3a0331895d574b4fe6632a27c9190/responses-0.5.1.tar.gz"
    sha256 "8cad64c45959a651ceaf0023484bd26180c927fea64a81e63d334ddf6377ecea"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/f0/07/26b519e6ebb03c2a74989f7571e6ae6b82e9d7d81b8de6fcdbfc643c7b58/simplejson-3.8.2.tar.gz"
    sha256 "d58439c548433adcda98e695be53e526ba940a4b9c44fb9a05d92cd495cdd47f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/db/40/6ffc855c365769c454591ac30a25e9ea0b3e8c952a1259141f5b9878bd3d/tabulate-0.7.5.tar.gz"
    sha256 "9071aacbd97a9a915096c1aaf0dc684ac2672904cd876db5904085d6dac9810e"
  end

  def install
    virtualenv_create(libexec, "python3")
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"]="en_US.UTF-8"
    system "#{bin}/snapcraft", "--version"
    system "#{bin}/snapcraft", "--help"
    system "#{bin}/snapcraft", "init"
    assert_predicate testpath/"snap/snapcraft.yaml", :exist?
  end
end
