class Rsync < Formula
  desc "Utility that provides fast incremental file transfer"
  homepage "https://rsync.samba.org/"
  url "https://rsync.samba.org/ftp/rsync/rsync-3.2.4.tar.gz"
  mirror "https://mirrors.kernel.org/gentoo/distfiles/rsync-3.2.4.tar.gz"
  mirror "https://www.mirrorservice.org/sites/rsync.samba.org/rsync-3.2.4.tar.gz"
  sha256 "6f761838d08052b0b6579cf7f6737d93e47f01f4da04c5d24d3447b7f2a5fad1"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://rsync.samba.org/ftp/rsync/?C=M&O=D"
    regex(/href=.*?rsync[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5203ca4a96801c82df6304be050d16676edeb1179d060055c0a0d024719c647f"
    sha256 cellar: :any,                 arm64_big_sur:  "7a97c83e5bdc7abfec4e3a605e5e7f2c142378dbb14719930b5da58ac11f8c58"
    sha256 cellar: :any,                 monterey:       "57d1cf3bed28db1f850a5ce119dbd9a4ca6de38ec446a7a406e0f9510446af50"
    sha256 cellar: :any,                 big_sur:        "1b9467be7a8c6199fd3b86ff1e316d8d6ada4ddd22b9ba3c4f0449207b9c36e0"
    sha256 cellar: :any,                 catalina:       "76221855501830c9a97f08cdf24003d2540934f12d8758883cfbea2780bb827e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25827ec52d77b05cadd5930d0d0b81f327477639badaafb538b755c886a9f677"
  end

  depends_on "autoconf"
  depends_on "automake"
  depends_on "lz4"
  depends_on "openssl@1.1"
  depends_on "popt"
  depends_on "xxhash"
  depends_on "zstd"

  uses_from_macos "zlib"

  # hfs-compression.diff has been marked by upstream as broken since 3.1.3
  # and has not been reported fixed as of 3.2.4
  patch do
    url "https://download.samba.org/pub/rsync/src/rsync-patches-3.2.4.tar.gz"
    mirror "https://www.mirrorservice.org/sites/rsync.samba.org/rsync-patches-3.2.4.tar.gz"
    sha256 "70a597590af6c61cf3d05d663429ff9f60ffe24e44f9c73a4cdc69ebdc1322a4"
    apply "patches/fileflags.diff"
  end

  patch do
    url "https://download.samba.org/pub/rsync/rsync-schar-fix-3.2.4.diff"
    sha256 "1c3baba01f3087ae2d2aa9195eedf97adf2b57f0482e9435a0433525c399635f"
    apply "rsync-schar-fix-3.2.4.diff"
  end

  def install
    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --with-rsyncd-conf=#{etc}/rsyncd.conf
      --with-included-popt=no
      --with-included-zlib=no
      --enable-ipv6
    ]

    # SIMD code throws ICE or is outright unsupported due to lack of support for
    # function multiversioning on older versions of macOS
    args << "--disable-simd" if MacOS.version < :catalina

    # Remove in the next release, needed for rsync-schar-fix-3.2.4.diff
    system "autoreconf", "-fi"
    system "autoconf", "-o", "configure.sh"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    mkdir "a"
    mkdir "b"

    ["foo\n", "bar\n", "baz\n"].map.with_index do |s, i|
      (testpath/"a/#{i + 1}.txt").write s
    end

    system bin/"rsync", "-artv", testpath/"a/", testpath/"b/"

    (1..3).each do |i|
      assert_equal (testpath/"a/#{i}.txt").read, (testpath/"b/#{i}.txt").read
    end
  end
end
