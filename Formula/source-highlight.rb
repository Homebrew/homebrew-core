class SourceHighlight < Formula
  desc "Source-code syntax highlighter"
  homepage "https://www.gnu.org/software/src-highlite/"
  url "https://ftp.gnu.org/gnu/src-highlite/source-highlight-3.1.9.tar.gz"
  mirror "https://ftpmirror.gnu.org/src-highlite/source-highlight-3.1.9.tar.gz"
  sha256 "3a7fd28378cb5416f8de2c9e77196ec915145d44e30ff4e0ee8beb3fe6211c91"
  revision 5

  livecheck do
    url :stable
    regex(/href=.*?source-highlight[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "b9eb7acf4fe56cfe110ac6fae44645dc71f4b7dde15ed02573b985354753b488"
    sha256 arm64_big_sur:  "5571281923274d301cadd6ea132603c76a8865fe222b1f9b912ed54618ce8944"
    sha256 monterey:       "b9d065ee32f8627dad64340fe885c26eb6a2310267eec333f15ba3a3fb0989e6"
    sha256 big_sur:        "22764adfe8f5adef5fe50654e9d4218dd0966272cebfae37cb37004bb7e7f88e"
    sha256 catalina:       "defe1639783fd04bb3993487e15a68958bc53413229f008b6c5307bee623fa07"
    sha256 mojave:         "7c955cdd528a707e3ae17352314b3fa47eebf57b4b544eb9a3dc7e75a6875f6a"
    sha256 x86_64_linux:   "a625c44295563eb13bb41edff00bde62fce1bbe5a99ddadea99cae4c3f660119"
  end

  depends_on "boost"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{Formula["boost"].opt_prefix}"
    system "make", "install"

    bash_completion.install "completion/source-highlight"
  end

  test do
    assert_match "GNU Source-highlight #{version}", shell_output("#{bin}/source-highlight -V")
  end
end
