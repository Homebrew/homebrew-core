class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/b4/27/b71df0a723d879baa0af1ad897b2498ad78f284ae668b4420092e44c05fa/virtualenv-20.16.6.tar.gz"
  sha256 "530b850b523c6449406dfba859d6345e48ef19b8439606c5d74d7d3c9e14d76e"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "709f282663bfed72b16371b2c977eb4179aa07cd05d4b712a9a6caf99eac9bb5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "134df55fcb565f7bf9ca7ce0a69cddaad1aaf7dd6280abb5148439e1ac6f9152"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fab6e8338cc34aec175317bd004c363b432664c302fdcf3766723528136693ec"
    sha256 cellar: :any_skip_relocation, monterey:       "a48b680f160522a7c26f5589e5c892504e48fe832fb7a20ba0586c56e6745b0d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3ef268970e10407f0ddf17a53155ef9566e007d40016441d8ba334bd068d9cb"
    sha256 cellar: :any_skip_relocation, catalina:       "838f3714d063f74ba5e094e5a81b0347ab07d9edb0825511845b75d7a07604ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aadbdec288db7b4a7390561c75eb4f767ea4e9dd1e5fbe97c1bbb28e05c802d5"
  end

  depends_on "python@3.10"

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
