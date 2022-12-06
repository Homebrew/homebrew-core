class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/7b/19/65f13cff26c8cc11fdfcb0499cd8f13388dd7b35a79a376755f152b42d86/virtualenv-20.17.1.tar.gz"
  sha256 "f8b927684efc6f1cc206c9db297a570ab9ad0e51c16fa9e45487d36d1905c058"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54d3bb49f11c7b0ede94e9f620dd29eced7026e08559123e763bd37d70bbc3b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3241f3fb376ba1142166c1bed03c4fd4b622c3adb7c05ea77ad39d5bfd7d182c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "208783d8b0de470141988a332ffbed5cb0f55d482a1c3db91750e184d0e6fcb5"
    sha256 cellar: :any_skip_relocation, ventura:        "6c4fb1042b4c6919bd17984694e1bf4b520db257b21e91343ae06cff654291a8"
    sha256 cellar: :any_skip_relocation, monterey:       "e7e14d6e58ea206e811ade9ab9f4266bb20bb14248861f894435a8c3eb8199ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "283bf18cd948ea937c14ce3af5db8aa4012ed6e7f81c8ff2e23630a044ff3e66"
    sha256 cellar: :any_skip_relocation, catalina:       "21335f1b50bbfe14eaeb8025a7138537d4e158168293cc9bc0a7ef85c658aba2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba49fbfff6cc8e9881403db6e7942f4de5b0ec4f7abc394837fa7c870e027eb8"
  end

  depends_on "python@3.11"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/58/07/815476ae605bcc5f95c87a62b95e74a1bce0878bc7a3119bc2bf4178f175/distlib-0.3.6.tar.gz"
    sha256 "14bad2d9b04d3a36127ac97f30b12a19268f211063d8f8ee4f47108896e11b46"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/d8/73/292d9ea2370840a163e6dd2d2816a571244e9335e2f6ad957bf0527c492f/filelock-3.8.2.tar.gz"
    sha256 "7565f628ea56bfcd8e54e42bdc55da899c85c1abfe1b5bcfd147e9188cebb3b2"
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
