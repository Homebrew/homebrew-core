class Rsync < Formula
  desc "Utility that provides fast incremental file transfer"
  homepage "https://rsync.samba.org/"
  url "https://rsync.samba.org/ftp/rsync/rsync-3.2.3.tar.gz"
  mirror "https://mirrors.kernel.org/gentoo/distfiles/rsync-3.2.3.tar.gz"
  mirror "https://www.mirrorservice.org/sites/rsync.samba.org/rsync-3.2.3.tar.gz"
  sha256 "becc3c504ceea499f4167a260040ccf4d9f2ef9499ad5683c179a697146ce50e"
  license "GPL-3.0"

  livecheck do
    url "https://rsync.samba.org/ftp/rsync/?C=M&O=D"
    regex(/href=.*?rsync[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "fd92045e16b9b83ab6c281a1e658e27731ef9af53fcb6bb7ce6b9533851e728e" => :catalina
    sha256 "1be1e9754c4f4a4b043aece33299d90f50d01274682f63c29eca7d9bcb8a2090" => :mojave
    sha256 "5cf9c6e0014687c4abb4044e7f5e12d5d453b81c5dbadd472438b4131c655a1f" => :high_sierra
  end

  depends_on "lz4"
  depends_on "openssl@1.1"
  depends_on "popt"
  depends_on "xxhash"
  depends_on "zstd"

  uses_from_macos "zlib"

  # hfs-compression.diff has been marked by upstream as broken since 3.1.3
  # and has not been reported fixed as of 3.2.3
  patch do
    url "https://download.samba.org/pub/rsync/src/rsync-patches-3.2.3.tar.gz"
    mirror "https://www.mirrorservice.org/sites/rsync.samba.org/rsync-patches-3.2.3.tar.gz"
    sha256 "de6645b46967bd701b7d6f3e29cccb19d2b46a6fa2d26a9db165847dca0e42f2"
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
    # function multiversioning on older verions of macOS
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
