class Ykman < Formula
  include Language::Python::Virtualenv

  desc "Tool for managing your YubiKey configuration"
  homepage "https://developers.yubico.com/yubikey-manager/"
  url "https://files.pythonhosted.org/packages/1f/ab/5b0671484bcdac6cf383ba6682626ab23478889fab5fe7a1744ed78a33c4/yubikey_manager-5.9.2.tar.gz"
  sha256 "9584c7377449e6487140da6c3f13a289e618b0023c8414be91c1c212fce3c473"
  license "BSD-2-Clause"
  head "https://github.com/Yubico/yubikey-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8bf4de4812564b00816f446418c4b154c862e06d1f3d6ef54292607123af7809"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24575ce4f9d77f4a0df20d2163ea12b0e34952f4c86f42dd8001c8433c031836"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22990ddf1292f578de6952728718de1079b230be41f012f4bc4edab5afa47d44"
    sha256 cellar: :any_skip_relocation, sonoma:        "c68912b230ffa8b1e1d6e8ff9d6935e4b3d840ed3d3476ac30858a8e39e81ecf"
    sha256 cellar: :any,                 arm64_linux:   "ce7c511967f3badca1b563ae324bfba1426660910302775da8f6fcfd42291b33"
    sha256 cellar: :any,                 x86_64_linux:  "af470817af0542f30f26e9b478afcbea3656a3a888cb105e91b67b9ace4ba455"
  end

  depends_on "cmake" => :build # for more-itertools
  depends_on "swig" => :build
  depends_on "cryptography" => :no_linkage
  depends_on "python@3.14"

  uses_from_macos "pcsc-lite"

  pypi_packages exclude_packages: "cryptography",
                extra_packages:   %w[jeepney secretstorage]

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "fido2" do
    url "https://files.pythonhosted.org/packages/ba/ea/6f08c354b7aeb8019249d46a86c2153f8218499cced4d21bf16b6d49fc16/fido2-2.2.1.tar.gz"
    sha256 "85787428a94c3f8eaf72f0ff30afba983b559a1b1b795c93318c81b4ad4062c4"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/af/50/4763cd07e722bb6285316d390a164bc7e479db9d90daa769f22578f698b4/jaraco_context-6.1.2.tar.gz"
    sha256 "f1a6c9d391e661cc5b8d39861ff077a7dc24dc23833ccee564b234b81c82dfe3"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/36/cf/ea4ef2920830dea3f5ab2ea4da6fb67724e6dca80ee2553788c3607243d0/jaraco_functools-4.5.0.tar.gz"
    sha256 "3bb5665ea4a020cf78a7040e89154c77edadb3ca74f366479669c5999aa70b03"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/7b/6f/357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0c/jeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/43/4b/674af6ef2f97d56f0ab5153bf0bfa28ccb6c3ed4d1babf4305449668807b/keyring-25.7.0.tar.gz"
    sha256 "fe01bd85eb3f8fb3dd0405defdeac9a5b4f6f0439edbb3149577f244a2e8245b"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/de/1d/f4da6f02cdffe04d6362210b807146a26044c88d839208aec273bb0d9184/more_itertools-11.1.0.tar.gz"
    sha256 "48e8f4d9e7e5878571ecf6f2b4e57634f93cd474cc8cfbd2376f2d11b396e30d"
  end

  resource "pyscard" do
    url "https://files.pythonhosted.org/packages/93/c9/65c68738a94b44b67b3c5e68a815890bbd225f2ae11ef1ace9b61fa9d5f3/pyscard-2.3.1.tar.gz"
    sha256 "a24356f57a0a950740b6e54f51f819edd5296ee8892a6625b0da04724e9e6c13"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-pskc" do
    url "https://files.pythonhosted.org/packages/bb/96/877a597fc0bd9a3ed33ada8b30a93f9705805dc43a330e048a8bb1078365/python_pskc-1.4.tar.gz"
    sha256 "4a36381446ca067be728b30e01b4d18dbd9d1ad553bf07c3710abcd87653eefe"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/1c/03/e834bcd866f2f8a49a85eaff47340affa3bfa391ee9912a952a1faa68c7b/secretstorage-3.5.0.tar.gz"
    sha256 "f04b8e4689cbce351744d5537bf6b1329c6fc68f91fa666f60a380edddcd11be"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def install
    # Fixes: smartcard/scard/helpers.c:28:22: fatal error: winscard.h: No such file or directory
    ENV.append "CFLAGS", "-I#{formula_opt_include("pcsc-lite")}/PCSC" if OS.linux?

    without = ["pyscard"]
    without += %w[jeepney secretstorage] unless OS.linux?
    venv = virtualenv_install_with_resources(without:)

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
