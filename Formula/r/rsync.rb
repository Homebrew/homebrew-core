class Rsync < Formula
  desc "Utility that provides fast incremental file transfer"
  homepage "https://rsync.samba.org/"
  url "https://rsync.samba.org/ftp/rsync/rsync-3.4.2.tar.gz"
  mirror "https://mirrors.kernel.org/gentoo/distfiles/rsync-3.4.2.tar.gz"
  mirror "https://www.mirrorservice.org/sites/rsync.samba.org/rsync-3.4.2.tar.gz"
  sha256 "ff10aa2c151cd4b2dbbe6135126dbc854046113d2dfb49572a348233267eb315"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://rsync.samba.org/ftp/rsync/?C=M&O=D"
    regex(/href=.*?rsync[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "25f90781c38640e1db42dc6781b96aa9e6f2ee1bf400a0a15c31eebe8263487c"
    sha256 cellar: :any,                 arm64_sequoia: "89660ae05442504adc311e3c78d4e31f5b1b43b77a41d5727437ee4dd24b04a6"
    sha256 cellar: :any,                 arm64_sonoma:  "f9ba9d2c965bb61f0fb5e8406cdf80d36b33b90e8ba2a40887f50b68a7c2170a"
    sha256 cellar: :any,                 sonoma:        "b0d2c87a8cadcca9b55e7315932ba562e0033b025fb9d0a7fc36a1411737a373"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6f18bad4597008398094ed3011d1f6e08ec7f8a662a8f35359da79c18464f69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f79dfe41245d5601e2345446ba7899c6cc6a3b4f5f2fea84829530f4ac90a66b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "popt"
  depends_on "xxhash"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Move `rrsync` manual to the correct directory
    mv buildpath/"rrsync.1", "support/"

    args = %W[
      --with-rsyncd-conf=#{etc}/rsyncd.conf
      --with-included-popt=no
      --with-included-zlib=no
      --with-rrsync=yes
      --enable-ipv6
    ]

    system "./configure", *args, *std_configure_args
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
