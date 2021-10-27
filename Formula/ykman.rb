class Ykman < Formula
  include Language::Python::Virtualenv

  desc "Tool for managing your YubiKey configuration"
  homepage "https://developers.yubico.com/yubikey-manager/"
  url "https://files.pythonhosted.org/packages/53/6a/a3ff56677f0ebb14d56c43bce4b6cc9b494920e470b45c385285ebfca3fe/yubikey-manager-4.0.7.tar.gz"
  sha256 "9972db8a1c7c13eb1a618015a8ad8011c03a045a08fee248e5de4f120f55fc4f"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/Yubico/yubikey-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "79abda55160cd30a6287c24a2e9146eb3352ef0041c7e3e84f20b166dc469105"
    sha256 cellar: :any,                 arm64_big_sur:  "fd85250ee051dd400d046ff2d950cc08fa13e62e4ed510561130f109e67a381f"
    sha256 cellar: :any,                 monterey:       "561453d58cee66db7a264bc20a952607beab864dda09608ea0d25c7d88a18553"
    sha256 cellar: :any,                 big_sur:        "b9ae9a5530e4ae78cfd3ed7312f0328b3f3e9e37373e410160612fa41bffca07"
    sha256 cellar: :any,                 catalina:       "8ca23d5defacb45cddc59075950aa75f7e25127d69e297001e6fe6c3e0411609"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bc3d373b749caa00e6f79f141f0b87cd335b8190579b6736ca811d2dda6b744"
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
    url "https://files.pythonhosted.org/packages/2e/92/87bb61538d7e60da8a7ec247dc048f7671afe17016cd0008b3b710012804/cffi-1.14.6.tar.gz"
    sha256 "c9a875ce9d7fe32887784274dd533c57909b7b1dcadcc128a2ac21331a9765dd"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/21/83/308a74ca1104fe1e3197d31693a7a2db67c2d4e668f20f43a2fca491f9f7/click-8.0.1.tar.gz"
    sha256 "8c04c11192119b1ef78ea049e0a6f0463e4c48ef00a30160c704337586f3ad7a"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/cc/98/8a258ab4787e6f835d350639792527d2eb7946ff9fc0caca9c3f4cf5dcfe/cryptography-3.4.8.tar.gz"
    sha256 "94cc5ed4ceaefcbe5bf38c8fba6a21fc1d365bb8fb826ea1688e3370b2e24a1c"
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
    url "https://files.pythonhosted.org/packages/23/e2/42e3de90edfe9a7a0bde2d0a303aac447a4022778e8e552965db5a74ea8f/pyscard-2.0.1.tar.gz"
    sha256 "2ba5ed0db0ed3c98e95f9e34016aa3a57de1bc42dd9030b77a546036ee7e46d8"
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
