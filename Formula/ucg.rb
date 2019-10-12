class Ucg < Formula
  desc "Tool for searching large bodies of source code (like grep)"
  homepage "https://github.com/gvansickle/ucg"
  url "https://github.com/gvansickle/ucg/releases/download/0.3.3/universalcodegrep-0.3.3.tar.gz"
  sha256 "116d832bbc743c7dd469e5e7f1b20addb3b7a08df4b4441d59da3acf221caf2d"
  head "https://github.com/gvansickle/ucg.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "2e18cfd35ea53d5326a69f3d21cf32c2e850cd864735e3e45cd645d85e350ec7" => :catalina
    sha256 "2b073d5a0ee4cb2fe71822ce27c014b00974298cfc656f1fe0279f58bde398f9" => :mojave
    sha256 "3642e741bc9ffd1cf1982bfc2c373e0ed54a417c08ac46f43e4cf8a09a0a1a8a" => :high_sierra
    sha256 "dddf2d62a2e582a9356a4da6434ddb0432ce6d6b1d50a5dc6728f9b6254531a5" => :sierra
    sha256 "e4699a681ae9d2e9d68ce7da85fc050907070bc9650fad0c4f76faf991f3a422" => :el_capitan
  end

  depends_on "argp-standalone" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
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
