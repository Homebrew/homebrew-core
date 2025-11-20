class Rsync < Formula
  desc "Utility that provides fast incremental file transfer"
  homepage "https://rsync.samba.org/"
  url "https://rsync.samba.org/ftp/rsync/rsync-3.4.1.tar.gz"
  mirror "https://mirrors.kernel.org/gentoo/distfiles/rsync-3.4.1.tar.gz"
  mirror "https://www.mirrorservice.org/sites/rsync.samba.org/rsync-3.4.1.tar.gz"
  sha256 "2924bcb3a1ed8b551fc101f740b9f0fe0a202b115027647cf69850d65fd88c52"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://rsync.samba.org/ftp/rsync/?C=M&O=D"
    regex(/href=.*?rsync[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c4718ba8eae84dd515309bd6d802dd14e9940c3ec92fe582ee1ff44dc1ace223"
    sha256 cellar: :any,                 arm64_sequoia: "fecb8e00e23e675273e3e5fa9c9f545caab740dba09fb4af59169e18b0b1cc67"
    sha256 cellar: :any,                 arm64_sonoma:  "7eba5b3c101d16dfbebc11bbddbc646a1afe2c1aacb24611542cd8e07d99a416"
    sha256 cellar: :any,                 arm64_ventura: "3afce8ca8f96b8bb1e78e01975e0c9e5f47326f62d1d868555de1fbc92fe1744"
    sha256 cellar: :any,                 sonoma:        "f165d31173c7f7c1905fa9b8df834c8d11bb52b4fe004f39205b162ccbd75b50"
    sha256 cellar: :any,                 ventura:       "fb11a1420c2f4e77dfffa8b9459ddc240a92d6e9aeee9e3738c4a2cfe54ca50f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35f275c63b686ecad743f43adcd6dcd31480cb741dfa53a52dedf63eb1553536"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f3d0ea8a719d88f7c99670a295d7007c445ed3084c994a921773553a356f645"
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
    url "https://download.samba.org/pub/rsync/src/rsync-patches-3.4.1.tar.gz"
    mirror "https://www.mirrorservice.org/sites/rsync.samba.org/rsync-patches-3.4.1.tar.gz"
    sha256 "f56566e74cfa0f68337f7957d8681929f9ac4c55d3fb92aec0d743db590c9a88"
    apply "patches/fileflags.diff"
  end

  def install
    args = %W[
      --with-rsyncd-conf=#{etc}/rsyncd.conf
      --with-included-popt=no
      --with-included-zlib=no
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
