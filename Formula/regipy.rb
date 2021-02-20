class Regipy < Formula
  include Language::Python::Virtualenv

  desc "Offline registry hive parsing tool"
  homepage "https://github.com/mkorman90/regipy"
  url "https://files.pythonhosted.org/packages/c6/d1/eb096debb2b55cca3d2ae6b09cefa596d2dacba50a81791c5525547a4d34/regipy-1.8.2.tar.gz"
  sha256 "ef452bd7c7aaed514e821ac60310472b5dbe0914d1e5d17461ffd5b23270970b"
  license "MIT"
  head "https://github.com/mkorman90/regipy.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "144da1f401a441a8134d3b7e851a266c39abeef7215f6a06eb61fc5e544436f1"
    sha256 cellar: :any_skip_relocation, big_sur:       "769ec4dfef3b4cfb19db7d5bad3218b8e5667386c006df160229879bfe38e646"
    sha256 cellar: :any_skip_relocation, catalina:      "8a72cfb8636c91568d8d8d295865093ece9eb45e8145355ae9291a3ba0ca18b0"
    sha256 cellar: :any_skip_relocation, mojave:        "8d6b1a24d0b65a33f7b1149800b365e64e3c68b74edfba1a378400aeb3f980e9"
  end

  depends_on "python@3.9"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/f0/cb/80a4a274df7da7b8baf083249b0890a0579374c3d74b5ac0ee9291f912dc/attrs-20.3.0.tar.gz"
    sha256 "832aa3cde19744e49938b91fea06d69ecb9e649c93ba974535d08ad92164f700"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "construct" do
    url "https://files.pythonhosted.org/packages/da/a6/98e9f1751e618c9e055feba287d32247a7385a1e6aa79e84165a1f8c283b/construct-2.10.59.tar.gz"
    sha256 "cb752b53cb3678c539e5340f0ee8944479a640bccfff7ca915319cef658c3867"
  end

  resource "inflection" do
    url "https://files.pythonhosted.org/packages/e1/7e/691d061b7329bc8d54edbf0ec22fbfb2afe61facb681f9aaa9bff7a27d04/inflection-0.5.1.tar.gz"
    sha256 "1a29730d366e996aaacffb2f1f1cb9593dc38e2ddd30c91250c6dde09ea9b417"
  end

  resource "jsonlines" do
    url "https://files.pythonhosted.org/packages/bf/40/a1b1810a09e3e85567c17831fcc2fc8e48ad9a1d3b02e8be940c43b908a8/jsonlines-2.0.0.tar.gz"
    sha256 "6fdd03104c9a421a1ba587a121aaac743bf02d8f87fa9cdaa3b852249a241fe8"
  end

  resource "Logbook" do
    url "https://files.pythonhosted.org/packages/2f/d9/16ac346f7c0102835814cc9e5b684aaadea101560bb932a2403bd26b2320/Logbook-1.5.3.tar.gz"
    sha256 "66f454ada0f56eae43066f604a222b09893f98c1adc18df169710761b8f32fe8"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/b0/61/eddc6eb2c682ea6fd97a7e1018a6294be80dba08fa28e7a3570148b4612d/pytz-2021.1.tar.gz"
    sha256 "83a4a90894bf38e243cf052c8b58f381bfe9a7a483f6a9cab140bc7f702ac4da"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/57/6f/213d075ad03c84991d44e63b6516dd7d185091df5e1d02a660874f8f7e1e/tabulate-0.8.7.tar.gz"
    sha256 "db2723a20d04bcda8522165c73eea7c300eda74e0ce852d9022e0159d7895007"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/69/50/9f29874d835945b845812799edc732ba30c41e9d20431f9f69c8ffb9c670/tqdm-4.56.0.tar.gz"
    sha256 "fe3d08dd00a526850568d542ff9de9bbc2a09a791da3c334f3213d8d0bbbca65"
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
