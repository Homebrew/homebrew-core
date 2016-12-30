class Ucg < Formula
  desc "grep-like tool for searching large bodies of source code"
  homepage "https://github.com/gvansickle/ucg"
  url "https://github.com/gvansickle/ucg/releases/download/0.3.3/universalcodegrep-0.3.3.tar.gz"
  sha256 "116d832bbc743c7dd469e5e7f1b20addb3b7a08df4b4441d59da3acf221caf2d"
  head "https://github.com/gvansickle/ucg.git"

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "automake" => :build
  depends_on "argp-standalone" => :build
  depends_on "pcre2"

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
