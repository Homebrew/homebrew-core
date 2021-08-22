class Ykman < Formula
  include Language::Python::Virtualenv

  desc "Tool for managing your YubiKey configuration"
  homepage "https://developers.yubico.com/yubikey-manager/"
  url "https://files.pythonhosted.org/packages/19/b7/c30a01e43fba70ee138eacf36f76d3930c8f4217e3ee59f07761c72fe07c/yubikey-manager-4.0.5.tar.gz"
  sha256 "20117dbdcbe5bed6c9a172dae8452c44689c283ad1a8434e28f4e05de153f288"
  license "BSD-2-Clause"
  head "https://github.com/Yubico/yubikey-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "a6bed330081df5479a2e8e048a58cb0ea7d6a69c353d27c3aa70b03efee0854e"
    sha256 cellar: :any,                 big_sur:       "aee3deffd75f037c2b24d313108ac150318415f4772483b223145ca7e3f0fe3d"
    sha256 cellar: :any,                 catalina:      "5d97f3733d772750722edd7ed27273adba0253989d18eee10d68dea2bb51b0cb"
    sha256 cellar: :any,                 mojave:        "15faaedb93a0d15fa0e119d70b391c15d906abcea24f11bf45aa81568ca67004"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6b1fe4ffa846acb30a26b0dc04c2ac90f893cd480cca49760bcbe61cefc71d4"
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
    url "https://files.pythonhosted.org/packages/23/e2/42e3de90edfe9a7a0bde2d0a303aac447a4022778e8e552965db5a74ea8f/pyscard-2.0.1.tar.gz"
    sha256 "2ba5ed0db0ed3c98e95f9e34016aa3a57de1bc42dd9030b77a546036ee7e46d8"
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
