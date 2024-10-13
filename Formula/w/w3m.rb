class W3m < Formula
  desc "Pager/text based browser"
  homepage "https://w3m.sourceforge.net/"
  license "w3m"
  revision 8
  head "https://github.com/tats/w3m.git", branch: "master"

  stable do
    url "https://deb.debian.org/debian/pool/main/w/w3m/w3m_0.5.3.orig.tar.gz"
    sha256 "e994d263f2fd2c22febfbe45103526e00145a7674a0fda79c822b97c2770a9e3"

    # Upstream is effectively Debian https://github.com/tats/w3m at this point.
    # The patches fix a pile of CVEs
    patch do
      url "https://salsa.debian.org/debian/w3m/-/raw/debian/0.5.3-38/debian/patches/010_upstream.patch"
      sha256 "39e80b36bc5213d15a3ef015ce8df87f7fab5f157e784c7f06dc3936f28d11bc"
    end

    patch do
      url "https://salsa.debian.org/debian/w3m/-/raw/debian/0.5.3-38/debian/patches/020_debian.patch"
      sha256 "08bd013064dc544dc2e70599ea1c9e90f18998bc207dd8053188417fbdaeefb2"
    end
  end

  livecheck do
    url "https://deb.debian.org/debian/pool/main/w/w3m/"
    regex(/href=.*?w3m[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "df1fa11c7bee916e98b1dee448030ab78a7ce622c1a3a1a3ef7937a5898ea3f5"
    sha256 arm64_sonoma:   "efae67d8d635d8f05a27fc9ae4e75156bffa465828735428e3dfb6d1a117b6eb"
    sha256 arm64_ventura:  "fc4a77c30411f61b24a69be7ac380d6f79d3e9617c47f18f9c26e9c7a5ae11ef"
    sha256 arm64_monterey: "f987092472928a6f55bc65930ca911de4415f312cf9c9b8f3662baf4058b4b05"
    sha256 arm64_big_sur:  "d777d1b1193a49785df6150d908e38db8b2de415432f4acc55a635be32e69f64"
    sha256 sonoma:         "6a3667e99c6b8a5a0febbbe8567ed3a6a712d8421e34176cc2a51c7e20019fd0"
    sha256 ventura:        "9403514e48aabc3e5ed768524465eafa7bb5b5f1f67f3a128fe98a1fbae4aaa8"
    sha256 monterey:       "9e6a1fc7660ebab1bce04646cc625d107b43e0a5cba52c5b1f9868f56b4e4825"
    sha256 big_sur:        "3e32fcd2f971f88a8dcac24702147ff5847afb329d9c54cadd40e9c102bcb3c5"
    sha256 x86_64_linux:   "1835ec7faed90c796e7290a5b6271dda1ac6b2bdb15ce577367852ad92681c39"
  end

  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "openssl@3"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gettext"
    depends_on "libbsd"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1200

    system "./configure", "--prefix=#{prefix}",
                          "--disable-image",
                          "--with-ssl=#{Formula["openssl@3"].opt_prefix}"
    system "make", "install"
  end

  test do
    assert_match "DuckDuckGo", shell_output("#{bin}/w3m -dump https://duckduckgo.com")
  end
end
