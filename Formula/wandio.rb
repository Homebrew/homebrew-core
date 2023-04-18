class Wandio < Formula
  desc "Transparently read from and write to zip, bzip2, lzma or zstd archives"
  homepage "https://github.com/LibtraceTeam/wandio"
  url "https://github.com/LibtraceTeam/wandio/archive/refs/tags/4.2.4-1.tar.gz"
  sha256 "6e1f36edfc3b814d62f91b09cee906e28cd811881da51544acf2ace5e6e5b13f"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d26fc7048a6bd89c7a7d23d57a4b6d66afca198407d5081660a549f4fcc36968"
    sha256 cellar: :any,                 arm64_monterey: "4cab14944bafd46625958a71a03381835d183374188da812a473d2f71dbe5d9f"
    sha256 cellar: :any,                 arm64_big_sur:  "3f772d8769a1854d32a56867661a7034d94089df2ac0419f557292b43087a0a6"
    sha256 cellar: :any,                 ventura:        "b327102a53f967348ffa3b8d0a04676b5da4db721f2ee9478706efc0de92f0a9"
    sha256 cellar: :any,                 monterey:       "4b8bfb5e95a227b21a99ee3e294335d1ed716395b5a602110e76cce985c4538c"
    sha256 cellar: :any,                 big_sur:        "8351307fcd0a3102c942a961e4b3212233087b3ed54f1cf0120819431a307e13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0837aaf8fc7308f0150c72f81f9548f0d0740faab8e59392628aa37c994de73c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "lz4"
  depends_on "lzo"
  depends_on "xz" # For LZMA
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    system "./bootstrap.sh"
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-http"
    system "make", "install"
  end

  test do
    system "#{bin}/wandiocat", "-z", "9", "-Z", "gzip", "-o", "test.gz",
      test_fixtures("test.png"), test_fixtures("test.pdf")
    assert_predicate testpath/"test.gz", :exist?
  end
end
