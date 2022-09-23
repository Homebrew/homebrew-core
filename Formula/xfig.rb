class Xfig < Formula
  desc "Facility for interactive generation of figures"
  homepage "https://mcj.sourceforge.io"
  url "https://downloads.sourceforge.net/mcj/xfig-3.2.8b.tar.xz"
  sha256 "b2cc8181cfb356f6b75cc28771970447f69aba1d728a2dac0e0bcf1aea7acd3a"
  license "MIT"
  revision 4

  livecheck do
    url :stable
    regex(%r{url=.*?/xfig[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "04bf5b22a3b69384005293bbd96ccc0a2de3235892e68b765adf40108566937b"
    sha256 arm64_big_sur:  "df4e69418fc7bd9ac6931818add8977fcabd39d4d5d651a4754dc952236bd16d"
    sha256 monterey:       "9fec3557806dbbd3083174c197d9a7b2f81c643673c97818418546cabe233d09"
    sha256 big_sur:        "b56788b3eda210cdc78c96839e16755b67384cd625e10afc7d701759a7415ee1"
    sha256 catalina:       "89a4cabe41d5c498c9cd21d52f28dbad24f1c7c4dd239a07919244ec25375b47"
    sha256 x86_64_linux:   "101f918a51d6bdde9cfa5c4ca4de84c219c0e35baa971542d8860869797174b8"
  end

  depends_on "fig2dev"
  depends_on "ghostscript"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libx11"
  depends_on "libxaw3d"
  depends_on "libxi"
  depends_on "libxpm"
  depends_on "libxt"

  def install
    system "./configure", "--with-appdefaultdir=#{etc}/X11/app-defaults",
                          "--disable-silent-rules",
                          *std_configure_args
    system "make", "install-strip"
  end

  test do
    assert_equal "Xfig #{version}", shell_output("#{bin}/xfig -V 2>&1").strip
  end
end
