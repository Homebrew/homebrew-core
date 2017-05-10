class TheSilverSearcher < Formula
  desc "Code-search similar to ack"
  homepage "https://github.com/ggreer/the_silver_searcher"
  url "https://github.com/ggreer/the_silver_searcher/archive/1.0.3.tar.gz"
  sha256 "ce45de7412ee0ae6f22d72e17b81425666e6130da8cb434d5ca8ea42185e514e"
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
    system "aclocal", "-I", "#{HOMEBREW_PREFIX}/share/aclocal"
    system "autoconf"
    system "autoheader"
    system "automake", "--add-missing"

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
