class Regipy < Formula
  include Language::Python::Virtualenv

  desc "Offline registry hive parsing tool"
  homepage "https://github.com/mkorman90/regipy"
  url "https://files.pythonhosted.org/packages/1c/0d/66056e152d26eccdc1a2198ee949eb8df9884dd58569e82f7cc7e806aa5d/regipy-3.1.4.tar.gz"
  sha256 "8ad242ce4cbd1476cbe0237fcf88a0164dfd477c2a2b452b52360ee1a92ab4ee"
  license "MIT"
  head "https://github.com/mkorman90/regipy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39a9091f2fdd38b14b5c12a3725d839aab12327833bbfd9824f429956aa060a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b883f0fe6f97f64be102e568245b6df90517ceabd2ed48208011ea7d4d7dc23"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81b4f1532d44daf9e1d4e778fca46315cde4b8e99a06364498581aad3d28becf"
    sha256 cellar: :any_skip_relocation, ventura:        "074cbc122424ea54a270094bb65a0988f04572d1c237ad6884db4cea52ef5fb5"
    sha256 cellar: :any_skip_relocation, monterey:       "a627a4bde661ab5bc2e0d81e19899f067728dc20a83f5fca0e2bd71033e4b3e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "58e223248e4dd837c465da30b8ec522e13cfc09946ce8641d361f93cbeafdd73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5408350094a3746145351d3784e871c587ca68424dffb2e8d72afc1265e41aa3"
  end

  depends_on "python-tabulate"
  depends_on "python@3.11"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/21/31/3f468da74c7de4fcf9b25591e682856389b3400b4b62f201e65f15ea3e07/attrs-22.2.0.tar.gz"
    sha256 "c9227bfc2f01993c03f68db37d1d15c9690188323c067c641f1a35ca58185f99"
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
    url "https://files.pythonhosted.org/packages/03/3e/dc5c793b62c60d0ca0b7e58f1fdd84d5aaa9f8df23e7589b39cc9ce20a03/pytz-2022.7.1.tar.gz"
    sha256 "01a0681c4b9684a28304615eba55d1ab31ae00bf68ec157ec3708a8182dbbcd0"
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
