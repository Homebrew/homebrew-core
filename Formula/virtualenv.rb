class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/62/2d/06980235e155c7ee1971f77439cbbc3069e98de49540e89f2291905eb4a8/virtualenv-20.16.4.tar.gz"
  sha256 "014f766e4134d0008dcaa1f95bafa0fb0f575795d07cae50b1bee514185d6782"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ef16be518590b3c0fedf7d2b0d701a799b9ba497d2b7d6b0e26c29b956de253"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec357d50f72a50a80386a00a915167b4c299dc5899db644bb1fe88241073353d"
    sha256 cellar: :any_skip_relocation, monterey:       "1017d4ff3a4e185977f54b8ead186439b6809e7606174ea5d5e14441045d7345"
    sha256 cellar: :any_skip_relocation, big_sur:        "428600da01b53a8e837c9b6b8f907285fd69ff78da638a68cb490f8ecf38008c"
    sha256 cellar: :any_skip_relocation, catalina:       "cdb55129d93543673c04e7ad64c42de9b71be3ac0ff2671736310ec2209181aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "645e5a5a8f9139d0487211a438038b8517d9ad10d91824815e57e8475d39b98c"
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
