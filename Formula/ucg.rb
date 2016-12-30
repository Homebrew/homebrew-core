class Ucg < Formula
  desc "grep-like tool for searching large bodies of source code"
  homepage "https://github.com/gvansickle/ucg"
  url "https://github.com/gvansickle/ucg/releases/download/0.3.2/universalcodegrep-0.3.2.tar.gz"
  sha256 "df57c877164454a5001caf791a24cd119afe4196070cb8d3cc741a7a43805c3e"
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
    lines = shell_output("#{bin}/ucg 'Hello World' #{testpath}").strip.split(":")
    assert_equal "Hello World!", lines[2]
  end
end
