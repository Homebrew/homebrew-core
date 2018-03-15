class Writerperfect < Formula
  desc "Library for importing WordPerfect documents"
  homepage "https://sourceforge.net/p/libwpd/wiki/writerperfect/"
  url "https://downloads.sourceforge.net/project/libwpd/writerperfect/writerperfect-0.9.6/writerperfect-0.9.6.tar.xz"
  sha256 "1fe162145013a9786b201cb69724b2d55ff2bf2354c3cd188fd4466e7fc324e6"

  bottle do
    cellar :any
    sha256 "37133b652a9b0c4f8a67800ddcf1d468d162112420fb205a8f87ea47277402fa" => :high_sierra
    sha256 "05685d6d978c569b95cc2259a7e9a8920b36e295033149fdf749dc8f05dc322b" => :sierra
    sha256 "a3d7cc487e7a997afd01d46b8de352c54ad9cdaa55396d55c38237584179fb4c" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "libmwaw" => :optional
  depends_on "libodfgen"
  depends_on "libwps"
  depends_on "libwpg"
  depends_on "libwpd"
  depends_on "libetonyek" => :optional
  depends_on "libvisio" => :optional
  depends_on "libmspub" => :optional
  depends_on "libfreehand" => :optional
  depends_on "libcdr" => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
