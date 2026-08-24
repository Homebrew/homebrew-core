class Tin < Formula
  desc "Threaded, NNTP-, and spool-based UseNet newsreader"
  homepage "http://www.tin.org"
  url "https://sunsite.icm.edu.pl/pub/unix/news/tin/v2.6/tin-2.6.6.tar.xz"
  sha256 "bf8a2ed051bc33d0bfce8bf2163ac80691c91ab3bbe380dce764481f0aae6338"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(%r{tin-current\.t.*?>TIN v?(\d+(?:\.\d+)+)</A>.*?stable}i)
  end

  bottle do
    sha256               arm64_tahoe:   "1e53cebb5c99bc1f13b9b9590fc9ccfd7e33b8bbcd46ab6c807fc36295d84a77"
    sha256               arm64_sequoia: "d8d5a7b775fecfaeb97fdece2f059f409b7480f0a91112c49aeb772cdd8430d1"
    sha256               arm64_sonoma:  "5790b69677cb75e61db5042acab9155528e7d2f01e4c34fae15edd55d3b89532"
    sha256               sonoma:        "cfce01383930442ad7b49ee9a876cb4057c2f10bab8bfddac4a83d7cb040651c"
    sha256 cellar: :any, arm64_linux:   "be34926c521936f41c8f19c92390e35a1a638ce7c17d4377b3790c6773785d8a"
    sha256 cellar: :any, x86_64_linux:  "d293199a9b2094581c28b0660be1e60c4b9342c578484668cf060a70ac7431c9"
  end

  depends_on "pcre2"

  uses_from_macos "bison" => :build
  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
    depends_on "libunistring"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "mutt", because: "both install mmdf.5 and mbox.5 man pages"

  def install
    # Remove bundled libraries
    rm_r buildpath/"pcre"

    system "./configure", "--mandir=#{man}",
                          "--with-pcre2-config=#{formula_opt_prefix("pcre2")}/bin/pcre2-config",
                          *std_configure_args
    system "make", "build"
    system "make", "install"
  end

  test do
    system bin/"tin", "-H"
  end
end
