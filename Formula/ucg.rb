class Ucg < Formula
  desc "Tool for searching large bodies of source code (like grep)"
  homepage "https://github.com/gvansickle/ucg"
  url "https://github.com/gvansickle/ucg/releases/download/0.3.3/universalcodegrep-0.3.3.tar.gz"
  sha256 "116d832bbc743c7dd469e5e7f1b20addb3b7a08df4b4441d59da3acf221caf2d"
  head "https://github.com/gvansickle/ucg.git"

  bottle do
    cellar :any
    sha256 "cf699c7e60e56c4d1880813071fec45f66d001f36debd1e72682bb19da2d7f67" => :sierra
    sha256 "f98c5f7d7c4501f2628caeef25adbd7caa0c0185af42fed9a7c9e7676557d747" => :el_capitan
    sha256 "b5eb0d7540c6a4e64f6fedb293eb6476bcd33c4eab64fc5c3d0496a5e35b7b6b" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "automake" => :build
  depends_on "argp-standalone" => :build
  depends_on "pcre2"

  # Fix Xcode 9 compilation issue: https://github.com/gvansickle/ucg/issues/118
  # Patch adapted from upstream: https://github.com/gvansickle/ucg/commit/395f89
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/00615b/ucg/xcode9.patch"
    sha256 "3005fda5923cfa3093ce53ad84435fd7a5974f960b2e222e0e59afa90414af90"
  end

  def install
    system "autoreconf", "-i" if build.head?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write("Hello World!")
    assert_match "Hello World!", shell_output("#{bin}/ucg 'Hello World' #{testpath}")
  end
end
