class TheSilverSearcher < Formula
  desc "Code-search similar to ack"
  homepage "https://github.com/ggreer/the_silver_searcher"
  url "https://github.com/ggreer/the_silver_searcher/archive/2.1.0.tar.gz"
  sha256 "cb416a0da7fe354a009c482ae709692ed567f8e7d2dad4d242e726dd7ca202f0"
  head "https://github.com/ggreer/the_silver_searcher.git"

  bottle do
    cellar :any
    sha256 "a1ced1818cc192ea082ccc4daebcd83a8b52d64792d8811ba9e8b1358bebb962" => :sierra
    sha256 "f7aaf418d11b93ffb48c6c9daff6931f5afcba71f4e9826a401436e74f564739" => :el_capitan
    sha256 "257eb268bc243c621c9a0bcc109167f2bd1d06fd33dc0cc458ed854dc3a1fc92" => :yosemite
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
