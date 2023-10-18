class Ykman < Formula
  include Language::Python::Virtualenv

  desc "Tool for managing your YubiKey configuration"
  homepage "https://developers.yubico.com/yubikey-manager/"
  url "https://files.pythonhosted.org/packages/e4/25/3a42efa20f10f7bcec116ee678c36fb9a58b8cc12699be9603f1378d6f17/yubikey_manager-5.2.1.tar.gz"
  sha256 "35c5aa83ac474fd2434c33267dc0e33d312b3969b108f885e533463af3fbe4e1"
  license "BSD-2-Clause"
  head "https://github.com/Yubico/yubikey-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "35cd1418b76d76a8ba0e8c2dba1429748a20c75b09e2a410d54d7e6998c41f20"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44bbdebaacfce85b6dcd49e26f79be93abf95d01d5fdb972d002e424ad669cca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f083e8ba283f53f8c2a40f41ed7f38fdc40f6ff08241385e13b1fbda895e3b04"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac2478389dbbd8dbc8a12920dfb4efd99a05e45c2b60a88736bfd9322134020d"
    sha256 cellar: :any_skip_relocation, ventura:        "c6090f2cacd842cd95c831855f72401c58638319d65bc7d3c2c5a159a1ac008a"
    sha256 cellar: :any_skip_relocation, monterey:       "58809755a556f0e10b97c3e082d6c1d6b138f15ce323cab49fde7079ffee3e23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fae51a2122894b5e859b969dd799cd90815a8156e8ae2e49797168acdc65eadf"
  end

  depends_on "swig" => :build
  depends_on "cffi"
  depends_on "keyring"
  depends_on "pycparser"
  depends_on "python-cryptography"
  depends_on "python@3.11"

  uses_from_macos "libffi"
  uses_from_macos "pcsc-lite"

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

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
    site_packages = Language::Python.site_packages("python3.11")
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
