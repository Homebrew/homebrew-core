class Ucg < Formula
  desc "grep-like tool for searching large bodies of source code"
  homepage "https://github.com/gvansickle/ucg"
  url "https://github.com/gvansickle/ucg/releases/download/0.3.1/universalcodegrep-0.3.1.tar.gz"
  sha256 "62f9ef88ea5c0777696c4322bed1fb9a3fb62eb85bd053af50f75d42ec259086"
  head "https://github.com/gvansickle/ucg.git"

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "automake" => :build
  depends_on "argp-standalone" => :build
  depends_on "pcre2"

  # superenv's '-march' flag conflicts with build script
  env :std

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
    lines = shell_output("#{bin}/ucg 'Hello World' #{testpath}").strip.split(":")
    assert_equal "Hello World!", lines[2]
  end
end
