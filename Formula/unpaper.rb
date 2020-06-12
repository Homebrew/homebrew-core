class Unpaper < Formula
  desc "Post-processing for scanned/photocopied books"
  homepage "https://www.flameeyes.com/projects/unpaper"
  url "https://www.flameeyes.com/files/unpaper-6.1.tar.xz"
  sha256 "237c84f5da544b3f7709827f9f12c37c346cdf029b1128fb4633f9bafa5cb930"
  revision 4

  bottle do
    cellar :any
    sha256 "c72b06d6ed960566861cfdd9e01949fe3b532c21efb380606f2b0820d7592c47" => :catalina
    sha256 "e391cb0121a88acbadb26933c12c6066c638e802578650655260507e0dea490f" => :mojave
    sha256 "d347977d11838ca92f9f648eda8b35da43e2b0fc5973f025081b55c1a11b0d2b" => :high_sierra
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
