class Ykman < Formula
  include Language::Python::Virtualenv

  desc "Tool for managing your YubiKey configuration"
  homepage "https://developers.yubico.com/yubikey-manager/"
  url "https://files.pythonhosted.org/packages/b5/50/9b446ca65124bbd7bc0e74304cda737248a6bceb602e5dba957114ab64df/yubikey_manager-5.5.1.tar.gz"
  sha256 "2b1f4e70813973c646eb301c8f2513faf5e4736dd3c564422efdce0349c02afd"
  license "BSD-2-Clause"
  head "https://github.com/Yubico/yubikey-manager.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c1a51549190e50c58bb4f156bfc05142638d035172dcf06b02a46925f8d44d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cc4af14ae4368555188ffbe241ffe6f3e96b220fe19d4c91c2fda9f254bb875"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b8c8f986ae301fe9da789f6d884382ef89c2e45a3a12f77777dbd66722a7e05a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a8b6613e11c4bbb6b7fb29b931307d07ad5bc7672f8cfb212b8718c7380c33e"
    sha256 cellar: :any_skip_relocation, ventura:       "188c58747a72d839997a54364397fc805a69184aad6c2b0a7e7c972741ad8885"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dea8fe07ef8aafe9d3ef8b5e95447571effee4910b41f0659acaa22227759144"
  end

  depends_on "swig" => :build
  depends_on "cryptography"
  depends_on "python@3.13"

  uses_from_macos "pcsc-lite"

  # pin pyscard to 2.0.8, upstream bug report, https://github.com/LudovicRousseau/pyscard/issues/169

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "fido2" do
    url "https://files.pythonhosted.org/packages/78/6c/79d44841549cc3d95bdfbeaa6bc7b36892c86066b05aac44585c56113819/fido2-1.1.3.tar.gz"
    sha256 "26100f226d12ced621ca6198528ce17edf67b78df4287aee1285fee3cd5aa9fc"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/df/ad/f3777b81bf0b6e7bc7514a1656d3e637b2e8e15fab2ce3235730b3e7a4e6/jaraco_context-6.0.1.tar.gz"
    sha256 "9bae4ea555cf0b14938dc0aee7c9f32ed303aa20a3b73e7dc80111628792d1b3"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/ab/23/9894b3df5d0a6eb44611c36aec777823fc2e07740dabbd0b810e19594013/jaraco_functools-4.1.0.tar.gz"
    sha256 "70f7e0e2ae076498e212562325e805204fc092d7b4c17e0e86c959e249701a9d"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/d6/f4/154cf374c2daf2020e05c3c6a03c91348d59b23c5366e968feb198306fdf/jeepney-0.8.0.tar.gz"
    sha256 "5efe48d255973902f6badc3ce55e2aa6c5c3b3bc642059ef3a91247bcfcc5806"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/a5/1c/2bdbcfd5d59dc6274ffb175bc29aa07ecbfab196830e0cfbde7bd861a2ea/keyring-25.4.1.tar.gz"
    sha256 "b07ebc55f3e8ed86ac81dd31ef14e81ace9dd9c3d4b5d77a6e9a2016d0d71a1b"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/51/78/65922308c4248e0eb08ebcbe67c95d48615cc6f27854b6f2e57143e9178f/more-itertools-10.5.0.tar.gz"
    sha256 "5482bfef7849c25dc3c6dd53a6173ae4795da2a41a80faea6700d9f5846c5da6"
  end

  resource "pyscard" do
    url "https://files.pythonhosted.org/packages/58/90/e0c09842070fe0e4e6eaf9164d3995fdfe74b5f2678e6d27b81db696ec1d/pyscard-2.1.1.tar.gz"
    sha256 "f9b0dc3fad83ac72a9335af4d04b608edc9d01e2b90e0c38ed0ef1fd014c4414"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/53/a4/f48c9d79cb507ed1373477dbceaba7401fd8a23af63b837fa61f1dcd3691/SecretStorage-3.3.3.tar.gz"
    sha256 "2403533ef369eca6d2ba81718576c5e0f564d5cca1b58f73a8b23e7d4eeebd77"
  end

  def install
    # Fixes: smartcard/scard/helpers.c:28:22: fatal error: winscard.h: No such file or directory
    ENV.append "CFLAGS", "-I#{Formula["pcsc-lite"].opt_include}/PCSC" if OS.linux?

    venv = virtualenv_install_with_resources without: "pyscard"
    # Use brewed swig
    # https://github.com/Homebrew/homebrew-core/pull/176069#issuecomment-2200583084
    # https://github.com/LudovicRousseau/pyscard/issues/169#issuecomment-2200632337
    resource("pyscard").stage do
      inreplace "pyproject.toml", 'requires = ["setuptools","swig"]', 'requires = ["setuptools"]'
      venv.pip_install Pathname.pwd
    end

    man1.install "man/ykman.1"

    # Click doesn't support generating completions for Bash versions older than 4.4
    generate_completions_from_executable(bin/"ykman", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ykman --version")
  end
end
