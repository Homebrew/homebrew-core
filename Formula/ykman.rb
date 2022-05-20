class Ykman < Formula
  include Language::Python::Virtualenv

  desc "Tool for managing your YubiKey configuration"
  homepage "https://developers.yubico.com/yubikey-manager/"
  url "https://files.pythonhosted.org/packages/26/be/0256cb9aa09f4f17c2cdae28cf61487d02876b7dd539d9420394efebb4e1/yubikey-manager-4.0.8.tar.gz"
  sha256 "f48df70df141012f250f1a3f75b4e336eecbaa9ce7f82e1e2801dd9989eff87e"
  license "BSD-2-Clause"
  revision 1
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
    url "https://files.pythonhosted.org/packages/f4/09/ad003f1e3428017d1c3da4ccc9547591703ffea548626f47ec74509c5824/click-8.0.3.tar.gz"
    sha256 "410e932b050f5eed773c4cda94de75971c89cdb3155a72a0831139a79e5ecb5b"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/f9/4b/1cf8e281f7ae4046a59e5e39dd7471d46db9f61bb564fddbff9084c4334f/cryptography-36.0.1.tar.gz"
    sha256 "53e5c1dc3d7a953de055d77bef2ff607ceef7a2aac0353b5d630ab67f7423638"
  end

  resource "fido2" do
    url "https://files.pythonhosted.org/packages/74/6e/58e1bb40a284291ab483d00831c5b91fe14d498a3ae7c658f3c588658e4b/fido2-0.9.3.tar.gz"
    sha256 "b45e89a6109cfcb7f1bb513776aa2d6408e95c4822f83a253918b944083466ec"
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
    url "https://files.pythonhosted.org/packages/57/aa/aa2610e7929fac90509eecac0f3de1049db07a6c889e3a99008e215cb665/pyscard-2.0.2.tar.gz"
    sha256 "05de0579c42b4eb433903aa2fb327d4821ebac262434b6584da18ed72053fd9e"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
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
