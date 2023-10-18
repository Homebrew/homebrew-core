class Volatility < Formula
  include Language::Python::Virtualenv

  desc "Advanced memory forensics framework"
  homepage "https://github.com/volatilityfoundation/volatility3"
  url "https://files.pythonhosted.org/packages/83/f6/be2fb46e5656f322eeb807a1b0d8a767561cec26824f275f8a3e29e4280c/volatility3-2.5.0.tar.gz"
  sha256 "278ec521c9213967a01321361e4d007c71e681a0c577a75710f482bfa15d0506"
  license :cannot_represent
  version_scheme 1
  head "https://github.com/volatilityfoundation/volatility3.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "68be854d7a0a8356c6bbe3ac3b98da0ea2d436fe81c910a906024073449e13e5"
    sha256 cellar: :any,                 arm64_ventura:  "e2ec057e80491748229bf269ab6bb09efea684042cb7276a22d94b104174899f"
    sha256 cellar: :any,                 arm64_monterey: "9faf00ce000d93b596e896f8c78a2ea8063b64a7d865c81f2deae3374b998a1b"
    sha256 cellar: :any,                 sonoma:         "d1350c6e9bdcbaeeffc91896f006c75368baebfd4175c910680ab0ce6c7a3498"
    sha256 cellar: :any,                 ventura:        "a37f994ffd3ca83f09f7820be3dc7921db86d4a8fff22195e40db8c02ba9f109"
    sha256 cellar: :any,                 monterey:       "675e4ffcc142b39673d9d5b77cb437d1a2b7accd26719e848a3d8c9b93ab4627"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cadc760b920b5f16ae399eeb794df72890a4967a53d8b537c2211bde2ffb4a76"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "openssl@3"
  depends_on "python@3.12"
  depends_on "yara"

  # Extra resources are from `requirements.txt`: https://github.com/volatilityfoundation/volatility3#requirements
  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "capstone" do
    url "https://files.pythonhosted.org/packages/7a/fe/e6cdc4ad6e0d9603fa662d1ccba6301c0cb762a1c90a42c7146a538c24e9/capstone-5.0.1.tar.gz"
    sha256 "740afacc29861db591316beefe30df382c4da08dcb0345a0d10f0cac4f8b1ee2"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/e4/43/087b24516db11722c8687e0caf0f66c7785c0b1c51b0ab951dfde924e3f5/jsonschema-4.19.1.tar.gz"
    sha256 "ec84cc37cfa703ef7cd4928db24f9cb31428a5d0fa77747b8b51a847458e0bbf"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/12/ce/eb5396b34c28cbac19a6a8632f0e03d309135d77285536258b82120198d8/jsonschema_specifications-2023.7.1.tar.gz"
    sha256 "c91a50404e88a1f6ba40636778e2ee08f6e24c5613fe4c53ac24578a5a7f72bb"
  end

  resource "pefile" do
    url "https://files.pythonhosted.org/packages/78/c5/3b3c62223f72e2360737fd2a57c30e5b2adecd85e70276879609a7403334/pefile-2023.2.7.tar.gz"
    sha256 "82e6114004b3d6911c77c3953e3838654b04511b8b66e8583db70c65998017dc"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/1a/72/acc37a491b95849b51a2cced64df62aaff6a5c82d26aca10bc99dbda025b/pycryptodome-3.19.0.tar.gz"
    sha256 "bc35d463222cdb4dbebd35e0784155c81e161b9284e567e7e933d722e533331e"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/e1/43/d3f6cf3e1ec9003520c5fb31dc363ee488c517f09402abd2a1c90df63bbb/referencing-0.30.2.tar.gz"
    sha256 "794ad8003c65938edcdbc027f1933215e0d0ccc0291e3ce20a4d87432b59efc0"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/52/fa/31c7210f4430317c890ed0c8713093843442a98d8a9cafd0333c0040dda4/rpds_py-0.10.3.tar.gz"
    sha256 "fcc1ebb7561a3e24a6588f7c6ded15d80aec22c66a070c757559b57b17ffd1cb"
  end

  resource "yara-python" do
    url "https://files.pythonhosted.org/packages/5f/34/60a293c7ae05731c2e6366e132a9fe4c02ae84c4f57714a2f5e8651a8491/yara-python-4.3.1.tar.gz"
    sha256 "7af4354ee0f1561f51fd01771a121d8d385b93bbc6138a25a38ce68aa6801c2c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"vol", "--help"
  end
end
