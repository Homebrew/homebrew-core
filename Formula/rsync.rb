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
    sha256 cellar: :any,                 arm64_monterey: "184eaa2a354031d53d8554f05e83b8c50039d14559e59fc8d558cacaaea19867"
    sha256 cellar: :any,                 arm64_big_sur:  "f981530420a9c2a55090a9c314ad5d824b38832340551541956eaf907df38d0a"
    sha256 cellar: :any,                 monterey:       "5bcc10544cfc7c573aca88a95329c8a1ef87c57d34bc33bf7ce79c491e37cb7b"
    sha256 cellar: :any,                 big_sur:        "568310e2736cf2d7ea4da24f59b4f9e63756764ccee5f61390ccd518c980c546"
    sha256 cellar: :any,                 catalina:       "7de1d3454f65f6b0d22544583de6b6ca568695adeadce54e36a3798ee0dd0ef6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecbd308c771400561a49c9aa15a0738b3875cfe1c0b52b85744d160cca7494dc"
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
