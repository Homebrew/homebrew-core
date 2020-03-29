class Unpaper < Formula
  desc "Post-processing for scanned/photocopied books"
  homepage "https://www.flameeyes.com/projects/unpaper"
  url "https://www.flameeyes.com/files/unpaper-6.1.tar.xz"
  sha256 "237c84f5da544b3f7709827f9f12c37c346cdf029b1128fb4633f9bafa5cb930"
  revision 2

  bottle do
    cellar :any
    sha256 "255eef39573324e6772fcbb69d2f6567b4230152f55ffa6b545b41fd81d8a7ac" => :mojave
    sha256 "064acb1292a5a948eb3963be07c400d8fe0e7fa008afec78bfdd659392e45871" => :high_sierra
    sha256 "f35014bc991ee89bc5af4a4f25034bf525220a13a8925518424a5a423273a1cc" => :sierra
    sha256 "743399859c237fb673ee9dec339d660215d92db2383f31c3208f726116adeb1d" => :el_capitan
  end

  head do
    url "https://github.com/Flameeyes/unpaper.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"

  uses_from_macos "libxslt"

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
