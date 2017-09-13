class TheSilverSearcher < Formula
  desc "Code-search similar to ack"
  homepage "https://github.com/ggreer/the_silver_searcher"
  url "https://github.com/ggreer/the_silver_searcher/archive/2.1.0.tar.gz"
  sha256 "cb416a0da7fe354a009c482ae709692ed567f8e7d2dad4d242e726dd7ca202f0"
  head "https://github.com/ggreer/the_silver_searcher.git"

  bottle do
    cellar :any
    sha256 "252dabfa42a9a4769ddd62cf2265566d57eb1af1e39b8dcd75b6684402becd35" => :sierra
    sha256 "e731e1c3b4f85267dd4dea5c42ad1ff35c2def78b2c9f83ff8988bf0266f34ae" => :el_capitan
    sha256 "5e4ba79f17f087e697afb62cf738e321ebd4d6f2b001a4caaaed525a1ce75166" => :yosemite
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
