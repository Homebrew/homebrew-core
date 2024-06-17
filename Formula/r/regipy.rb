class Regipy < Formula
  include Language::Python::Virtualenv

  desc "Offline registry hive parsing tool"
  homepage "https://github.com/mkorman90/regipy"
  url "https://files.pythonhosted.org/packages/a3/61/041b38dc8058f0e99725bc6b72065afba1d2d55b3f4f58cf68f881b92e3d/regipy-4.2.1.tar.gz"
  sha256 "1027b9c6eb41f7be43a9af49710b0e04c99c19662fbf7b959199d66a2ff89af6"
  license "MIT"
  head "https://github.com/mkorman90/regipy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "99dd85098ef2b263295e1295aadd1a9ca782aa428c45d5fdbcc48d0b0c8bbdc7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13f2f2ddf4063119cb89134f32bcf87cc2c57061c5fd6626fe2efcea4d94fb0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f41692330dc38feaddae0e17c8c63a982ad792e2314855499a3bb9d954dcd1a"
    sha256 cellar: :any_skip_relocation, sonoma:         "d2d439f52a1bac7fef6612272c50140212b271215d6352d365c6b7ca3899c877"
    sha256 cellar: :any_skip_relocation, ventura:        "3b221d9e82f28ac419371b3f3e739c84d5762c1347dc13a46edf9cbdc0782b36"
    sha256 cellar: :any_skip_relocation, monterey:       "ee0fa86c9d1b3fa5d972f355abf42b832ef6556f3bde9a4f79d157b8f5349e05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "259c2b6f4ce609cdd6b718e7a0a713b89cde0adc0636dd2a72873b91b8210a12"
  end

  depends_on "python@3.12"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/e3/fc/f800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650d/attrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "construct" do
    url "https://files.pythonhosted.org/packages/02/77/8c84b98eca70d245a2a956452f21d57930d22ab88cbeed9290ca630cf03f/construct-2.10.70.tar.gz"
    sha256 "4d2472f9684731e58cc9c56c463be63baa1447d674e0d66aeb5627b22f512c29"
  end

  resource "inflection" do
    url "https://files.pythonhosted.org/packages/e1/7e/691d061b7329bc8d54edbf0ec22fbfb2afe61facb681f9aaa9bff7a27d04/inflection-0.5.1.tar.gz"
    sha256 "1a29730d366e996aaacffb2f1f1cb9593dc38e2ddd30c91250c6dde09ea9b417"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/90/26/9f1f00a5d021fff16dee3de13d43e5e978f3d58928e129c3a62cf7eb9738/pytz-2024.1.tar.gz"
    sha256 "2a29735ea9c18baf14b448846bde5a48030ed267578472d8955cd0e7443a9812"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    resource "homebrew-test_hive" do
      url "https://raw.githubusercontent.com/mkorman90/regipy/71acd6a65bdee11ff776dbd44870adad4632404c/regipy_tests/data/SYSTEM.xz"
      sha256 "b1582ab413f089e746da0528c2394f077d6f53dd4e68b877ffb2667bd027b0b0"
    end

    testpath.install resource("homebrew-test_hive")

    system bin/"regipy-plugins-run", "-p", "computer_name", "-o", "out.json", "SYSTEM"
    h = JSON.parse(File.read("out.json"))
    assert_equal h["computer_name"][0]["name"], "WKS-WIN732BITA"
    assert_equal h["computer_name"][1]["name"], "WIN-V5T3CSP8U4H"
  end
end
