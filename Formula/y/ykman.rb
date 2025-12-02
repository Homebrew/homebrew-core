class Ykman < Formula
  include Language::Python::Virtualenv

  desc "Tool for managing your YubiKey configuration"
  homepage "https://developers.yubico.com/yubikey-manager/"
  url "https://files.pythonhosted.org/packages/b3/09/ba3ca95ed3c8adfb7f8288a33048a963dcc5741eb3e819a8451b65e36a59/yubikey_manager-5.8.0.tar.gz"
  sha256 "3af0da65e1fdd46763c94ee74e2da55a4b6e7771da776c197f5f4b4581738560"
  license "BSD-2-Clause"
  head "https://github.com/Yubico/yubikey-manager.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbe7882af1ba4b5a251c58e775f405382e4d19e7ac86d6d1abdd39023f0948fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14991f7289929523e9cceeaed383a0047cf94f728730a5e0b29313c72c5d990f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "002ba3444d9cc43ca195f51eb9f44ea4a9073923355887cbf3e1850e60e8d98a"
    sha256 cellar: :any_skip_relocation, sonoma:        "194c3b50e319727301c199ebc1652b6ad1085649c2e6abb26fa6d24fc922ed5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a7fc0d787f903feac1306c4eb0de99f5e04a90360c445654cfd5299c70604d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5665d529fb05f130d4aae2e888e37dd23fa500579875c81c9de6d83fe91b9e0"
  end

  depends_on "cmake" => :build # for more-itertools
  depends_on "swig" => :build
  depends_on "cryptography"
  depends_on "python@3.14"

  uses_from_macos "pcsc-lite"

  pypi_packages exclude_packages: "cryptography",
                extra_packages:   %w[jeepney secretstorage]

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
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
    url "https://files.pythonhosted.org/packages/31/9f/11ef35cf1027c1339552ea7bfe6aaa74a8516d8b5caf6e7d338daf54fd80/secretstorage-3.4.0.tar.gz"
    sha256 "c46e216d6815aff8a8a18706a2fbfd8d53fcbb0dce99301881687a1b0289ef7c"
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
