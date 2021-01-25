class Unpaper < Formula
  desc "Post-processing for scanned/photocopied books"
  homepage "https://www.flameeyes.com/projects/unpaper"
  url "https://www.flameeyes.com/files/unpaper-6.1.tar.xz"
  sha256 "237c84f5da544b3f7709827f9f12c37c346cdf029b1128fb4633f9bafa5cb930"
  revision 7

  bottle do
    cellar :any
    sha256 "a9841d58884ee1a0616a2a115c21c593eab613c0e040bf2b21d02ddeec682765" => :big_sur
    sha256 "8aadd07d5712465893b6c3625e7da966c8bfdee572c7ba660cedaa3b0cdff034" => :arm64_big_sur
    sha256 "63a30f9ac771386a0f7d7302c31abe60855b4c4028458cbf9371270f42ee49e6" => :catalina
    sha256 "15d95668bd014ac329b703502832f020efcdb9011558ab8ba86ee0c8a458046d" => :mojave
  end

  head do
    url "https://github.com/Flameeyes/unpaper.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"

  uses_from_macos "libxslt"

  on_linux do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "autoreconf", "-i" if build.head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.pbm").write <<~EOS
      P1
      6 10
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      1 0 0 0 1 0
      0 1 1 1 0 0
      0 0 0 0 0 0
      0 0 0 0 0 0
    EOS
    system bin/"unpaper", testpath/"test.pbm", testpath/"out.pbm"
    assert_predicate testpath/"out.pbm", :exist?
  end
end
