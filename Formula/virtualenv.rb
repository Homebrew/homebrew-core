class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/b4/27/b71df0a723d879baa0af1ad897b2498ad78f284ae668b4420092e44c05fa/virtualenv-20.16.6.tar.gz"
  sha256 "530b850b523c6449406dfba859d6345e48ef19b8439606c5d74d7d3c9e14d76e"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0732f1c08d1853608615a5e8fd7da231b33051aa54f184d1487cb8a0c657a49b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0177439554ab5d65b27818a67606f53e099e7eb03eccaaae201641f754cb67be"
    sha256 cellar: :any_skip_relocation, monterey:       "073746d1a8d32f0864117d199b560adc7e5987469b312da02dab5a620baea7eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a586aa8a68c07c64e00ac0e605585d7234cd5e11e05fb252e679b75047cd6f3"
    sha256 cellar: :any_skip_relocation, catalina:       "ba68b28ca0977cb4276abd32f92d0e73d83fca1d6c44100d8c50dfbed16a2611"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f333273b62d5f045946801c228a25e13d62687705488131fec3321174f0da68"
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
