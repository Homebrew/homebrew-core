class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/d4/f9/e65670c81f7b6a4131fdb0ee42f2d5d4be42e89e6ffd04d4a43bd1c4ff8e/virtualenv-20.6.0.tar.gz"
  sha256 "51df5d8a2fad5d1b13e088ff38a433475768ff61f202356bb9812c454c20ae45"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2825c0e348b018c11b544f3d1bdf03593d2b4ad273ac417618e9b90a89c99624"
    sha256 cellar: :any_skip_relocation, big_sur:       "8fa087b2c11e648541c10fe1b73893837a8ef07d733e77a0a991bdbee515b010"
    sha256 cellar: :any_skip_relocation, catalina:      "a4184e76ba9cc1c4fe683fc975c587cc591dc875f498a4180e6a20c3b55166c5"
    sha256 cellar: :any_skip_relocation, mojave:        "7e591fedd53816e1180007101c889ee84eb90a0aa5c36f973c3f8a85508711dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9e7466aa72ee4b31e970889d57ca756e4e846914227ca269846ca3cec3b3b5f"
  end

  depends_on "python@3.9"

  resource "backports.entry-points-selectable" do
    url "https://files.pythonhosted.org/packages/e4/7e/249120b1ba54c70cf988a8eb8069af1a31fd29d42e3e05b9236a34533533/backports.entry_points_selectable-1.1.0.tar.gz"
    sha256 "988468260ec1c196dab6ae1149260e2f5472c9110334e5d51adcb77867361f6a"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/45/97/15fdbef466e12c890553cebb1d8b1995375202e30e0c83a1e51061556143/distlib-0.3.2.zip"
    sha256 "106fef6dc37dd8c0e2c0a60d3fca3e77460a48907f335fa28420463a6f799736"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/14/ec/6ee2168387ce0154632f856d5cc5592328e9cf93127c5c9aeca92c8c16cb/filelock-3.0.12.tar.gz"
    sha256 "18d82244ee114f543149c66a6e0c14e9c4f8a1044b5cdaadd0f82159d6a6ff59"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/c1/03/1dcc356abdfbe22bec1194852b02ed809c8bdf91e416b26f17f485c62984/platformdirs-2.0.2.tar.gz"
    sha256 "3b00d081227d9037bbbca521a5787796b5ef5000faea1e43fd76f1d44b06fcfa"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
