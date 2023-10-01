class Regipy < Formula
  include Language::Python::Virtualenv

  desc "Offline registry hive parsing tool"
  homepage "https://github.com/mkorman90/regipy"
  url "https://files.pythonhosted.org/packages/e0/f2/61846ba036f840b3cfe9b412dca3ef629bdc7506faafbd56b2c8de987950/regipy-3.1.6.tar.gz"
  sha256 "edc9fd8501f3374afd49020550bf361235e569959712825fbd2f444d2aeca8d9"
  license "MIT"
  head "https://github.com/mkorman90/regipy.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52230b24a98fee373f2ac1c31a2201305805fd9ea42753c0662066d4f2e8d950"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52ef445e8ede15b5290cb3b666375b45bf460042569799491732359c9fc88f01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "742f3e46a6323c2e26f01195d72a17f15a9f4b1461c8c710e9f2d8155cc85c3d"
    sha256 cellar: :any_skip_relocation, ventura:        "36c82ae06f653cc2bca956a7b658f864ce1055cc7130b10ac3f80cdb3a7d8999"
    sha256 cellar: :any_skip_relocation, monterey:       "f7386b0e830d654eec78f9d921ee05b53684d2f45411d32b63da5fd75bf2f91b"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e09699a9518bf88789d87cef68c49b035eccea88411124623aa245db79a8bdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80b37ae8e56b2fac41fa904ef956035fcd881fdea7386604561ce57824b2dfce"
  end

  depends_on "python-pytz"
  depends_on "python-tabulate"
  depends_on "python@3.11"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
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
