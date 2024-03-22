class Rsync < Formula
  desc "Utility that provides fast incremental file transfer"
  homepage "https://rsync.samba.org/"
  url "https://rsync.samba.org/ftp/rsync/rsync-3.2.7.tar.gz"
  mirror "https://mirrors.kernel.org/gentoo/distfiles/rsync-3.2.7.tar.gz"
  mirror "https://www.mirrorservice.org/sites/rsync.samba.org/rsync-3.2.7.tar.gz"
  sha256 "4e7d9d3f6ed10878c58c5fb724a67dacf4b6aac7340b13e488fb2dc41346f2bb"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://rsync.samba.org/ftp/rsync/?C=M&O=D"
    regex(/href=.*?rsync[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d68788aadb63680a636992bdb2edb9b0380aa8d2efb95652fcedac30516b7044"
    sha256 cellar: :any,                 arm64_ventura:  "071de5ab73fa5f455d1861ac33b5f618f7672f53442ccb50a8c3af55312f58e0"
    sha256 cellar: :any,                 arm64_monterey: "01361cf8e78ce7c629d97b6474ad417632010e099b6aa881fac5bf39786a973c"
    sha256 cellar: :any,                 arm64_big_sur:  "e7e106b801d5fd324ae7fc99384141cad1a11b031dbb3a18825747aa1f6e1313"
    sha256 cellar: :any,                 sonoma:         "eb41ded3d3630e37e01d718f386a41ba5f5820cd949cb1e0cc56131ad1d01d14"
    sha256 cellar: :any,                 ventura:        "c1d2161f8ca6d894e3f32f1d1cb54babd5bed9a8e078a08a9c37f776a4bc06db"
    sha256 cellar: :any,                 monterey:       "63d05e0e6ecb5161b9e29704db7607d00e97898e143bca3eabba5c146b776aaf"
    sha256 cellar: :any,                 big_sur:        "a6262a2ac03fa34a43bd0e187a54a1e89cf523dd03c7fe87a6fde5d1599860ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81689deca3e1695f3976b576c54a38348632c43ce8453d6d1b318d8a087f2827"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "popt"
  depends_on "xxhash"
  depends_on "zstd"

  uses_from_macos "zlib"

  # hfs-compression.diff has been marked by upstream as broken since 3.1.3
  # and has not been reported fixed as of 3.2.7
  patch do
    url "https://download.samba.org/pub/rsync/src/rsync-patches-3.2.7.tar.gz"
    mirror "https://www.mirrorservice.org/sites/rsync.samba.org/rsync-patches-3.2.7.tar.gz"
    sha256 "e7e5e9ea0b6dd7639c7a5c6f49a1d06be20d449d59f60ba59b238e1aa79b13f0"
    apply "patches/fileflags.diff"
  end

  def install
    args = %W[
      --with-rsyncd-conf=#{etc}/rsyncd.conf
      --with-included-popt=no
      --with-included-zlib=no
      --enable-ipv6
    ]

    system "./configure", *std_configure_args, *args
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
