class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/21/6b/0910aebe4d5c2a27d5a79ab8fae06d22f7e01dff46baf29ced8d080134c3/virtualenv-20.23.1.tar.gz"
  sha256 "8ff19a38c1021c742148edc4f81cb43d7f8c6816d2ede2ab72af5b84c749ade1"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5a234f51c61a0e506cf04728396fef80aff46154d7e8b4c1859046171f665e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1117e3f91c84c2a0dfaa8f9e29b45baace9cb84541aa00f3ea6e59d9645cbc7f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5779bf429fad76eef3380ec73581ff8b32e5f6512e86da472bd38de7be56cf91"
    sha256 cellar: :any_skip_relocation, ventura:        "dc326eb226cfe6cc55e791c5a2fe8342b9fdd7f4cb244c37e5ea295eea9e30e2"
    sha256 cellar: :any_skip_relocation, monterey:       "fdda565f0cc327476e405bca6d5943bcf93c1e0e5a8a323b45738cb4425df732"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ab88f89f1470fcefde5ead7ec708bbe9c028a40a99f4a6cc857209060a0b97d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61fc80eeaa72f2e3c056f0f58bf6ae4af0f00f054a430aaf3a1142944b44b04e"
  end

  depends_on "python@3.11"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/58/07/815476ae605bcc5f95c87a62b95e74a1bce0878bc7a3119bc2bf4178f175/distlib-0.3.6.tar.gz"
    sha256 "14bad2d9b04d3a36127ac97f30b12a19268f211063d8f8ee4f47108896e11b46"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/00/0b/c506e9e44e4c4b6c89fcecda23dc115bf8e7ff7eb127e0cb9c114cbc9a15/filelock-3.12.2.tar.gz"
    sha256 "002740518d8aa59a26b0c76e10fb8c6e15eae825d34b6fdf670333fd7b938d81"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d2/5d/29eed8861e07378ef46e956650615a9677f8f48df7911674f923236ced2b/platformdirs-3.5.3.tar.gz"
    sha256 "e48fabd87db8f3a7df7150a4a5ea22c546ee8bc39bc2473244730d4b56d2cc4e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
