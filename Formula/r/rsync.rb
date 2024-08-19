class Rsync < Formula
  desc "Utility that provides fast incremental file transfer"
  homepage "https://rsync.samba.org/"
  url "https://rsync.samba.org/ftp/rsync/rsync-3.3.0.tar.gz"
  mirror "https://mirrors.kernel.org/gentoo/distfiles/rsync-3.3.0.tar.gz"
  mirror "https://www.mirrorservice.org/sites/rsync.samba.org/rsync-3.3.0.tar.gz"
  sha256 "7399e9a6708c32d678a72a63219e96f23be0be2336e50fd1348498d07041df90"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://rsync.samba.org/ftp/rsync/?C=M&O=D"
    regex(/href=.*?rsync[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "aedcc676dfc2ba721d7e780a852525c3a96ab045ff5225b72ca31b0248aa5abc"
    sha256 cellar: :any,                 arm64_ventura:  "800017d5ed8d03f6c0ff9e45830b09d5fd709ad1cf565b056782a65aef061769"
    sha256 cellar: :any,                 arm64_monterey: "87da2d08d06cc90b4087e8ef50418a9ec3a0ceecb23e1ec75ffad2b411c5400a"
    sha256 cellar: :any,                 sonoma:         "5ef1e7552fe1fe4fcbf336c83313033a544768d4f8e7cc166ea4f91c2867c35b"
    sha256 cellar: :any,                 ventura:        "c0d2c0d516ca8ed44cdd846a9066b5b9748ce56dc26fc0be07f057f15e730460"
    sha256 cellar: :any,                 monterey:       "502081be38ed754a5fce7c4a38bfb2aaad99923ffa27a9fe4b13e3e0df7635c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db52f38e89890b3c5b50931db4d3910984dbc8180466c250495f3e7b579a7366"
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
    url "https://download.samba.org/pub/rsync/src/rsync-patches-3.3.0.tar.gz"
    mirror "https://www.mirrorservice.org/sites/rsync.samba.org/rsync-patches-3.3.0.tar.gz"
    sha256 "3dd51cd88d25133681106f68622ebedbf191ab25a21ea336ba409136591864b0"
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
