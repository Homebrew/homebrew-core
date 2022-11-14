class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/2b/dc/be4da7a7fea4e8c3612a4f1901efc694b4f5f1c30179518ffef88c5f8dde/virtualenv-20.16.7.tar.gz"
  sha256 "8691e3ff9387f743e00f6bb20f70121f5e4f596cae754531f2b3b3a1b1ac696e"
  license "MIT"
  revision 1
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "708ad3d76f5b75495f85438a276ce3390ee25e9ac31cdb06dd7f584b9204b7b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "779a13e0636b2fca390cf6fd57e4158469b97714cbd46799b6d78fdd96b6e26d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9ae026c2496c93834a1d392d25038f38eda7f066f71e37bb911aba51ea56a31"
    sha256 cellar: :any_skip_relocation, ventura:        "9e661807a8f31e112022391dd659defa5741159838f5407d1fa49f7e3fa145ad"
    sha256 cellar: :any_skip_relocation, monterey:       "ecc40a764e2d88096943f5a359d150dc4d69b6b4d5dcb59e32ea80060acb2ace"
    sha256 cellar: :any_skip_relocation, big_sur:        "f550e7cb0518face2cc98ec23d27142f447baaa2c9c44664299b5e4c6b23c726"
    sha256 cellar: :any_skip_relocation, catalina:       "777cf55a5c7ad84e8c56d95c1a3e56785a42f50e683d45c78004f802044a02ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79ee553b651153dfb855d23ef29656d7705a185940ed79a0834031357e460ffe"
  end

  depends_on "python@3.11"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/58/07/815476ae605bcc5f95c87a62b95e74a1bce0878bc7a3119bc2bf4178f175/distlib-0.3.6.tar.gz"
    sha256 "14bad2d9b04d3a36127ac97f30b12a19268f211063d8f8ee4f47108896e11b46"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/95/55/b897882bffb8213456363e646bf9e9fa704ffda5a7d140edf935a9e02c7b/filelock-3.8.0.tar.gz"
    sha256 "55447caa666f2198c5b6b13a26d2084d26fa5b115c00d065664b2124680c4edc"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/cb/5f/dda8451435f17ed8043eab5ffe04e47d703debe8fe845eb074f42260e50a/platformdirs-2.5.4.tar.gz"
    sha256 "1006647646d80f16130f052404c6b901e80ee4ed6bef6792e1f238a8969106f7"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
