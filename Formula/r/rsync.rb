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
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "0788bfffd17f8bc2e8a811872138dc1c982fe0ad499a7a3de787d49f698cf52a"
    sha256 cellar: :any,                 arm64_sequoia: "80935e18dbfba662f81e08e57e753086c8d25489a2f64a0f00323be2cba1f8f0"
    sha256 cellar: :any,                 arm64_sonoma:  "030d807ac23fa2ce01203c46830f354070330e8b60b945b9b37b2065d5365132"
    sha256 cellar: :any,                 sonoma:        "745da62d69fc3b379ac37773cfa93fdb57f47bbd4407d04ce4a0a0744a2d0c31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad8ff5025ca448e37ffd3b463cdbfd22b344a3b6830c39e88cb798cdcdcddddd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f9d25a62161a4c53d96c3ac1b5053e5f21a0fd02c8bf466ff82b0bbe2d3ffd9"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmark-gfm" => :build
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "popt"
  depends_on "xxhash"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # hfs-compression.diff has been marked by upstream as broken since 3.1.3
  # and has not been reported fixed as of 3.2.7
  patch do
    url "https://download.samba.org/pub/rsync/src/rsync-patches-3.4.1.tar.gz"
    mirror "https://www.mirrorservice.org/sites/rsync.samba.org/rsync-patches-3.4.1.tar.gz"
    sha256 "f56566e74cfa0f68337f7957d8681929f9ac4c55d3fb92aec0d743db590c9a88"
    apply "patches/fileflags.diff"
  end

  def install
    # build rrsync.1 which is not included in the source tarball
    (buildpath/"support/rrsync.1").write Utils.safe_popen_read("cmark-gfm", "support/rrsync.1.md", "--to", "man")

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
