class Ykman < Formula
  include Language::Python::Virtualenv

  desc "Tool for managing your YubiKey configuration"
  homepage "https://developers.yubico.com/yubikey-manager/"
  url "https://files.pythonhosted.org/packages/ca/22/c973548be0286e3bd3599e525c6de55b4535e38f0feff165442777db0f24/yubikey_manager-5.4.0.tar.gz"
  sha256 "53726a186722cd2683b2f5fd781fc0a2861f47ce62ba9d3527960832c8fabec8"
  license "BSD-2-Clause"
  head "https://github.com/Yubico/yubikey-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b8db2c41cd23fd0b1df0826bb39448a92d11f79513907bd5af33c6395d692c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c198a828a247a6f35f1427904ddc14f6719d2ff08e4fa644bc528323c5c338d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b30835f61e282c8c23a73e73e9b960cd3d6440e5db22f4983e2e6acb7830c5a"
    sha256 cellar: :any_skip_relocation, sonoma:         "69141b742777be8711a97fb5cf84f5f1f6f01f2b82eddb75caae1eb965386656"
    sha256 cellar: :any_skip_relocation, ventura:        "fb9ef6edda20fcd01e607dbeef709d7aa4b883db6318ad1fc93b20b82ff7ded5"
    sha256 cellar: :any_skip_relocation, monterey:       "f605645a199c0fd0203f3509c8565f61848fd52ac4f09cbeeb3901ff834f8e57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cb94fd189933ebda03e4f337ad0e41d3a8cefdb3ac33dd25463c847d11b044a"
  end

  depends_on "swig" => :build
  depends_on "cryptography"
  depends_on "python@3.12"

  uses_from_macos "pcsc-lite"

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "fido2" do
    url "https://files.pythonhosted.org/packages/78/6c/79d44841549cc3d95bdfbeaa6bc7b36892c86066b05aac44585c56113819/fido2-1.1.3.tar.gz"
    sha256 "26100f226d12ced621ca6198528ce17edf67b78df4287aee1285fee3cd5aa9fc"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/a5/8a/ed955184b2ef9c1eef3aa800557051c7354e5f40a9efc9a46e38c3e6d237/jaraco.classes-3.3.1.tar.gz"
    sha256 "cb28a5ebda8bc47d8c8015307d93163464f9f2b91ab4006e09ff0ce07e8bfb30"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/d6/f4/154cf374c2daf2020e05c3c6a03c91348d59b23c5366e968feb198306fdf/jeepney-0.8.0.tar.gz"
    sha256 "5efe48d255973902f6badc3ce55e2aa6c5c3b3bc642059ef3a91247bcfcc5806"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/ae/6c/bd2cfc6c708ce7009bdb48c85bb8cad225f5638095ecc8f49f15e8e1f35e/keyring-24.3.1.tar.gz"
    sha256 "c3327b6ffafc0e8befbdb597cacdb4928ffe5c1212f7645f186e6d9957a898db"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/df/ad/7905a7fd46ffb61d976133a4f47799388209e73cbc8c1253593335da88b4/more-itertools-10.2.0.tar.gz"
    sha256 "8fccb480c43d3e99a00087634c06dd02b0d50fbf088b380de5a41a015ec239e1"
  end

  resource "pyscard" do
    url "https://files.pythonhosted.org/packages/27/f9/290e3af3b9cf367d8bc9ffe13f537d26ba37ba93b1eae90777125d22d822/pyscard-2.0.8.tar.gz"
    sha256 "2eb16ee0e89ab27759fcb36f032c40a5774ed5926c0e03309837bdeb563a6032"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/53/a4/f48c9d79cb507ed1373477dbceaba7401fd8a23af63b837fa61f1dcd3691/SecretStorage-3.3.3.tar.gz"
    sha256 "2403533ef369eca6d2ba81718576c5e0f564d5cca1b58f73a8b23e7d4eeebd77"
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
