class Rsync < Formula
  desc "Utility that provides fast incremental file transfer"
  homepage "https://rsync.samba.org/"
  url "https://rsync.samba.org/ftp/rsync/rsync-3.4.3.tar.gz"
  mirror "https://mirrors.kernel.org/gentoo/distfiles/rsync-3.4.3.tar.gz"
  mirror "https://www.mirrorservice.org/sites/rsync.samba.org/rsync-3.4.3.tar.gz"
  sha256 "c72e63ca3021cbc80ba86ec30102773f4c5631fbc492b52e773b3958f82a53d3"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://rsync.samba.org/ftp/rsync/?C=M&O=D"
    regex(/href=.*?rsync[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bb2711db3dec95d397ef2fb65be4a136e214081cef86c71467349cf98d2a1c1f"
    sha256 cellar: :any,                 arm64_sequoia: "06cf0bdab94e743a9fd4c6cc3545effdd15a518d55c35230298d0d5c5ba308de"
    sha256 cellar: :any,                 arm64_sonoma:  "4cc8ecff92564b6f1a1c7a0d7c1683d62764742697a7f39d63e833708844a561"
    sha256 cellar: :any,                 sonoma:        "19354ee75efeaa1a508a308ad8f7112c533ddce972a607ce4f301adaf33e60ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "599739bb2c17e5c44bb6a9c8936daf10a2c1625132655c028c5a47f766c98e44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa7bbf0d8d541a86bc474ae9ecfebcd1a47900bfc00238e78f5210b60b15df38"
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
