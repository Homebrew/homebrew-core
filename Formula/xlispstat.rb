class Xlispstat < Formula
  desc "Statistical data science environment based on Lisp"
  homepage "https://homepage.stat.uiowa.edu/~luke/xls/xlsinfo/"
  url "https://homepage.cs.uiowa.edu/~luke/xls/xlispstat/current/xlispstat-3-52-23.tar.gz"
  version "3.52.23"
  sha256 "9bf165eb3f92384373dab34f9a56ec8455ff9e2bf7dff6485e807767e6ce6cf4"
  revision 1

  bottle do
    cellar :any
    sha256 "30bde68dbe2eada5b7646e5ef4b6fc0f804be39f37ae75244955b3befe803036" => :big_sur
    sha256 "1c7230181f7447fb264b14c84d8a6a2e3396faec78af73174ed6543f19536a8a" => :arm64_big_sur
    sha256 "d2e8f57e8dc13c6b1aaa38af29d291b5974b642626599cf478f3997e2981643a" => :catalina
    sha256 "2ad96a0eaeadb61b6eae731c7f8caf19ce6a202b4fab65d474e135c0731b8022" => :mojave
    sha256 "66e03a45aad7571b1a51c5196236099f11884ee055e7b45fcbdb19d4ae682e90" => :high_sierra
  end

  depends_on "libx11"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    ENV.deparallelize # Or make fails bytecompiling lisp code
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "> 50.5\n> ", pipe_output("#{bin}/xlispstat | tail -2", "(median (iseq 1 100))")
  end
end
