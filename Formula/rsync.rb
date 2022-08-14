class Rsync < Formula
  desc "Utility that provides fast incremental file transfer"
  homepage "https://rsync.samba.org/"
  url "https://rsync.samba.org/ftp/rsync/rsync-3.2.5.tar.gz"
  mirror "https://mirrors.kernel.org/gentoo/distfiles/rsync-3.2.5.tar.gz"
  mirror "https://www.mirrorservice.org/sites/rsync.samba.org/rsync-3.2.5.tar.gz"
  sha256 "2ac4d21635cdf791867bc377c35ca6dda7f50d919a58be45057fd51600c69aba"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://rsync.samba.org/ftp/rsync/?C=M&O=D"
    regex(/href=.*?rsync[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "08fa9554d1b59cb8527e512fb229ce42601d667637b48632f8bbcae66e577431"
    sha256 cellar: :any,                 arm64_big_sur:  "61dac9ffea0f0a40eaf9314c3b1ceba2fa8c8a9a87d0d5c0fd3a20799535a339"
    sha256 cellar: :any,                 monterey:       "a2db12f600e356b534b4f474e80532b6c51bdf08143f955071e39151bb8c1ea0"
    sha256 cellar: :any,                 big_sur:        "a159bf383a27f7457b2c33faac2ea59783e19d603e6536685ca003029b7d1de9"
    sha256 cellar: :any,                 catalina:       "b33b761cc75d35245f73b3b5223629b92f37a23a6d42e460f94ec31581bad2a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c03f0aac78c37c2b2d15dfd79208d23056143b936b2df867db7eee371e143ae"
  end

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
