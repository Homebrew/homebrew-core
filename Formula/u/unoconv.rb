class Unoconv < Formula
  include Language::Python::Virtualenv

  desc "Convert between any document format supported by OpenOffice"
  homepage "https://github.com/unoconv/unoconv"
  url "https://files.pythonhosted.org/packages/ab/40/b4cab1140087f3f07b2f6d7cb9ca1c14b9bdbb525d2d83a3b29c924fe9ae/unoconv-0.9.0.tar.gz"
  sha256 "308ebfd98e67d898834876348b27caf41470cd853fbe2681cc7dacd8fd5e6031"
  license "GPL-2.0-only"
  revision 4
  head "https://github.com/unoconv/unoconv.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f291c61047fa90c216cc24d8363d849594bfac8ecbe103a4163a5fdd1c2621ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f291c61047fa90c216cc24d8363d849594bfac8ecbe103a4163a5fdd1c2621ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f291c61047fa90c216cc24d8363d849594bfac8ecbe103a4163a5fdd1c2621ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff27d27f6639defe6172e7fa54ba4421e3b89fa89cea8bd6982072899bb0bc1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff27d27f6639defe6172e7fa54ba4421e3b89fa89cea8bd6982072899bb0bc1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff27d27f6639defe6172e7fa54ba4421e3b89fa89cea8bd6982072899bb0bc1e"
  end

  deprecate! date: "2025-04-27", because: :repo_archived, replacement_formula: "unoserver"

  depends_on "python@3.14"

  pypi_packages extra_packages: "setuptools"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  def install
    virtualenv_install_with_resources
    man1.install "doc/unoconv.1"
  end

  def caveats
    <<~EOS
      In order to use unoconv, a copy of LibreOffice between versions 3.6.0.1 - 4.3.x must be installed.
    EOS
  end

  test do
    assert_match "office installation", pipe_output("#{bin}/unoconv 2>&1")
  end
end
