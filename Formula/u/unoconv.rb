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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d56e2b15a6258fc3225c01543919e06a92458f16978ffa647b711952dd50a87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d56e2b15a6258fc3225c01543919e06a92458f16978ffa647b711952dd50a87"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d56e2b15a6258fc3225c01543919e06a92458f16978ffa647b711952dd50a87"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8157297c8bd02ce4e450dae741d2c92170c2a895b15818ab29fc1baecbfc9d7"
    sha256 cellar: :any_skip_relocation, ventura:       "d8157297c8bd02ce4e450dae741d2c92170c2a895b15818ab29fc1baecbfc9d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d215a366fb8b1b1592d7b6fff9df212a0f1798cb5a740b9db51028020354389"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98d229d5206a98c1b525a0fd707041b499c6dd9cf3a2c9ccbc92f3a18fb36e1b"
  end

  deprecate! date: "2025-04-27", because: :repo_archived, replacement_formula: "unoserver"

  depends_on "python@3.13"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/27/b8/f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74b/setuptools-75.1.0.tar.gz"
    sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
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
