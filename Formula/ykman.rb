class Ykman < Formula
  include Language::Python::Virtualenv

  desc "Tool for managing your YubiKey configuration"
  homepage "https://developers.yubico.com/yubikey-manager/"
  url "https://files.pythonhosted.org/packages/0b/41/b6f3d4c71e967c61902b58ebfc39007167ac554b88b4f3eea44b4b0f41b8/yubikey-manager-4.0.0.tar.gz"
  sha256 "ab7a953ceb6f5de4487c20c02672cf7ee19ab49f0b99a9ae2f1cfa06a5d64a44"
  license "BSD-2-Clause"
  head "https://github.com/Yubico/yubikey-manager.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "a19b309fc13396408f6ac9c36232adcd9243312cf96a999b4a552ffa6953a6e2"
    sha256 cellar: :any, big_sur:       "74a42e1fa390da95cf003bbd8a23fec3fd7c4c3aa34fd1861dc36ba47fb3ebc7"
    sha256 cellar: :any, catalina:      "001843648f1a67f05ac364e912d90bbfff6eda7adb421b6184a10a156b4a4357"
    sha256 cellar: :any, mojave:        "a5bade1f58997341d493602bf45c6caeb2a47f6dddcd5c381b7840e87a3624c6"
  end

  depends_on "rust" => :build
  depends_on "swig" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.9"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "pcsc-lite"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/a8/20/025f59f929bbcaa579704f443a438135918484fffaacfaddba776b374563/cffi-1.14.5.tar.gz"
    sha256 "fd78e5fee591709f32ef6edb9a015b4aa1a5022598e36227500c8f4e02328d9c"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/fa/2d/2154d8cb773064570f48ec0b60258a4522490fcb115a6c7c9423482ca993/cryptography-3.4.6.tar.gz"
    sha256 "2d32223e5b0ee02943f32b19245b61a62db83a882f0e76cc564e1cec60d48f87"
  end

  resource "fido2" do
    url "https://files.pythonhosted.org/packages/80/c3/5077ee98edd23ee00b9f5f889fd65e8dd8dbe7717d663d3b5137e31f07e6/fido2-0.9.1.tar.gz"
    sha256 "8680ee25238e2307596eb3900a0f8c0d9cc91189146ed8039544f1a3a69dfe6e"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "pyscard" do
    url "https://files.pythonhosted.org/packages/2b/98/fd2a827eed42ca3dcd7a433ee75a9868bfe3fc1428839a2831ab9dd90c69/pyscard-2.0.0.tar.gz"
    sha256 "b364d9d9186e793c1c4709eb72a4d29e09067d36ca463b2c2abd995bd1055779"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  def install
    on_linux do
      # Fixes: smartcard/scard/helpers.c:28:22: fatal error: winscard.h: No such file or directory
      ENV.append "CFLAGS", "-I#{Formula["pcsc-lite"].opt_include}/PCSC"
    end
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ykman --version")
  end
end
