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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6cb1be385918c579252bbc1d4ec3c15a0c0e57c13d599beb2730b6e0a4b43105"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf3246ea33a5bac640695d35177a54def1fb1eefce4b4a6ebbd600cb3010a75a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba1e0088983fe6caf0251da516be0d0684ec154f707540c2fd3b220ae0a75aea"
    sha256 cellar: :any_skip_relocation, ventura:        "b13172f508f5d1fb5e9f2e5c801e08611668ff57ab12ad094d80393be21fafee"
    sha256 cellar: :any_skip_relocation, monterey:       "8aedb664ad62cc4d6c08e8319414faa73245e7d01b68a58658a1a81c0711a026"
    sha256 cellar: :any_skip_relocation, big_sur:        "078f92d8dd14b0067fd669e738b9fea342c751b6dba3225638409fa8df27b617"
    sha256 cellar: :any_skip_relocation, catalina:       "48836ca02c57342b5fc963da360c810c82c00409ed6aa0143e6ad40e39856696"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e5698f33296397ea1fe9c3dad0df14f189efeec07b560ccf5d72e1fd83be0f6"
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
