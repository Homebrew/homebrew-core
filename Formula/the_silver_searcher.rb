class TheSilverSearcher < Formula
  desc "Code-search similar to ack"
  homepage "https://github.com/ggreer/the_silver_searcher"
  url "https://github.com/ggreer/the_silver_searcher/archive/0.33.0.tar.gz"
  sha256 "351ab79ada811fd08f81296de10a7498ea3c46b681d73696d5a2911edbdc19db"
  head "https://github.com/ggreer/the_silver_searcher.git"

  bottle do
    cellar :any
    sha256 "77a6849d15b266e96c0d68c69348541b57d70b47efd30df18f79cf90ddc701a3" => :sierra
    sha256 "acfc0f9c8e62af01475d6aa60ba8821594989fd0f6a9fee32508e61b181e0ada" => :el_capitan
    sha256 "bdfc420ce05929cab66b0d7c283e6ce68d121ae829cbfbc6c7d803215625fae0" => :yosemite
    sha256 "c8235c0cf2b7a4a1b8f7517c72c092f8d480384684e86a33c8633caefe88eb90" => :mavericks
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
