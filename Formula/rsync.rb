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
    sha256 cellar: :any,                 arm64_monterey: "e81cbf8b5c10a45c292323ac21d2dddc30e75b055254561e5c39ad1ecde5013d"
    sha256 cellar: :any,                 arm64_big_sur:  "ba293d27c4c615fe8afc1ad3bfa1e22b68856579fe75939d40a213368e769111"
    sha256 cellar: :any,                 monterey:       "7a1103d28fe70a3e4a79d27da3b8cadef1b046f427731c5b2501e22aa17eed24"
    sha256 cellar: :any,                 big_sur:        "801ad0f88a3db6c9339825cd3e100a2f22b756ff7c84c3f0e9874ed99cf1210e"
    sha256 cellar: :any,                 catalina:       "ac69d4ef788e0eb998cf0c0ab128f1dba057ab87c603ac75420445cce03133c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f67e2ca6df78af1f225a415e124687992e5810c488b6846c1743bab36b79c60"
  end

  depends_on "lz4"
  depends_on "openssl@1.1"
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
