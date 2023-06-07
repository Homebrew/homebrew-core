class Ykman < Formula
  include Language::Python::Virtualenv

  desc "Tool for managing your YubiKey configuration"
  homepage "https://developers.yubico.com/yubikey-manager/"
  url "https://files.pythonhosted.org/packages/8e/70/d4c632df03f0c1f45ce26981a356fd10fe3ae49fccc1856769448efe396a/yubikey_manager-5.1.1.tar.gz"
  sha256 "684102affd4a0d29611756da263c22f8e67226e80f65c5460c8c5608f9c0d58d"
  license "BSD-2-Clause"
  head "https://github.com/Yubico/yubikey-manager.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "16d73a9bcd0cbab8c501bfe1f4af4c8e3e5e458ff03b62ef187480d158e5bee5"
    sha256 cellar: :any,                 arm64_monterey: "6c566a0a2a85f9227c1f8420e68bb1873724f7d16bb21eec51227f692fe6d080"
    sha256 cellar: :any,                 arm64_big_sur:  "86510a60a57998b0f3874238462b5fd7da1f9ea166450caf318f8c2d4a55dadb"
    sha256 cellar: :any,                 ventura:        "94a4d9626d905c44d687fbb3b7234a18ff730b0d81365003a94872e166c30350"
    sha256 cellar: :any,                 monterey:       "fc4dee659f6d6c91586335a2fafacd416174905c4e6cffcd191ee817efd17bf0"
    sha256 cellar: :any,                 big_sur:        "b0f604d6f78ba03293f27e4af3161906d8d853a413633fb48dc16b79f8b918c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cea7c51079181942ad49eba474a4199565dcf348ef8487cdc010a299d8ca324"
  end

  # `pkg-config` and `rust` are for cryptography.
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "swig" => :build
  depends_on "cffi"
  depends_on "keyring"
  depends_on "openssl@1.1"
  depends_on "pycparser"
  depends_on "python@3.11"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pcsc-lite"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/19/8c/47f061de65d1571210dc46436c14a0a4c260fd0f3eaf61ce9b9d445ce12f/cryptography-41.0.1.tar.gz"
    sha256 "d34579085401d3f49762d2f7d6634d6b6c2ae1242202e860f4d26b046e3a1006"
  end

  resource "fido2" do
    url "https://files.pythonhosted.org/packages/5a/67/244ad51cb9fd87eaf8797820d95e79d6d5f940c0aafe931e8051b60dd8a0/fido2-1.1.1.tar.gz"
    sha256 "5dc495ca8c59c1c337383b4b8c314d46b92d5c6fc650e71984c6d7f954079fc3"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/0b/1f/9de392c2b939384e08812ef93adf37684ec170b5b6e7ea302d9f163c2ea0/importlib_metadata-6.6.0.tar.gz"
    sha256 "92501cdf9cc66ebd3e612f1b4f0c0765dfa42f0fa38ffb319b6bd84dd675d705"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/bf/02/a956c9bfd2dfe60b30c065ed8e28df7fcf72b292b861dca97e951c145ef6/jaraco.classes-3.2.3.tar.gz"
    sha256 "89559fa5c1d3c34eff6f631ad80bb21f378dbcbb35dd161fd2c6b93f5be2f98a"
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
    url "https://files.pythonhosted.org/packages/00/27/f0ac6b846684cecce1ee93d32450c45ab607f65c2e0255f0092032d91f07/zipp-3.15.0.tar.gz"
    sha256 "112929ad649da941c23de50f356a2b5570c954b65150642bccdd66bf194d224b"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    # Fixes: smartcard/scard/helpers.c:28:22: fatal error: winscard.h: No such file or directory
    ENV.append "CFLAGS", "-I#{Formula["pcsc-lite"].opt_include}/PCSC" if OS.linux?

    # Fix `ModuleNotFoundError` issue with `keyring``
    site_packages = Language::Python.site_packages("python3.11")
    (libexec/site_packages/"homebrew-keyring.pth").write Formula["keyring"].opt_libexec/site_packages
    virtualenv_install_with_resources
    man1.install "man/ykman.1"

    # Click doesn't support generating completions for Bash versions older than 4.4
    generate_completions_from_executable(bin/"ykman", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ykman --version")
  end
end
