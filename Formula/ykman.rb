class Ykman < Formula
  include Language::Python::Virtualenv

  desc "Tool for managing your YubiKey configuration"
  homepage "https://developers.yubico.com/yubikey-manager/"
  url "https://files.pythonhosted.org/packages/8e/70/d4c632df03f0c1f45ce26981a356fd10fe3ae49fccc1856769448efe396a/yubikey_manager-5.1.1.tar.gz"
  sha256 "684102affd4a0d29611756da263c22f8e67226e80f65c5460c8c5608f9c0d58d"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/Yubico/yubikey-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fd69062c71260f82ded3eadce55f50823e08b3b6838f7d54c68e84bc7f0c6b13"
    sha256 cellar: :any,                 arm64_monterey: "8fad443f0384e39763f0cbb3077932c8cb333b0200268fb4c4d6eea8e33dc0ac"
    sha256 cellar: :any,                 arm64_big_sur:  "519eb524e55b285162a261217416ad67bfc0e2a4a34b6a8abddfc4f886882256"
    sha256 cellar: :any,                 ventura:        "fc3bb0d70b81d63ee0f6e1d7e158d286dbf2ef74bef59a11bfb661d530068f04"
    sha256 cellar: :any,                 monterey:       "9c88a7448a91c8b10cefcddda0fae2381fccf883f5a9551b683b39840f0338e0"
    sha256 cellar: :any,                 big_sur:        "9f56cdc199b0b304b3af2a2307d48388a6cf9f944b720f572b03af15ec450924"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a781a4520dec47fcac4b70c1621ad18d37c92e22d750435318e97e3331b34416"
  end

  # `pkg-config` and `rust` are for cryptography.
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "swig" => :build
  depends_on "cffi"
  depends_on "keyring"
  depends_on "openssl@3"
  depends_on "pycparser"
  depends_on "python@3.11"

  uses_from_macos "libffi"
  uses_from_macos "pcsc-lite"

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
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

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
