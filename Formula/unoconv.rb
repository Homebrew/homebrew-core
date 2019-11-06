class Unoconv < Formula
  desc "Convert between any document format supported by OpenOffice"
  homepage "http://dag.wiee.rs/home-made/unoconv/"
  url "https://files.pythonhosted.org/packages/ab/40/b4cab1140087f3f07b2f6d7cb9ca1c14b9bdbb525d2d83a3b29c924fe9ae/unoconv-0.9.0.tar.gz"
  sha256 "308ebfd98e67d898834876348b27caf41470cd853fbe2681cc7dacd8fd5e6031"
  head "https://github.com/dagwieers/unoconv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "080b156c88fd409534a862fb82fb98813f5aa342c17b10897c30186b6014ad15" => :catalina
    sha256 "080b156c88fd409534a862fb82fb98813f5aa342c17b10897c30186b6014ad15" => :mojave
    sha256 "080b156c88fd409534a862fb82fb98813f5aa342c17b10897c30186b6014ad15" => :high_sierra
  end

  depends_on "python"

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  def caveats; <<~EOS
    In order to use unoconv, a copy of LibreOffice between versions 3.6.0.1 - 4.3.x must be installed.
  EOS
  end

  test do
    assert_match /office installation/, pipe_output("#{bin}/unoconv 2>&1")
  end
end
