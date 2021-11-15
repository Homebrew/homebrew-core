class Unpaper < Formula
  desc "Post-processing for scanned/photocopied books"
  homepage "https://www.flameeyes.com/projects/unpaper"
  url "https://www.flameeyes.com/files/unpaper-6.1.tar.xz"
  sha256 "237c84f5da544b3f7709827f9f12c37c346cdf029b1128fb4633f9bafa5cb930"
  license "GPL-2.0-or-later"
  revision 7

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "294f7cece1a54c389382ed61101719710e0ec7c5f26dd679cd9fa9ce68e919f4"
    sha256 cellar: :any,                 arm64_big_sur:  "8aadd07d5712465893b6c3625e7da966c8bfdee572c7ba660cedaa3b0cdff034"
    sha256 cellar: :any,                 monterey:       "dca1c952850c1e9f3496cf2facf1b570d50c90fde110d9297360db337c2d4906"
    sha256 cellar: :any,                 big_sur:        "a9841d58884ee1a0616a2a115c21c593eab613c0e040bf2b21d02ddeec682765"
    sha256 cellar: :any,                 catalina:       "63a30f9ac771386a0f7d7302c31abe60855b4c4028458cbf9371270f42ee49e6"
    sha256 cellar: :any,                 mojave:         "15d95668bd014ac329b703502832f020efcdb9011558ab8ba86ee0c8a458046d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5719e8ac973a33236779dfc6f7cf56ee3d93987510d1b6edae9da1d091f162a3"
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

    system "autoreconf", "-i" if OS.linux?

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
