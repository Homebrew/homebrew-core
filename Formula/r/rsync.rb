class Rsync < Formula
  desc "Utility that provides fast incremental file transfer"
  homepage "https://rsync.samba.org/"
  url "https://github.com/RsyncProject/rsync/releases/download/v3.5.2/rsync-3.5.2.tar.gz"
  mirror "https://rsync.samba.org/ftp/rsync/rsync-3.5.2.tar.gz"
  sha256 "a10d591825251e070f74c98df3daad195def4ed81b4a2de16169026aea33f6c8"
  license "GPL-3.0-or-later"
  compatibility_version 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "ed7eaefb29afddb3caa23fa9fb196ce22970a80ed122f8f8e8a748c470751969"
    sha256 cellar: :any, arm64_tahoe:       "d69be3a3d34872a903df96ab8767de96a407819f3d9b80b8d8a75dc738796033"
    sha256 cellar: :any, arm64_sequoia:     "3398c5c1587212bf7a9d88efaa4728fca79586b8110c6c2fb52ebf2622446879"
    sha256 cellar: :any, arm64_linux:       "785b41d1bb830876bd483268a7103b2199361c72de9ea6afd0a118e9232432cb"
    sha256 cellar: :any, x86_64_linux:      "a4b03666566e0693e4cd2016ba8a0104c0ab5c71c8237aeb20d973e1bf6e4b96"
  end

  depends_on "libidn2"
  depends_on "lz4"
  depends_on "openssl@4"
  depends_on "popt"
  depends_on "xxhash"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
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
