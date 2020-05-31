class Unpaper < Formula
  desc "Post-processing for scanned/photocopied books"
  homepage "https://www.flameeyes.com/projects/unpaper"
  url "https://www.flameeyes.com/files/unpaper-6.1.tar.xz"
  sha256 "237c84f5da544b3f7709827f9f12c37c346cdf029b1128fb4633f9bafa5cb930"
  revision 4

  bottle do
    cellar :any
    sha256 "e4ef8b38c6ae08675c8f806cc542ad7a47e3eba36c57ceab5c98c3d0380667ce" => :catalina
    sha256 "4507de47a88550a6c00a90e25e85ad45885cc20cc1d8bb0bacbbc70315d3fbaf" => :mojave
    sha256 "4b57d65c5d7da4def8d1421928a2d1a5b0ce5083d0f832590f9d15521cc01784" => :high_sierra
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
