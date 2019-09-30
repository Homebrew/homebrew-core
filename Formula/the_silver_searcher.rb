class TheSilverSearcher < Formula
  desc "Code-search similar to ack"
  homepage "https://github.com/ggreer/the_silver_searcher"
  url "https://github.com/ggreer/the_silver_searcher/archive/2.2.0.tar.gz"
  sha256 "6a0a19ca5e73b2bef9481c29a508d2413ca1a0a9a5a6b1bd9bbd695a7626cbf9"
  head "https://github.com/ggreer/the_silver_searcher.git"

  bottle do
    cellar :any
    sha256 "6fd80fdd0896dae09c01d3c9785ddd658bb5f2f229e7d011d3fbdde887bc35d0" => :catalina
    sha256 "e57f89664f48c131dfb462dc4be2f5265867d827f82efb1c3841ba71d9156ed0" => :mojave
    sha256 "0bf5394d8ab5f61b8fbb593249f556f13b358d16eb0d3c97215be3da0476e94b" => :high_sierra
    sha256 "2365e24e5d0b1bef64b35c6a8f9e4f61d1f38eafe38c06d6e0acefc6a9a955db" => :sierra
    sha256 "1f35dcee133d638a16462db711560b624020e9dd8f732ac5a6f13a09b694421a" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "pcre"
  depends_on "xz"

  def install
    # Stable tarball does not include pre-generated configure script
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    bash_completion.install "ag.bashcomp.sh"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system "#{bin}/ag", "Hello World!", testpath
  end
end
