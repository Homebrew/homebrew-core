class TheSilverSearcher < Formula
  desc "Code-search similar to ack"
  homepage "https://github.com/ggreer/the_silver_searcher"
  url "https://github.com/ggreer/the_silver_searcher/archive/0.33.0.tar.gz"
  sha256 "351ab79ada811fd08f81296de10a7498ea3c46b681d73696d5a2911edbdc19db"
  head "https://github.com/ggreer/the_silver_searcher.git"

  bottle do
    cellar :any
    sha256 "93cf7fc6ccd17838731d2e17d2c1245181ea4f717245f1c41a12134f9c717faa" => :sierra
    sha256 "3188f29bd255459f1b2ff50010412072eec2f9005cc377d28c555a30fe137c1d" => :el_capitan
    sha256 "091690fe5670641952d1e2b665f1039559a0c94186e2f42790ee8f4cbdd68482" => :yosemite
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
