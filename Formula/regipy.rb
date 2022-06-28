class Regipy < Formula
  include Language::Python::Virtualenv

  desc "Offline registry hive parsing tool"
  homepage "https://github.com/mkorman90/regipy"
  url "https://files.pythonhosted.org/packages/22/57/e9fba054f736379ec75aa9c136955f646f2eff9845d02a0b4ab7f5843d2e/regipy-2.5.4.tar.gz"
  sha256 "b4312382662e01f631c01768f899a9415f8f56ed63574644bfb32d7ef173f174"
  license "MIT"
  head "https://github.com/mkorman90/regipy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea6ec8f86d572f9862bd99d51b09a615fbf214774650018fb4ef3cce29d24e21"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee1a19314aa9b566e6cc032e1307f417ddcef87518b780820242195226fa2d56"
    sha256 cellar: :any_skip_relocation, monterey:       "3ea29584e37aa8c4302714c5ea908bbdd8c47bca32943c90787e3b36ac6680e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee8224a8c3ca5b9c0a49d90c2e911baac9ed8b2a1f749b209984d196676a6fbc"
    sha256 cellar: :any_skip_relocation, catalina:       "eef67fe052fd505ca123478c47eb7416e25a6130516ae4a8e3d0a78ae4f4b10d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cea5dad8fdd301244b2c9ba9bca820b54529f2e7e57cd228ff26a33ac74fc522"
  end

  depends_on "libpython-tabulate"
  depends_on "python@3.10"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/d7/77/ebb15fc26d0f815839ecd897b919ed6d85c050feeb83e100e020df9153d2/attrs-21.4.0.tar.gz"
    sha256 "626ba8234211db98e869df76230a137c4c40a12d72445c45d5f5b716f076e2fd"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "construct" do
    url "https://files.pythonhosted.org/packages/e0/b7/a4a032e94bcfdff481f2e6fecd472794d9da09f474a2185ed33b2c7cad64/construct-2.10.68.tar.gz"
    sha256 "7b2a3fd8e5f597a5aa1d614c3bd516fa065db01704c72a1efaaeec6ef23d8b45"
  end

  resource "inflection" do
    url "https://files.pythonhosted.org/packages/e1/7e/691d061b7329bc8d54edbf0ec22fbfb2afe61facb681f9aaa9bff7a27d04/inflection-0.5.1.tar.gz"
    sha256 "1a29730d366e996aaacffb2f1f1cb9593dc38e2ddd30c91250c6dde09ea9b417"
  end

  resource "libfwsi-python" do
    url "https://files.pythonhosted.org/packages/63/c8/47a7197167a11da6a68704f08053057922c1f73a91441824207099310b90/libfwsi-python-20220123.tar.gz"
    sha256 "faef9fb8e76faf6ad43a785a9129a110d80eb7d540c1382349ed5cec07714873"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/2f/5f/a0f653311adff905bbcaa6d3dfaf97edcf4d26138393c6ccd37a484851fb/pytz-2022.1.tar.gz"
    sha256 "1e760e2fe6a8163bc0b3d9a19c4f84342afa0a2affebfaa84b01b978a02ecaa7"
  end

  resource "test_hive" do
    url "https://raw.githubusercontent.com/mkorman90/regipy/71acd6a65bdee11ff776dbd44870adad4632404c/regipy_tests/data/SYSTEM.xz"
    sha256 "b1582ab413f089e746da0528c2394f077d6f53dd4e68b877ffb2667bd027b0b0"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources.reject { |r| r.name == "test_hive" }
    venv.pip_install_and_link buildpath
  end

  test do
    resource("test_hive").stage do
      system bin/"registry-plugins-run", "-p", "computer_name", "-o", "out.json", "SYSTEM"
      h = JSON.parse(File.read("out.json"))
      assert_equal h["computer_name"][0]["name"], "WKS-WIN732BITA"
      assert_equal h["computer_name"][1]["name"], "WIN-V5T3CSP8U4H"
    end
  end
end
