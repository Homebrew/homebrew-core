class Rsync < Formula
  desc "Utility that provides fast incremental file transfer"
  homepage "https://rsync.samba.org/"
  url "https://github.com/RsyncProject/rsync/releases/download/v3.5.0/rsync-3.5.0.tar.gz"
  mirror "https://rsync.samba.org/ftp/rsync/rsync-3.5.0.tar.gz"
  sha256 "c7ffd1ef653e99540f661e47cb00b7f9cad1ee6b972399b16f93d672656e0d33"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "267a8d2a1869759a804c85fbbb952cc6e928abf84f8d7bba15310212d9926eb1"
    sha256 cellar: :any, arm64_sequoia: "58ecba02ba9759f536d3e0a2ac410b8b1a63f0752452fd6a71b57db98cf06c36"
    sha256 cellar: :any, arm64_sonoma:  "abc49c88d924db85ebc70ccf41ae5f0d978e6a5a85fa7ef9b334a280e08825bb"
    sha256 cellar: :any, sonoma:        "833347d4aadf2b3f1d2d5f104a7344170f481c6e957ee95cbda1bc41a05d736f"
    sha256 cellar: :any, arm64_linux:   "afae3006ae0d7daf2e68345cd2273987937bc6702c679145bd71108b816817c2"
    sha256 cellar: :any, x86_64_linux:  "b2f066bc10fc9ce26805f9792f12ea78c651cfbf8c0364d480610ee3d90c5ccb"
  end

  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "popt"
  depends_on "xxhash"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Fix Linux sandbox compatibility
  patch do
    url "https://github.com/RsyncProject/rsync/commit/56e37eae666c7b0a52d29e9d1fb27325aaa8acf0.patch?full_index=1"
    sha256 "3bb2d6096b7fc2dcf550af022f32c00cf8fa186ad84596c574ddac29c38e23fb"
    type :unofficial
    resolves "https://github.com/RsyncProject/rsync/pull/1052"
  end

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
