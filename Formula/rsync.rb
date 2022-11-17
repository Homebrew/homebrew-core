class Rsync < Formula
  desc "Utility that provides fast incremental file transfer"
  homepage "https://rsync.samba.org/"
  url "https://rsync.samba.org/ftp/rsync/rsync-3.2.7.tar.gz"
  mirror "https://mirrors.kernel.org/gentoo/distfiles/rsync-3.2.7.tar.gz"
  mirror "https://www.mirrorservice.org/sites/rsync.samba.org/rsync-3.2.7.tar.gz"
  sha256 "4e7d9d3f6ed10878c58c5fb724a67dacf4b6aac7340b13e488fb2dc41346f2bb"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://rsync.samba.org/ftp/rsync/?C=M&O=D"
    regex(/href=.*?rsync[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e3b86c84539aee3348b90d9d36d0f21d1243fa558aaf06f8801d9e5d56d2fd65"
    sha256 cellar: :any,                 arm64_monterey: "b7a8807e03cbb7a2cf29a866a3e3939b62adf9b2899207db74a41f7d4a2ceca3"
    sha256 cellar: :any,                 arm64_big_sur:  "8d32a4bab7c933a71f38ec82519cbc2059f5561a2b6a65d576000f602ae53ac5"
    sha256 cellar: :any,                 ventura:        "46580672114f2bad46e724fe3f24ee42512b2fb6509e52736d9c0121e5dacbba"
    sha256 cellar: :any,                 monterey:       "188b82cf9ff79825f8a03c4729d2b45b259c7ab1e3cdecbe5b903c5c82b09b3b"
    sha256 cellar: :any,                 big_sur:        "80b623812954e23d5f40849a46baa66b064358dbbc88257e2c60c175cfaa5f9f"
    sha256 cellar: :any,                 catalina:       "40333c17217324536b17db6a7de53915b9a86336ecac91e71c1131e5f71a67e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a91692c5fc5b38bc0d8f86fde53870a1fce5bf7ce4353a4d8ae09c556b65baa8"
  end

  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "popt"
  depends_on "xxhash"
  depends_on "zstd"

  uses_from_macos "zlib"

  # hfs-compression.diff has been marked by upstream as broken since 3.1.3
  # and has not been reported fixed as of 3.2.6
  patch do
    url "https://download.samba.org/pub/rsync/src/rsync-patches-3.2.6.tar.gz"
    mirror "https://www.mirrorservice.org/sites/rsync.samba.org/rsync-patches-3.2.6.tar.gz"
    sha256 "c3d13132b560f456fd8fc9fdf9f59377e91adf0dfc8117e33800d14b483d1a85"
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
