class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/07/a3/bd699eccc596c3612c67b06772c3557fda69815972eef4b22943d7535c68/virtualenv-20.16.5.tar.gz"
  sha256 "227ea1b9994fdc5ea31977ba3383ef296d7472ea85be9d6732e42a91c04e80da"
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
