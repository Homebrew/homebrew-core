class Regipy < Formula
  include Language::Python::Virtualenv

  desc "Offline registry hive parsing tool"
  homepage "https://github.com/mkorman90/regipy"
  url "https://files.pythonhosted.org/packages/cd/bd/1c168ee5bd3cb11f157befe9e498ff8d70013d0c239f918a1e8cbd345d12/regipy-3.1.0.tar.gz"
  sha256 "7d65ed76eb0232fd37537751e5ae54264afdeae5678807eee6b6006387ee0377"
  license "MIT"
  head "https://github.com/mkorman90/regipy.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0a23b1665de57c21946555689bf1d54beca057e4761bcc491eb6efc7bb63139"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1435e2b6d69c30d34e25b62e1e1530017c1655821d393da29846af0b279ceb9d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44834732b64c9d3ddbdf4b7f4b6bed289161645e41e27b51ee752b66b5c448c3"
    sha256 cellar: :any_skip_relocation, ventura:        "139ce6714e25457748c7d4168415ab04da1f3a91cc4ea10a2493d1fc944c606b"
    sha256 cellar: :any_skip_relocation, monterey:       "b0d7189258e5c502939ec66cac162f66d4bd5a8a3bdaaff13df53a1233385d12"
    sha256 cellar: :any_skip_relocation, big_sur:        "39193ad4eee626742cdad34b036598b9d3b0e495cf88faeda171f9de50543c58"
    sha256 cellar: :any_skip_relocation, catalina:       "f34b1b2fe3944788fba0dc528a95cead26911a9dd593722bda54356132abff7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7d3776813d6e0a006b904a8413ce2447ef4da280d6e9bf18c7156617c480c1b"
  end

  depends_on "libpython-tabulate"
  depends_on "python@3.11"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/1a/cb/c4ffeb41e7137b23755a45e1bfec9cbb76ecf51874c6f1d113984ecaa32c/attrs-22.1.0.tar.gz"
    sha256 "29adc2665447e5191d0e7c568fde78b21f9672d344281d0c6e1ab085429b22b6"
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

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/76/63/1be349ff0a44e4795d9712cc0b2d806f5e063d4d34631b71b832fac715a8/pytz-2022.6.tar.gz"
    sha256 "e89512406b793ca39f5971bc999cc538ce125c0e51c27941bef4568b460095e2"
  end

  resource "test_hive" do
    url "https://raw.githubusercontent.com/mkorman90/regipy/71acd6a65bdee11ff776dbd44870adad4632404c/regipy_tests/data/SYSTEM.xz"
    sha256 "b1582ab413f089e746da0528c2394f077d6f53dd4e68b877ffb2667bd027b0b0"
  end

  def install
    venv = virtualenv_create(libexec, "python3.11")
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
