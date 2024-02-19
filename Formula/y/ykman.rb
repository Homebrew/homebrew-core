class Ykman < Formula
  include Language::Python::Virtualenv

  desc "Tool for managing your YubiKey configuration"
  homepage "https://developers.yubico.com/yubikey-manager/"
  url "https://files.pythonhosted.org/packages/7f/7d/a488f1c4d8847e25234902cb7230dc572bebc5ed8dbd29b5f5fa9b8889a4/yubikey_manager-5.3.0.tar.gz"
  sha256 "5492c36a10ce6a5995b8ea1d32cf5bd60db7587201b2aa3e63e0c1da2334b8b6"
  license "BSD-2-Clause"
  head "https://github.com/Yubico/yubikey-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5dfeb6ab1346b5f10a15af6834023a63245fe7bb11b667f6ff8906d8e269af30"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3da2d10a4db96c4682a1da99bab5888fad542373bad6d0204e8ebc1497220b97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8547034f9ede445c32de0f6a17159b8903cf6affe8d75ae3660c3ed8f29f394a"
    sha256 cellar: :any_skip_relocation, sonoma:         "56f8d92d910a8ef0ffa290e47bc6ee4222b53481686d93f472c95f868bf540c2"
    sha256 cellar: :any_skip_relocation, ventura:        "7c49ed4b8fa1d01bec1988c97dd9c375193e40563ec93a84a99982fc7077e0e6"
    sha256 cellar: :any_skip_relocation, monterey:       "83e20660f76c38b111ed43cf3347e879b64e2287d30557fa4eb4f283004273fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d4c0663b57930f2820e6f91802926a0c5fe3c358d0ed6ec2afb9cd384b2f1b0"
  end

  depends_on "swig" => :build
  depends_on "cffi"
  depends_on "keyring"
  depends_on "pycparser"
  depends_on "python-click"
  depends_on "python-cryptography"
  depends_on "python@3.12"

  uses_from_macos "libffi"
  uses_from_macos "pcsc-lite"

  resource "fido2" do
    url "https://files.pythonhosted.org/packages/a7/0f/b9f940372e0baa5a44742012f1eef1563296569db030a422ef3ce287b0ac/fido2-1.1.2.tar.gz"
    sha256 "6110d913106f76199201b32d262b2857562cc46ba1d0b9c51fbce30dc936c573"
  end

  resource "pyscard" do
    url "https://files.pythonhosted.org/packages/cc/33/b7d115ccf1b594af18db7ca61a7b07192356be35c65dfcd1d5ef9b28dc0a/pyscard-2.0.7.tar.gz"
    sha256 "278054525fa75fbe8b10460d87edcd03a70ad94d688b11345e4739987f85c1bf"
  end

  def install
    # Fixes: smartcard/scard/helpers.c:28:22: fatal error: winscard.h: No such file or directory
    ENV.append "CFLAGS", "-I#{Formula["pcsc-lite"].opt_include}/PCSC" if OS.linux?

    # Fix `ModuleNotFoundError` issue with `keyring``
    site_packages = Language::Python.site_packages("python3.12")
    keyring_site_packages = Formula["keyring"].opt_libexec/site_packages
    ENV.prepend_path "PYTHONPATH", keyring_site_packages

    virtualenv_install_with_resources
    man1.install "man/ykman.1"

    (libexec/site_packages/"homebrew-keyring.pth").write keyring_site_packages

    # Click doesn't support generating completions for Bash versions older than 4.4
    generate_completions_from_executable(bin/"ykman", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ykman --version")
  end
end
