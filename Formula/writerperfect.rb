class Writerperfect < Formula
  desc "Library for importing WordPerfect documents"
  homepage "https://sourceforge.net/p/libwpd/wiki/writerperfect/"
  url "https://downloads.sourceforge.net/project/libwpd/writerperfect/writerperfect-0.9.6/writerperfect-0.9.6.tar.xz"
  sha256 "1fe162145013a9786b201cb69724b2d55ff2bf2354c3cd188fd4466e7fc324e6"

  bottle do
    cellar :any
    sha256 "366e4994f628091698e34dbb4e16648d12b1f9ff81c65c6623b2a216c8eb63c7" => :high_sierra
    sha256 "cd81ab697a69bb1b004e0a67abcb2b455b0bcc08729631851f0ddd9144260f8d" => :sierra
    sha256 "5443a58b0fe10cfadaf3977fca423c0289e2eba665244a5ebc020cbbbdfc78d6" => :el_capitan
    sha256 "9f7253806ba136c75dc4920f6eca864258a1b1021fce2e7ff5b772573b3b742e" => :yosemite
    sha256 "763ae44dd67dbbdb4b5d1efd8a749fd9c9ee32fb040aceb76696923a5b6ca815" => :mavericks
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
