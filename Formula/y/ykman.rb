class Ykman < Formula
  include Language::Python::Virtualenv

  desc "Tool for managing your YubiKey configuration"
  homepage "https://developers.yubico.com/yubikey-manager/"
  url "https://files.pythonhosted.org/packages/08/56/66cfa3149a54ee55a27de742a0a46944df76acf0b9d2fc8377e43e92167a/yubikey_manager-5.7.2.tar.gz"
  sha256 "9aeb4035dcff8f6cb792e83f36e6a9152a9b5b65ac2c2e25e5f20d53c6064e62"
  license "BSD-2-Clause"
  head "https://github.com/Yubico/yubikey-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "842d4ca75c0b971050d7cdded4b1e07f7c9472877ad694a541d3368325203959"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7c97aeecfc6a6d4215a1cde16c1223accd6afa605c1895f819c1ba0e41bbc98"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c47a5676ca014e2ce4288ee335eb833755b71fe97fdb625e7c2f78f743a529a"
    sha256 cellar: :any_skip_relocation, sonoma:        "447ddc8d23fc9eb6cca78fb691491e9dfd03f2d9ef9597760bdab09ffd3726bf"
    sha256 cellar: :any_skip_relocation, ventura:       "ad9312ba3779433916fea7621376722a292cc2d5795b9bfe655d19b50edf01fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca0cdbf6e8f97e6f250de8f3dbe083fdae6709c1dd59fa0268d34f0b22810d45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb400bfd7f5cf9d35a4bb749d02ca67d611a29b083c3798ef9bc12d0842a82b1"
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
    url "https://files.pythonhosted.org/packages/ab/23/9894b3df5d0a6eb44611c36aec777823fc2e07740dabbd0b810e19594013/jaraco_functools-4.1.0.tar.gz"
    sha256 "70f7e0e2ae076498e212562325e805204fc092d7b4c17e0e86c959e249701a9d"
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
    url "https://files.pythonhosted.org/packages/ce/a0/834b0cebabbfc7e311f30b46c8188790a37f89fc8d756660346fe5abfd09/more_itertools-10.7.0.tar.gz"
    sha256 "9fddd5403be01a94b204faadcff459ec3568cf110265d3c54323e1e866ad29d3"
  end

  resource "pyscard" do
    url "https://files.pythonhosted.org/packages/24/17/a52a6ceb0a58afc1c8b9274bd9fff8ac971a7d5ee886bf31297768a88aa0/pyscard-2.2.2.tar.gz"
    sha256 "c77481fb86f4a17bc441d7b36551c1d36a9d3a48c4bb30ab8118886e6f275081"
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
    generate_completions_from_executable(bin/"ykman", shells: [:bash, :fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ykman --version")
  end
end
