class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/e2/a1/f6a76cc83255016ded5aa33a5db637c7d31ed51ee8e367139b9c7eae669e/virtualenv-20.13.3.tar.gz"
  sha256 "e9dd1a1359d70137559034c0f5433b34caf504af2dc756367be86a5a32967134"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6420c1c613c08e21be46ae7b35a0222ba81445b7abdcb6b74643976f0e73a2a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4ceed0904d45635ebd140c5953caaf815a41e7b819f648e1c648f3370ed9f7f"
    sha256 cellar: :any_skip_relocation, monterey:       "df5583da31444a74dd76c3c020333cb81ea67717801008bd428e55910956d390"
    sha256 cellar: :any_skip_relocation, big_sur:        "1098af42a572e3f94015edc7729b9809631ab70c0b0797e698dfb4f7c41e5d00"
    sha256 cellar: :any_skip_relocation, catalina:       "2c551b2658c96dca5203e5f06cad85665cc3a1bba7979ff7e6911002fd849c7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db73c6c248b3639457c00c92c89c88e5d11ad8c30d95bd901f0c6f198a013a8a"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/85/01/88529c93e41607f1a78c1e4b346b24c74ee43d2f41cfe33ecd2e20e0c7e3/distlib-0.3.4.zip"
    sha256 "e4b58818180336dc9c529bfb9a0b58728ffc09ad92027a3f30b7cd91e3458579"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/4d/cd/3b1244a19d61c4cf5bd65966eef97e6bc41e51fe84110916f26554d6ac8c/filelock-3.6.0.tar.gz"
    sha256 "9cd540a9352e432c7246a48fe4e8712b10acb1df2ad1f30e8c070b82ae1fed85"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/33/66/61da40aa546141b0d70b37fe6bb4ef1200b4b4cb98849f131b58faa9a5d2/platformdirs-2.5.1.tar.gz"
    sha256 "7535e70dfa32e84d4b34996ea99c5e432fa29a708d0f4e394bbcb2a8faa4f16d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
