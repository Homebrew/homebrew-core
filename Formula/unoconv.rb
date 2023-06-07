class Unoconv < Formula
  include Language::Python::Shebang

  desc "Convert between any document format supported by OpenOffice"
  homepage "https://github.com/unoconv/unoconv"
  url "https://files.pythonhosted.org/packages/ab/40/b4cab1140087f3f07b2f6d7cb9ca1c14b9bdbb525d2d83a3b29c924fe9ae/unoconv-0.9.0.tar.gz"
  sha256 "308ebfd98e67d898834876348b27caf41470cd853fbe2681cc7dacd8fd5e6031"
  license "GPL-2.0-only"
  revision 3
  head "https://github.com/unoconv/unoconv.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "436ea616c97c3d252b6575df52641d54fd5900b78ab329b12671c13061762f5d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "436ea616c97c3d252b6575df52641d54fd5900b78ab329b12671c13061762f5d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "436ea616c97c3d252b6575df52641d54fd5900b78ab329b12671c13061762f5d"
    sha256 cellar: :any_skip_relocation, ventura:        "1d6839861652d5763c6fdab17eceb453be1424152bb0af3368f938c47ae9e17e"
    sha256 cellar: :any_skip_relocation, monterey:       "1d6839861652d5763c6fdab17eceb453be1424152bb0af3368f938c47ae9e17e"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d6839861652d5763c6fdab17eceb453be1424152bb0af3368f938c47ae9e17e"
    sha256 cellar: :any_skip_relocation, catalina:       "1d6839861652d5763c6fdab17eceb453be1424152bb0af3368f938c47ae9e17e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "436ea616c97c3d252b6575df52641d54fd5900b78ab329b12671c13061762f5d"
  end

  depends_on "python@3.11"

  def install
    rewrite_shebang detected_python_shebang, "unoconv"

    system "make", "install", "prefix=#{prefix}"
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
