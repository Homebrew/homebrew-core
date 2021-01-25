class Tclap < Formula
  desc "Templatized C++ command-line parser library"
  homepage "https://tclap.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/tclap/tclap-1.2.3.tar.gz"
  sha256 "19e7db5281540f154348770bc3a7484575f4f549aef8e00aabcc94b395f773c9"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{url=.*?/tclap[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "1805257b4ea89658de13fa55b18386c5c342b0d53095ac425cbf326ceec35640" => :big_sur
    sha256 "7759ca2808c4112bc4feaaca64f6dd93762554ac87dd2f7af531508535a70237" => :arm64_big_sur
    sha256 "2d096686e490335890260c02e10b5fcc914372d43c6d9d6201186c367376dfe1" => :catalina
    sha256 "e7ae47f1e056dd98bb0e60f8a827c2d895b9ab3ab71bb9b4f1cf9778408b4055" => :mojave
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    # Installer scripts have problems with parallel make
    ENV.deparallelize
    system "make", "install"
  end
end
