class Regipy < Formula
  include Language::Python::Virtualenv

  desc "Offline registry hive parsing tool"
  homepage "https://github.com/mkorman90/regipy"
  url "https://files.pythonhosted.org/packages/19/f4/44a4ad4a2d8b921769edf463849b1c5b81405a1ef3954e6a5c9b886aa1fd/regipy-2.5.1.tar.gz"
  sha256 "9b1338a2860c617a8210b4b734cba675679fa51d216b118f017a7b518d5e70f2"
  license "MIT"
  head "https://github.com/mkorman90/regipy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c48b301e266805ff64055895838c68f7e2c4264671c67bbdea752e3f14e192f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a73c9e714e64456d1f55783b37346e67a47be514664d4e2ae947101e269980e"
    sha256 cellar: :any_skip_relocation, monterey:       "a18ece36769dd9854a0bf34fada5a56901805c7099b552289d2b89a4776a22ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "7378042e02974dc014feeac8868a526dddca59ee1ea03a8960ab1aa5c41eeb60"
    sha256 cellar: :any_skip_relocation, catalina:       "e2c8655932b421d1e0093f96b8b8b59a2024ad44294286d8b28fdc2f394c487b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2654db1913eb749e4178e36fe6d767b535e16bee8c6fc1a3a9ad6497518ee8a6"
  end

  depends_on "python-tabulate"
  depends_on "python@3.9"

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
    venv = virtualenv_create(libexec, "python3.9")
    res = resources.map(&:name).to_set
    res -= %w[test_hive]

    res.each do |r|
      venv.pip_install resource(r)
    end

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
