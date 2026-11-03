class Rsync < Formula
  desc "Utility that provides fast incremental file transfer"
  homepage "https://rsync.samba.org/"
  url "https://github.com/RsyncProject/rsync/releases/download/v3.5.2/rsync-3.5.2.tar.gz"
  mirror "https://rsync.samba.org/ftp/rsync/rsync-3.5.2.tar.gz"
  sha256 "a10d591825251e070f74c98df3daad195def4ed81b4a2de16169026aea33f6c8"
  license "GPL-3.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1c0313039284937a72b2e44e40286a6feaa5bf8716e72a10715977113d3195b3"
    sha256 cellar: :any, arm64_tahoe:       "f8626ce976d60f1e87cf3399d25344859a98a0bacdf28b9fd3db2ac64a0f9f9e"
    sha256 cellar: :any, arm64_sequoia:     "3f7f5f7187f553064968ca84e685d18c78b4e9234f081ecf4a21ae799adc62b3"
    sha256 cellar: :any, arm64_linux:       "73f795714ec7ca9873cbad34d11acd0040cfbfaa3157d941e2b8e2e8f3c7766d"
    sha256 cellar: :any, x86_64_linux:      "8499e94370d38687576613c3db7f3f7129540a526857cf5ba0e06dc30864c185"
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
