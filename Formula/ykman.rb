class Ykman < Formula
  include Language::Python::Virtualenv

  desc "Tool for managing your YubiKey configuration"
  homepage "https://developers.yubico.com/yubikey-manager/"
  url "https://files.pythonhosted.org/packages/2f/95/72634c119aada75b816cbd319a2ae44ee69639588a149579059fd77df037/yubikey-manager-4.0.3.tar.gz"
  sha256 "a7bb6ffdb8fa3cc0a7094e63f15862eb42f12e23e64750ae7fcc5574356d66f4"
  license "BSD-2-Clause"
  head "https://github.com/Yubico/yubikey-manager.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e8f7b0f43cddea4340ef004a655b9266c54fc7de654da661e9fa021339c72089"
    sha256 cellar: :any, big_sur:       "c1b30a71bba7dcd8c5fc71e35ef011b4665586de129762a72afe00a551f0672b"
    sha256 cellar: :any, catalina:      "46aca102b3c8cdad01b5366849893f8476f78c37bef9853b8f22d4e2eda50b88"
    sha256 cellar: :any, mojave:        "66b2cfd1a7c3fc74f75d450eb114e128f8fe2c9c2721d905e74ada4515f0599f"
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
    url "https://files.pythonhosted.org/packages/d5/99/286fd2fdfb501620a9341319ba47444040c7b3094d3b6c797d7281469bf8/click-8.0.0.tar.gz"
    sha256 "7d8c289ee437bcb0316820ccee14aefcb056e58d31830ecab8e47eda6540e136"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/9b/77/461087a514d2e8ece1c975d8216bc03f7048e6090c5166bc34115afdaa53/cryptography-3.4.7.tar.gz"
    sha256 "3d10de8116d25649631977cb37da6cbdd2d6fa0e0281d014a5b7d337255ca713"
  end

  resource "fido2" do
    url "https://files.pythonhosted.org/packages/80/c3/5077ee98edd23ee00b9f5f889fd65e8dd8dbe7717d663d3b5137e31f07e6/fido2-0.9.1.tar.gz"
    sha256 "8680ee25238e2307596eb3900a0f8c0d9cc91189146ed8039544f1a3a69dfe6e"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/98/cd/cbc9c152daba9b5de6094a185c66f1c6eb91c507f378bb7cad83d623ea88/pyOpenSSL-20.0.1.tar.gz"
    sha256 "4c231c759543ba02560fcd2480c48dcec4dae34c9da7d3747c508227e0624b51"
  end

  resource "pyscard" do
    url "https://files.pythonhosted.org/packages/2b/98/fd2a827eed42ca3dcd7a433ee75a9868bfe3fc1428839a2831ab9dd90c69/pyscard-2.0.0.tar.gz"
    sha256 "b364d9d9186e793c1c4709eb72a4d29e09067d36ca463b2c2abd995bd1055779"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
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
