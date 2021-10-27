class Squashfs < Formula
  desc "Compressed read-only file system for Linux"
  homepage "https://github.com/plougher/squashfs-tools"
  url "https://github.com/plougher/squashfs-tools/archive/4.5.tar.gz"
  sha256 "b9e16188e6dc1857fe312633920f7d71cc36b0162eb50f3ecb1f0040f02edddd"
  license "GPL-2.0"
  head "https://github.com/plougher/squashfs-tools.git", branch: "master"

  # Tags like `4.4-git.1` are not release versions and the regex omits these
  # (see: https://github.com/plougher/squashfs-tools/issues/96).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d7f5df25aff892c871e31ac31117945ab98b7390eb1c0b05d0e355efeee05b56"
    sha256 cellar: :any,                 arm64_big_sur:  "55318dc9912602fe8452b595071511ebc10aec729429d101c4d87b0f11af23be"
    sha256 cellar: :any,                 monterey:       "896eccf7efeaa99831f7d1ebef0f81e379a2b8b139a7bf4f14fa2f394d168b16"
    sha256 cellar: :any,                 big_sur:        "6367ccf7c5ee95740026bf87f9c47b4cc430d03fe2c0bc4d4db78a029cd799b9"
    sha256 cellar: :any,                 catalina:       "1821a023342782230162c1fd3b2a1a760952b1a171bd97482b8aaf9d3e2a4e38"
    sha256 cellar: :any,                 mojave:         "0d78285daf5f932e2c8459242b340fd895a51195c2582c1e6ccc43f3f7f635c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5d319d1cafa8de74886f9e41623bcf1a1cb75307d9d62d143220f386d5b5206"
  end

  depends_on "lz4"
  depends_on "lzo"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "zlib"

  # Patch necessary to emulate the sigtimedwait process otherwise we get build failures.
  # Also clang fixes, extra endianness knowledge and a bundle of other macOS fixes.
  # Original patchset: https://github.com/plougher/squashfs-tools/pull/69
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/d75d6958612eb590580872d1878f26af6d2deb83/squashfs/4.5.patch"
    sha256 "d90f3b167e016f44a87b84c2ccbb9bcfc47d28fc51b630857e7e27bd01b58084"
  end

  def install
    args = %W[
      EXTRA_CFLAGS=-std=gnu89
      LZ4_DIR=#{Formula["lz4"].opt_prefix}
      LZ4_SUPPORT=1
      LZO_DIR=#{Formula["lzo"].opt_prefix}
      LZO_SUPPORT=1
      XZ_DIR=#{Formula["xz"].opt_prefix}
      XZ_SUPPORT=1
      LZMA_XZ_SUPPORT=1
      ZSTD_DIR=#{Formula["zstd"].opt_prefix}
      ZSTD_SUPPORT=1
      XATTR_SUPPORT=1
    ]

    cd "squashfs-tools" do
      system "make", *args
      bin.install %w[mksquashfs unsquashfs]
    end

    doc.install %W[README-#{version.major_minor} RELEASE-READMEs USAGE COPYING]
  end

  test do
    # Check binaries execute
    assert_match version.to_s, shell_output("#{bin}/mksquashfs -version")
    assert_match version.to_s, shell_output("#{bin}/unsquashfs -v", 1)

    (testpath/"in/test1").write "G'day!"
    (testpath/"in/test2").write "Bonjour!"
    (testpath/"in/test3").write "Moien!"

    # Test mksquashfs can make a valid squashimg.
    #   (Also tests that `xz` support is properly linked.)
    system "#{bin}/mksquashfs", "in/test1", "in/test2", "in/test3", "test.xz.sqsh", "-quiet", "-comp", "xz"
    assert_predicate testpath/"test.xz.sqsh", :exist?
    assert_match "Found a valid SQUASHFS 4:0 superblock on test.xz.sqsh.",
      shell_output("#{bin}/unsquashfs -s test.xz.sqsh")

    # Test unsquashfs can extract files verbatim.
    system "#{bin}/unsquashfs", "-d", "out", "test.xz.sqsh"
    assert_predicate testpath/"out/test1", :exist?
    assert_predicate testpath/"out/test2", :exist?
    assert_predicate testpath/"out/test3", :exist?
    assert shell_output("diff -r in/ out/")
  end
end
