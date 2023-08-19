class Ykman < Formula
  include Language::Python::Virtualenv

  desc "Tool for managing your YubiKey configuration"
  homepage "https://developers.yubico.com/yubikey-manager/"
  url "https://files.pythonhosted.org/packages/8e/70/d4c632df03f0c1f45ce26981a356fd10fe3ae49fccc1856769448efe396a/yubikey_manager-5.1.1.tar.gz"
  sha256 "684102affd4a0d29611756da263c22f8e67226e80f65c5460c8c5608f9c0d58d"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/Yubico/yubikey-manager.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02472f99430c2acf79707fc6daf08b5fbba173f6e49272f9720be65a646b4277"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "932871713f6120ead63242e92bb5161c6970e9653e2474f1bb3ec727d9238a76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32aaf52b2f1eb2470ae08a03238fdbc81e5e74ff3fe183f30f3f5dca54153943"
    sha256 cellar: :any_skip_relocation, ventura:        "6c415f4a15e876176bdf54c2dc58c6b304854f17ea478e4289f22820db0daf12"
    sha256 cellar: :any_skip_relocation, monterey:       "1257daac542e2fdfda45584f9cc6052db16a53f34739a9996841134746ff201d"
    sha256 cellar: :any_skip_relocation, big_sur:        "25f7a78b74870c6b1160605179eebe193a82b769f902b864fb2880fe0f1433aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c675b26e1d23eefed38c3c7516029024028ef1aec832b0269c7ce3d9c8c0aa4"
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
    url "https://files.pythonhosted.org/packages/7e/ad/7a6a96fab480fb2fbf52f782b2deb3abe1d2c81eca3ef68a575b5a6a4f2e/click-8.1.5.tar.gz"
    sha256 "4be4b1af8d665c6d942909916d31a213a106800c47d0eeba73d34da3cbc11367"
  end

  resource "fido2" do
    url "https://files.pythonhosted.org/packages/a7/0f/b9f940372e0baa5a44742012f1eef1563296569db030a422ef3ce287b0ac/fido2-1.1.2.tar.gz"
    sha256 "6110d913106f76199201b32d262b2857562cc46ba1d0b9c51fbce30dc936c573"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/33/44/ae06b446b8d8263d712a211e959212083a5eda2bf36d57ca7415e03f6f36/importlib_metadata-6.8.0.tar.gz"
    sha256 "dbace7892d8c0c4ac1ad096662232f831d4e64f4c4545bd53016a3e9d4654743"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/8b/de/d0a466824ce8b53c474bb29344e6d6113023eb2c3793d1c58c0908588bfa/jaraco.classes-3.3.0.tar.gz"
    sha256 "c063dd08e89217cee02c8d5e5ec560f2c8ce6cdc2fcdc2e68f7b2e5547ed3621"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/2e/d0/bea165535891bd1dcb5152263603e902c0ec1f4c9a2e152cc4adff6b3a38/more-itertools-9.1.0.tar.gz"
    sha256 "cabaa341ad0389ea83c17a94566a53ae4c9d07349861ecb14dc6d0345cf9ac5d"
  end

  resource "pyscard" do
    url "https://files.pythonhosted.org/packages/cc/33/b7d115ccf1b594af18db7ca61a7b07192356be35c65dfcd1d5ef9b28dc0a/pyscard-2.0.7.tar.gz"
    sha256 "278054525fa75fbe8b10460d87edcd03a70ad94d688b11345e4739987f85c1bf"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/e2/45/f3b987ad5bf9e08095c1ebe6352238be36f25dd106fde424a160061dce6d/zipp-3.16.2.tar.gz"
    sha256 "ebc15946aa78bd63458992fc81ec3b6f7b1e92d51c35e6de1c3804e73b799147"
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
