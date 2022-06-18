class Ykman < Formula
  include Language::Python::Virtualenv

  desc "Tool for managing your YubiKey configuration"
  homepage "https://developers.yubico.com/yubikey-manager/"
  url "https://files.pythonhosted.org/packages/f8/67/734ba60a918822d2f35d5120e81a277f1f0274fcbd8e02ff7486ef9157cc/yubikey-manager-4.0.9.tar.gz"
  sha256 "384e3a2a66df4ce417aede734eb8c5d0c1b7981290e9bc940c85cc000ef833b4"
  license "BSD-2-Clause"
  head "https://github.com/Yubico/yubikey-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "dfafd17a3655873c508580b14257bd8678bfe885c53421e82f21c63a53ecfd05"
    sha256 cellar: :any,                 arm64_big_sur:  "5a4b8dc4ccc9f9f45b83da488c4ca22752be27db8d0151bb40d30fb49258194f"
    sha256 cellar: :any,                 monterey:       "2d1b4bcf82e6dd07d57c2c08dd4d616d14d803396f56819b3c7ea1c106cdb970"
    sha256 cellar: :any,                 big_sur:        "db85646b8f751ce09dde17117052c31eb6e873a4a23a660c6292d98b802e5b8c"
    sha256 cellar: :any,                 catalina:       "9195734e808c6c04241db0266f861ab1e6ac32b4a764e4874bb3adeeaa5bfcb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1e7fc758253a96859da9aadfd8b21322c48d0aaa0c722948a49a6932403ab3b"
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
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/51/05/bb2b681f6a77276fc423d04187c39dafdb65b799c8d87b62ca82659f9ead/cryptography-37.0.2.tar.gz"
    sha256 "f224ad253cc9cea7568f49077007d2263efa57396a2f2f78114066fd54b5c68e"
  end

  resource "fido2" do
    url "https://files.pythonhosted.org/packages/cd/69/1af41955530255ca2337bab370a75b3dbbb8be8707f6280c9efedfb77a85/fido2-1.0.0.tar.gz"
    sha256 "2509a4958b666d747fd5754dfa9357da2d81b52edc0ecff75b68cea939154c02"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/35/d3/d6a9610f19d943e198df502ae660c6b5acf84cc3bc421a2aa3c0fb6b21d1/pyOpenSSL-22.0.0.tar.gz"
    sha256 "660b1b1425aac4a1bea1d94168a85d99f0b3144c869dd4390d27629d0087f1bf"
  end

  resource "pyscard" do
    url "https://files.pythonhosted.org/packages/10/00/8dcf33f0695ea3b1eac265c95a6d61cae138eb60527d9f58d7dd7b8cc812/pyscard-2.0.3.tar.gz"
    sha256 "13c3e108163fac4f1237804ed20c5b1eb1bd5d5ee3e96adb60bfb6b9122f528d"
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
