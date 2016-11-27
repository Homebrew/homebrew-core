class TheSilverSearcher < Formula
  desc "Code-search similar to ack"
  homepage "https://github.com/ggreer/the_silver_searcher"
  url "https://github.com/ggreer/the_silver_searcher/archive/1.0.1.tar.gz"
  sha256 "a79e6b024c6c756589b0d5ffbffe65983c750a07099d28aa5036d47a9feec86b"
  head "https://github.com/ggreer/the_silver_searcher.git"

  bottle do
    cellar :any
    sha256 "d6dfcec644c3b415b7834feedd2e0fd4e79cabd41a6e50a34a0ff82c7bb4b046" => :sierra
    sha256 "ceceb120ec6d3ee051c2365449f36a838eede0395ad61245adfcaf026b4e2b70" => :el_capitan
    sha256 "2b38c4386d617706bbd803b31ff9ed44dadc7ede45f034ff5d381324e7c87f16" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  depends_on "pkg-config" => :build
  depends_on "pcre"
  depends_on "xz" => :recommended

  def install
    # Stable tarball does not include pre-generated configure script
    system "aclocal", "-I #{HOMEBREW_PREFIX}/share/aclocal"
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
