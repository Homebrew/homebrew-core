class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/07/a3/bd699eccc596c3612c67b06772c3557fda69815972eef4b22943d7535c68/virtualenv-20.16.5.tar.gz"
  sha256 "227ea1b9994fdc5ea31977ba3383ef296d7472ea85be9d6732e42a91c04e80da"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ddf6b0278b3b07570c5d68d90c26881ba59d50a84f63ddf3658a45a0ed83e27"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7fd28fd483c48d6cc156e4b0be65fd0f80fa731cde7708ba0d066fa106980de4"
    sha256 cellar: :any_skip_relocation, monterey:       "d55172aac04a313456fa6f32df0315e462e87f4c17d2ad04b1c495d1f04d0a83"
    sha256 cellar: :any_skip_relocation, big_sur:        "4edb30130e1b6f35a997cd3eeba44c5594f95b243856cf52cb8fb29cba9c0a37"
    sha256 cellar: :any_skip_relocation, catalina:       "7dfba4b23e01397fa8ea28371acef22fc75be80a6c2717905067d32b0f06c3d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9573987898a95c6985149df603f6d0951723383f8ff17ee5dff5241f3ddf435a"
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
