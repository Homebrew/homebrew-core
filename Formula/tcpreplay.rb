class Tcpreplay < Formula
  desc "Replay saved tcpdump files at arbitrary speeds"
  homepage "https://tcpreplay.appneta.com/"
  url "https://github.com/appneta/tcpreplay/releases/download/v4.4.2/tcpreplay-4.4.2.tar.gz"
  sha256 "5b272cd83b67d6288a234ea15f89ecd93b4fadda65eddc44e7b5fcb2f395b615"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "BSD-4-Clause", "GPL-3.0-or-later", "ISC"]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e896b1585c29671bee6314886215fd6cc326b3f34888d7b820c32c39bf474c8e"
    sha256 cellar: :any,                 arm64_monterey: "ccbd67b7234176de48278515298a50ae17510c820950763b0e27a971d6080460"
    sha256 cellar: :any,                 arm64_big_sur:  "4bd03e1afa4b5528244fc212b17d21ed15bf0267284ce3f6d5cf7c5520c02484"
    sha256 cellar: :any,                 ventura:        "4699dc67c1339b1899097574d2c93dc9b6472631ab545e2a7236fd466b4aa5ed"
    sha256 cellar: :any,                 monterey:       "8d7c52940e75b1ae73e8e018627ccf944fd33d65393e9e8fbe2528c950335450"
    sha256 cellar: :any,                 big_sur:        "fe94278be5d54b8584156256b5181aeaaa464d353ad6dea909db2ed57d0d67f5"
    sha256 cellar: :any,                 catalina:       "44f5dbde556a34f20bfce3446fcf5167ee6f70099ad7504c82c91a3fe13ade10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdd15a5a256855f14c08bd9c24f8158d2783cd85bb515240af9a2c4c9d37dd74"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libdnet"

  uses_from_macos "libpcap"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-dynamic-link
      --with-libdnet=#{Formula["libdnet"].opt_prefix}
    ]

    args << if OS.mac?
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

      "--with-macosx-sdk=#{MacOS.version}"
    else
      "--with-libpcap=#{Formula["libpcap"].opt_prefix}"
    end

    system "./configure", *args

    system "make", "install"
  end

  test do
    system bin/"tcpreplay", "--version"
  end
end
