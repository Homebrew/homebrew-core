class Ykman < Formula
  include Language::Python::Virtualenv

  desc "Tool for managing your YubiKey configuration"
  homepage "https://developers.yubico.com/yubikey-manager/"
  url "https://files.pythonhosted.org/packages/b3/09/ba3ca95ed3c8adfb7f8288a33048a963dcc5741eb3e819a8451b65e36a59/yubikey_manager-5.8.0.tar.gz"
  sha256 "3af0da65e1fdd46763c94ee74e2da55a4b6e7771da776c197f5f4b4581738560"
  license "BSD-2-Clause"
  head "https://github.com/Yubico/yubikey-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6909d0793a8d4a46fe2addead13463df85b23f74e8a1448de1ce6eee16e30726"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ac3af9f2abea7483614826752d9648e66203a0bf548d502fe7c58e67487d679"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "755808104b72db99dc35ca6e5ed2677ea2d39f14d23a77b11b2a0439266ee050"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae149c8fc144ec9619abc1629a6fa6869f5c2f455f0f056f910174480c924c63"
    sha256 cellar: :any_skip_relocation, sonoma:        "aaefc2cd5bdeece2423f47faf62faf46691dd5912997787433898446f39fd528"
    sha256 cellar: :any_skip_relocation, ventura:       "eba5ae83ef27b8c1873e7b5faf2a8ac81d5484d80defc33c18b75f052a9bbd39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92164fa1f7d95a4dc2fa9f22de7e28c4b96c8873241a86f3f8f37b897f90049c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd87fa86529c4258f34f4cfd356443325cf886ff7f911b9161272bc98aadfc62"
  end

  depends_on "swig" => :build
  depends_on "cryptography"
  depends_on "python@3.13"

  uses_from_macos "pcsc-lite"

  # pin pyscard to 2.0.8, upstream bug report, https://github.com/LudovicRousseau/pyscard/issues/169

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "fido2" do
    url "https://files.pythonhosted.org/packages/8d/b9/6ec8d8ec5715efc6ae39e8694bd48d57c189906f0628558f56688d0447b2/fido2-2.0.0.tar.gz"
    sha256 "3061cd05e73b3a0ef6afc3b803d57c826aa2d6a9732d16abd7277361f58e7964"
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
    url "https://files.pythonhosted.org/packages/f7/ed/1aa2d585304ec07262e1a83a9889880701079dde796ac7b1d1826f40c63d/jaraco_functools-4.3.0.tar.gz"
    sha256 "cfd13ad0dd2c47a3600b439ef72d8615d482cedcff1632930d6f28924d92f294"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/7b/6f/357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0c/jeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/70/09/d904a6e96f76ff214be59e7aa6ef7190008f52a0ab6689760a98de0bf37d/keyring-25.6.0.tar.gz"
    sha256 "0b39998aa941431eb3d9b0d4b2460bc773b9df6fed7621c2dfb291a7e0187a66"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/ea/5d/38b681d3fce7a266dd9ab73c66959406d565b3e85f21d5e66e1181d93721/more_itertools-10.8.0.tar.gz"
    sha256 "f638ddf8a1a0d134181275fb5d58b086ead7c6a72429ad725c67503f13ba30bd"
  end

  resource "pyscard" do
    url "https://files.pythonhosted.org/packages/c1/d9/02085a08c61a8d7330a77d25884b0fb39b1057f14e5f1d660ea5368f0b80/pyscard-2.3.0.tar.gz"
    sha256 "621928e217e3b1d3c791086bf0c9f307fc4ae004a9b1a430536acc1a6eb50003"
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

    generate_completions_from_executable(bin/"ykman", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ykman --version")
  end
end
