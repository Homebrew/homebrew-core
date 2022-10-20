class Rsync < Formula
  desc "Utility that provides fast incremental file transfer"
  homepage "https://rsync.samba.org/"
  url "https://rsync.samba.org/ftp/rsync/rsync-3.2.6.tar.gz"
  mirror "https://mirrors.kernel.org/gentoo/distfiles/rsync-3.2.6.tar.gz"
  mirror "https://www.mirrorservice.org/sites/rsync.samba.org/rsync-3.2.6.tar.gz"
  sha256 "fb3365bab27837d41feaf42e967c57bd3a47bc8f10765a3671efd6a3835454d3"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://rsync.samba.org/ftp/rsync/?C=M&O=D"
    regex(/href=.*?rsync[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "50c60b6d40fb1f003574d65d51cdea9f969fb6599bb823820ab8be2a7cf2c2c2"
    sha256 cellar: :any,                 arm64_big_sur:  "7a210780c383a15e4583d5f85783738cea89153420dc5712e5a49048efd1cc2b"
    sha256 cellar: :any,                 monterey:       "6336dda9fa4ed4686318c11921454db3c1a01028e9a9ab236164e251ffe917e8"
    sha256 cellar: :any,                 big_sur:        "5b1007064433abe5b805c3f1bd7415f9b389cd1fb2cdb856233226726605e02a"
    sha256 cellar: :any,                 catalina:       "bff3423449792bebf7339dffb810ea77b8265c6784a0c33a80d0c21453550601"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3cae1238890497a1ad48b1c4cee07d9ba1d09b913c409e167f40899d703ec72"
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
