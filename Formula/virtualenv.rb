class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/91/37/cfff3b23392ae6a774f4cb7ed22c00566cdc50ee25b6305480cf48f1741c/virtualenv-20.7.1.tar.gz"
  sha256 "57bcb59c5898818bd555b1e0cfcf668bd6204bc2b53ad0e70a52413bd790f9e4"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4835c6d1130017193331275e8df237dcf89f0d6a885b62e22392376d2fe8dd76"
    sha256 cellar: :any_skip_relocation, big_sur:       "bb405bee44dbf9c4d806e51250b64c8df61db3aa1b7f1337ce18e3b991e46f1d"
    sha256 cellar: :any_skip_relocation, catalina:      "ffbfb04236622bb1155804f12cb39bf3e3f6b360d4436d743e219aebbbd8e7d8"
    sha256 cellar: :any_skip_relocation, mojave:        "fa8657896101c22652e056c2ce7846d9396d292473b389c48b3b3a1818c93d0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78f7c87be943c682667bab187c10c091e3f5a18a5a94d0a8f327c02c634d6516"
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
    url "https://files.pythonhosted.org/packages/58/cb/ee4234464290e3dee893cf37d1adc87c24ade86ff6fc55f04a9bf9f1ec4f/platformdirs-2.2.0.tar.gz"
    sha256 "632daad3ab546bd8e6af0537d09805cec458dce201bccfe23012df73332e181e"
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
