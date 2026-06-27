class Rsync < Formula
  desc "Utility that provides fast incremental file transfer"
  homepage "https://rsync.samba.org/"
  url "https://rsync.samba.org/ftp/rsync/rsync-3.4.4.tar.gz"
  mirror "https://mirrors.kernel.org/gentoo/distfiles/rsync-3.4.4.tar.gz"
  mirror "https://www.mirrorservice.org/sites/rsync.samba.org/rsync-3.4.4.tar.gz"
  sha256 "bd88cf82fa653da32314fb229136407c5c90f80d1758d8f4b091767877d8fa96"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://rsync.samba.org/ftp/rsync/?C=M&O=D"
    regex(/href=.*?rsync[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "47a6219946891014eeaa93105f1c2716e1260f068f7d9b9dab43d47e13b04ad2"
    sha256 cellar: :any, arm64_sequoia: "327275b831b2117cfbffa6d73a37daefe26f04e443489f2200b3996ebf680b29"
    sha256 cellar: :any, arm64_sonoma:  "889ce36094a0ed9272c15adb1ae1a9149c608d7450b1bcb25d8e80579864fe80"
    sha256 cellar: :any, sonoma:        "8334f68dbe60dc8bd73e54366164c01e89b32cf3a2c10648f1b328fd778e26f3"
    sha256 cellar: :any, arm64_linux:   "62fd03ffedabb0d878d8324779a5d748a5cd8b4d6797cbca595889b05136ef18"
    sha256 cellar: :any, x86_64_linux:  "b7fdfd50dd31bc48d1b590b5df638e66f26a2f850c4eabdb1c6be099df2d80b9"
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
