class Rsync < Formula
  desc "Utility that provides fast incremental file transfer"
  homepage "https://rsync.samba.org/"
  url "https://github.com/RsyncProject/rsync/releases/download/v3.5.1/rsync-3.5.1.tar.gz"
  mirror "https://rsync.samba.org/ftp/rsync/rsync-3.5.1.tar.gz"
  sha256 "c55f9c9dc10fb8bec397b399a0fdded53cc9a2d8e30891bb0d63724d25c37bef"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b9bf0049adf7c331cffcde8da12b499bbdc107ab097a328ba4b9a2a00358e235"
    sha256 cellar: :any, arm64_tahoe:       "c13909ed22964467473786560c89a4e58a68f9bff46c8976db3785a083f539f7"
    sha256 cellar: :any, arm64_sequoia:     "f4da2206419d4f03f6a966b35bf21283b3f975c1b7cbb69ef5926070264c5695"
    sha256 cellar: :any, arm64_linux:       "ad05b5d79762136ad7aeb2753d37ee6c1f865a476ecef973a0f0a686717f9e38"
    sha256 cellar: :any, x86_64_linux:      "67fc87a9f59d57b2df5ce78a36afc3a1ad2d5a8aaa9f0698e0e6b68b1dcf32e2"
  end

  depends_on "libidn2"
  depends_on "lz4"
  depends_on "openssl@3"
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
