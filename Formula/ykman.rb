class Ykman < Formula
  include Language::Python::Virtualenv

  desc "Tool for managing your YubiKey configuration"
  homepage "https://developers.yubico.com/yubikey-manager/"
  url "https://files.pythonhosted.org/packages/3e/95/4ef7bfe063e595e9e7ed4c58228d1f07a2ccb3b3a55f01bb2128b347f900/yubikey_manager-5.0.0.tar.gz"
  sha256 "c741747200ced1b5803dfdef6718b07a41e109ccb03dd7b72d3a307a3fb33bb5"
  license "BSD-2-Clause"
  head "https://github.com/Yubico/yubikey-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "15df54911e49fb6587f25a118ac7298f12b23d52d353c03b3a025e13f723db0f"
    sha256 cellar: :any,                 arm64_big_sur:  "a5fe7a9b79cb4aa376e6252e00e581eb7240249724531aa2fc24ae4ec3a12bfc"
    sha256 cellar: :any,                 monterey:       "047fef4ac134412addc87edd7b7f86ec87c648b4acbb9a96ef8c6e138301a3c7"
    sha256 cellar: :any,                 big_sur:        "451d0584cd81f4e2dae215d4eeb087b273b81c4187132c1c87eb51f23356bc3b"
    sha256 cellar: :any,                 catalina:       "f7e5c72a377d524e1cd2428f7c620ed51da549465820e9ab8fe5398886dc59bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41e8f8540b98f9fe6d1bf92bce80590f0be5c89c34b1f29a926b23aba4b26adc"
  end

  depends_on "rust" => :build
  depends_on "swig" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.10"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "pcsc-lite"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/6d/0c/5e67831007ba6cd7e52c4095f053cf45c357739b0a7c46a45ddd50049019/cryptography-38.0.1.tar.gz"
    sha256 "1db3d807a14931fa317f96435695d9ec386be7b84b618cc61cfa5d08b0ae33d7"
  end

  resource "fido2" do
    url "https://files.pythonhosted.org/packages/00/b9/0dfa7dec57ddec0d40a1a56ab28e6b97e31d1225787f2c80a7ab217e0ee6/fido2-1.1.0.tar.gz"
    sha256 "2b4b4e620c2100442c20678e0e951ad6d1efb3ba5ca8ebb720c4c8d543293674"
  end

  resource "jaraco.classes" do
    url "https://files.pythonhosted.org/packages/bf/02/a956c9bfd2dfe60b30c065ed8e28df7fcf72b292b861dca97e951c145ef6/jaraco.classes-3.2.3.tar.gz"
    sha256 "89559fa5c1d3c34eff6f631ad80bb21f378dbcbb35dd161fd2c6b93f5be2f98a"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/2a/ef/28d3d5428108111dae4304a2ebec80d113aea9e78c939e25255425d486ff/keyring-23.9.3.tar.gz"
    sha256 "69b01dd83c42f590250fe7a1f503fc229b14de83857314b1933a3ddbf595c4a5"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/13/b3/397aa9668da8b1f0c307bc474608653d46122ae0563d1d32f60e24fa0cbd/more-itertools-9.0.0.tar.gz"
    sha256 "5a6257e40878ef0520b1803990e3e22303a41b5714006c32a3fd8304b26ea1ab"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pyscard" do
    url "https://files.pythonhosted.org/packages/07/64/62200892980cacc2968ab6e5ae6ddd345c8b96e2e2076aea9e0459fc540b/pyscard-2.0.5.tar.gz"
    sha256 "dc13e34837addbd96c07a1a919fbc1677b2b83266f530a1f79c96930db42ccde"
  end

  def install
    if OS.linux?
      # Fixes: smartcard/scard/helpers.c:28:22: fatal error: winscard.h: No such file or directory
      ENV.append "CFLAGS", "-I#{Formula["pcsc-lite"].opt_include}/PCSC"
    end
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ykman --version")
  end
end
