class Regipy < Formula
  include Language::Python::Virtualenv

  desc "Offline registry hive parsing tool"
  homepage "https://github.com/mkorman90/regipy"
  url "https://files.pythonhosted.org/packages/b1/7c/7198c96f40a40a70a3c8d0ff269b957fdf7a573e26c6c499d3a3b7a89835/regipy-2.3.0.tar.gz"
  sha256 "d7d446fcf09c510fe2e896ec0db491c7fd8c842de812fc7383f553e38def7c95"
  license "MIT"
  head "https://github.com/mkorman90/regipy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c396e4a403bccfe7579ef4d6063546891ddc422cf96e88e5db98cd5d853e239"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65bde2359f6cea2012de6377582fe86b620c893419e59a3d0ba2a0af573d5653"
    sha256 cellar: :any_skip_relocation, monterey:       "329e74155de78cbf02dde3f27b51decea0e237b5e3293533f898df6150a5d496"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8c0464d42e06441ef795e42c4f51f0cd0085fd4cde9b918729ac3cf9e52157a"
    sha256 cellar: :any_skip_relocation, catalina:       "0e5704a454d7eca2f3258b2848eba9465118f42422fc2e406a8f49cae67765d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b63444a2649158903112ae1115e3e582e159cc5abd02487a37a6fb35b6251ea"
  end

  depends_on "python-tabulate"
  depends_on "python@3.9"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/d7/77/ebb15fc26d0f815839ecd897b919ed6d85c050feeb83e100e020df9153d2/attrs-21.4.0.tar.gz"
    sha256 "626ba8234211db98e869df76230a137c4c40a12d72445c45d5f5b716f076e2fd"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/45/2b/7ebad1e59a99207d417c0784f7fb67893465eef84b5b47c788324f1b4095/click-8.1.0.tar.gz"
    sha256 "977c213473c7665d3aa092b41ff12063227751c41d7b17165013e10069cc5cd2"
  end

  resource "construct" do
    url "https://files.pythonhosted.org/packages/e0/b7/a4a032e94bcfdff481f2e6fecd472794d9da09f474a2185ed33b2c7cad64/construct-2.10.68.tar.gz"
    sha256 "7b2a3fd8e5f597a5aa1d614c3bd516fa065db01704c72a1efaaeec6ef23d8b45"
  end

  resource "inflection" do
    url "https://files.pythonhosted.org/packages/e1/7e/691d061b7329bc8d54edbf0ec22fbfb2afe61facb681f9aaa9bff7a27d04/inflection-0.5.1.tar.gz"
    sha256 "1a29730d366e996aaacffb2f1f1cb9593dc38e2ddd30c91250c6dde09ea9b417"
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
