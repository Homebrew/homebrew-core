class Regipy < Formula
  include Language::Python::Virtualenv

  desc "Offline registry hive parsing tool"
  homepage "https://github.com/mkorman90/regipy"
  url "https://files.pythonhosted.org/packages/6a/23/0e77a9244d61360730b41b97b8e304d6729cbd2e35a5fddf82ef4c0efed4/regipy-4.1.1.tar.gz"
  sha256 "532014352610c0cce9de2d6b5e43a5c80852eddca81edc3bfce55974c95d9a43"
  license "MIT"
  head "https://github.com/mkorman90/regipy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c3b4609a7ef36a920d09605e36e861e7d53fdfe6d0350a86db0bbc183b721dcf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d0b23aa55e47c8d251bb2c3796f093cac3909b2302fcabdb03b5f9a39d3d854"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a964d29dad16d24685bd259baee4e424dfe3fa3f2358c4b0e7a2d3c1e64fa1f"
    sha256 cellar: :any_skip_relocation, sonoma:         "838f870b4868c8034115ae68a85ee158fc013da6225db4f4c84158c314182d39"
    sha256 cellar: :any_skip_relocation, ventura:        "5e6855d7a59cb87fb0d2bf8097ddac8c73ea62628175005c85453cce69d90dff"
    sha256 cellar: :any_skip_relocation, monterey:       "0e78224ff144854ce8122d9c647bd05a45425849b681fe7bfb866f7a69a53525"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "772a0d74be8e115f14e63a12ae62e050af625c56585da1468641f6b282514354"
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
