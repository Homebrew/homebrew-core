class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/62/2d/06980235e155c7ee1971f77439cbbc3069e98de49540e89f2291905eb4a8/virtualenv-20.16.4.tar.gz"
  sha256 "014f766e4134d0008dcaa1f95bafa0fb0f575795d07cae50b1bee514185d6782"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30242747075262fda65d59ae420b00f84bf1374d8fb11f878d76ca831d495a94"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1810e7f448c6189eb18ed11c932131ce1222ee53e22f90b79e76fcc1452bd6b2"
    sha256 cellar: :any_skip_relocation, monterey:       "f7d37e9c90589659f392d080b3c4419bc3679b01b93accc8be4ad89377ff2d4e"
    sha256 cellar: :any_skip_relocation, big_sur:        "86b0d88863e152af3a0204c12fb627fe543904db1bd97dcaab6dd9a3520c0add"
    sha256 cellar: :any_skip_relocation, catalina:       "f0e523591b4582d4621e030b8f6664c669e323fea7f2e8113ffdc138ba0cc17d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79cfa218530a9f89b9faf4371e0971f1112b4b19a4da36667ac1d9ac95ff04bf"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/58/07/815476ae605bcc5f95c87a62b95e74a1bce0878bc7a3119bc2bf4178f175/distlib-0.3.6.tar.gz"
    sha256 "14bad2d9b04d3a36127ac97f30b12a19268f211063d8f8ee4f47108896e11b46"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/95/55/b897882bffb8213456363e646bf9e9fa704ffda5a7d140edf935a9e02c7b/filelock-3.8.0.tar.gz"
    sha256 "55447caa666f2198c5b6b13a26d2084d26fa5b115c00d065664b2124680c4edc"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/ff/7b/3613df51e6afbf2306fc2465671c03390229b55e3ef3ab9dd3f846a53be6/platformdirs-2.5.2.tar.gz"
    sha256 "58c8abb07dcb441e6ee4b11d8df0ac856038f944ab98b7be6b27b2a3c7feef19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
