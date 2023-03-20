class Ykman < Formula
  include Language::Python::Virtualenv

  desc "Tool for managing your YubiKey configuration"
  homepage "https://developers.yubico.com/yubikey-manager/"
  url "https://files.pythonhosted.org/packages/04/3d/f94043b6cbc0e44d0824b466840097bd3599eb46a8bd7716f6a93ddc172f/yubikey_manager-5.0.1.tar.gz"
  sha256 "89e9b99211b474e38ce6687ba1fd37fa470eefeb8c1f9d47c8189c9c5bbb036f"
  license "BSD-2-Clause"
  head "https://github.com/Yubico/yubikey-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c6a3e121cdba5f024b645f341e14aaec753b454cd3a003839de177d78c26de40"
    sha256 cellar: :any,                 arm64_monterey: "7f8c9a093fc951b99114d332ceb25385298fbd1248a34ed96b63013026031682"
    sha256 cellar: :any,                 arm64_big_sur:  "ed416b97ceeeb04521e5c6d365c3eec35933c472f3301598d433778661b41d42"
    sha256 cellar: :any,                 ventura:        "b020ce89d8dc4f0e1c5e07e7ad72fe900f2329afca1cc445bbe750b626bea746"
    sha256 cellar: :any,                 monterey:       "917a5521e62d81b2d0380b282d0505634f03fa7da74329f67ddaf897fc98630d"
    sha256 cellar: :any,                 big_sur:        "a6942371ce9f176a298ea68f8c56da8b24a1380ff2d3d0c63e804515d66f52e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdfd2e70e761faf8cecde3e80b67009432239c007d42a671a2238c9722fde113"
  end

  depends_on "rust" => :build
  depends_on "swig" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.11"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "pcsc-lite"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/12/e3/c46c274cf466b24e5d44df5d5cd31a31ff23e57f074a2bb30931a8c9b01a/cryptography-39.0.0.tar.gz"
    sha256 "f964c7dcf7802d133e8dbd1565914fa0194f9d683d82411989889ecd701e8adf"
  end

  resource "fido2" do
    url "https://files.pythonhosted.org/packages/00/b9/0dfa7dec57ddec0d40a1a56ab28e6b97e31d1225787f2c80a7ab217e0ee6/fido2-1.1.0.tar.gz"
    sha256 "2b4b4e620c2100442c20678e0e951ad6d1efb3ba5ca8ebb720c4c8d543293674"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/90/07/6397ad02d31bddf1841c9ad3ec30a693a3ff208e09c2ef45c9a8a5f85156/importlib_metadata-6.0.0.tar.gz"
    sha256 "e354bedeb60efa6affdcc8ae121b73544a7aa74156d047311948f6d711cd378d"
  end

  resource "jaraco.classes" do
    url "https://files.pythonhosted.org/packages/bf/02/a956c9bfd2dfe60b30c065ed8e28df7fcf72b292b861dca97e951c145ef6/jaraco.classes-3.2.3.tar.gz"
    sha256 "89559fa5c1d3c34eff6f631ad80bb21f378dbcbb35dd161fd2c6b93f5be2f98a"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/55/fe/282f4c205add8e8bb3a1635cbbac59d6def2e0891b145aa553a0e40dd2d0/keyring-23.13.1.tar.gz"
    sha256 "ba2e15a9b35e21908d0aaf4e0a47acc52d6ae33444df0da2b49d41a46ef6d678"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/13/b3/397aa9668da8b1f0c307bc474608653d46122ae0563d1d32f60e24fa0cbd/more-itertools-9.0.0.tar.gz"
    sha256 "5a6257e40878ef0520b1803990e3e22303a41b5714006c32a3fd8304b26ea1ab"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pyscard" do
    url "https://files.pythonhosted.org/packages/07/64/62200892980cacc2968ab6e5ae6ddd345c8b96e2e2076aea9e0459fc540b/pyscard-2.0.5.tar.gz"
    sha256 "dc13e34837addbd96c07a1a919fbc1677b2b83266f530a1f79c96930db42ccde"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/8e/b3/8b16a007184714f71157b1a71bbe632c5d66dd43bc8152b3c799b13881e1/zipp-3.11.0.tar.gz"
    sha256 "a7a22e05929290a67401440b39690ae6563279bced5f314609d9d03798f56766"
  end

  def install
    # Fixes: smartcard/scard/helpers.c:28:22: fatal error: winscard.h: No such file or directory
    ENV.append "CFLAGS", "-I#{Formula["pcsc-lite"].opt_include}/PCSC" if OS.linux?

    virtualenv_install_with_resources
    man1.install "man/ykman.1"

    # Click doesn't support generating completions for Bash versions older than 4.4
    generate_completions_from_executable(bin/"ykman", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ykman --version")
  end
end
