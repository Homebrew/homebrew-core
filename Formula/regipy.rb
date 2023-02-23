class Regipy < Formula
  include Language::Python::Virtualenv

  desc "Offline registry hive parsing tool"
  homepage "https://github.com/mkorman90/regipy"
  url "https://files.pythonhosted.org/packages/0a/51/1cdf073e058cefc817ffa6309653b15ec89b2e55cf73984f89d9478b85c3/regipy-3.1.5.tar.gz"
  sha256 "52da6dc5df3afec8e14ca0bca85ece705944d9e5608b0503b8368fa6dd69132e"
  license "MIT"
  head "https://github.com/mkorman90/regipy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9d6f50d621fdb0c9635da7aedca6edd7d4036f1f7e1814573a2f1b2ae208164"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f453307e514801677106de88e9b762a38e82a1853095587a87dbe90ff513925"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "767e3b8b3330ffc368a8e8e1e094e5976b55d1abaee9f59904f44f3e9c00b043"
    sha256 cellar: :any_skip_relocation, ventura:        "4572c8c2998ad34a425fcae94d54b9d30c51fa4bf074aba580c66dc303c98489"
    sha256 cellar: :any_skip_relocation, monterey:       "1ad2bb303bbc9dd1dc649c8d633d4339fc5b46c48787099b5727975ba8deaf64"
    sha256 cellar: :any_skip_relocation, big_sur:        "50d88a4369259685dc806b02f2a2214309c9e221c3a9161012a5b72d75e5d4ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b61a2ca80131cc884b033559925e766ac1d3a8e1baaaa8f55b876c41169f20ba"
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
