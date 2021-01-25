class Unoconv < Formula
  desc "Convert between any document format supported by OpenOffice"
  homepage "https://github.com/unoconv/unoconv"
  url "https://files.pythonhosted.org/packages/ab/40/b4cab1140087f3f07b2f6d7cb9ca1c14b9bdbb525d2d83a3b29c924fe9ae/unoconv-0.9.0.tar.gz"
  sha256 "308ebfd98e67d898834876348b27caf41470cd853fbe2681cc7dacd8fd5e6031"
  license "GPL-2.0"
  revision 2
  head "https://github.com/unoconv/unoconv.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "7c72ec6ea5faf7c47463f52f37d2c2d72e4aed11cb908edb32dc34e218d13057" => :big_sur
    sha256 "ffea78962c1983a8b627eeea500738948ff979dc501242b965edd218ccef01fe" => :arm64_big_sur
    sha256 "f2512d061951b02d953ad4c968d5fc4edf6f1ce0b11fecaf9b806c5655c70f7d" => :catalina
    sha256 "92911d5bef4561db470583e2a2d42a918ad13c4016f79902448c07f6b8a17a00" => :mojave
    sha256 "cbfd5a7ba3828eedcbfe26dd7f64ed4c58988f42d7972c2139e4e747010a68e5" => :high_sierra
  end

  depends_on "python@3.9"

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  def caveats
    <<~EOS
      In order to use unoconv, a copy of LibreOffice between versions 3.6.0.1 - 4.3.x must be installed.
    EOS
  end

  test do
    assert_match /office installation/, pipe_output("#{bin}/unoconv 2>&1")
  end
end
