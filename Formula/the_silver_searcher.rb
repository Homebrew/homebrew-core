class TheSilverSearcher < Formula
  desc "Code-search similar to ack"
  homepage "https://github.com/ggreer/the_silver_searcher"
  url "https://github.com/ggreer/the_silver_searcher/archive/2.0.0.tar.gz"
  sha256 "ff7243863f22ed73eeab6f7a6d17cfff585a7eaa41d5ab3ae4f5d6db97701d5f"
  head "https://github.com/ggreer/the_silver_searcher.git"

  bottle do
    cellar :any
    sha256 "9b3b9b0b7e460befd173815018bec2a69eeb909f7eb52f3b4b522dae203b9fed" => :sierra
    sha256 "423f2d19100215e071465ac139d6facd9a92e0cfc51fe26b8629563772a3d678" => :el_capitan
    sha256 "b3f550a5e19ba41211cb81a37e9e29f2a7d2d4e7da3a77c5fda58faf5d745666" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "pcre"
  depends_on "xz" => :recommended

  def install
    # Stable tarball does not include pre-generated configure script
    system "autoreconf", "-fiv"

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--disable-lzma" if build.without?("xz")

    system "./configure", *args
    system "make"
    system "make", "install"

    bash_completion.install "ag.bashcomp.sh"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system "#{bin}/ag", "Hello World!", testpath
  end
end
