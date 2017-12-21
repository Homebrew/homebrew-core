class Squashfs < Formula
  desc "Compressed read-only file system for Linux"
  homepage "https://squashfs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/squashfs/squashfs/squashfs4.3/squashfs4.3.tar.gz"
  sha256 "0d605512437b1eb800b4736791559295ee5f60177e102e4d4ccd0ee241a5f3f6"
  revision 1

  bottle do
    cellar :any
    sha256 "06c8d10e167295f91684c9c5bb596143189f4de5f4e1cba7b3f45ab0ee9ed1cb" => :high_sierra
    sha256 "cbf0fba9b2b73aff6465c8611453b832886159c6e12191eb27ab39e58e9ef577" => :sierra
    sha256 "192a9b40b56ded7b5d97c1ae9a587173f4380e0a71ec8332dc475d9c5beeb5e1" => :el_capitan
  end

  depends_on "lzo"
  depends_on "xz"
  depends_on "lz4" => :optional

  # Patch necessary to emulate the sigtimedwait process otherwise we get build failures
  # Also clang fixes, extra endianness knowledge and a bundle of other macOS fixes.
  # Originally from https://github.com/plougher/squashfs-tools/pull/3
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/05ae0eb1/squashfs/squashfs-osx-bundle.diff"
    sha256 "276763d01ec675793ddb0ae293fbe82cbf96235ade0258d767b6a225a84bc75f"
  end

  def install
    args = %W[
      XATTR_SUPPORT=0
      EXTRA_CFLAGS=-std=gnu89
      LZO_SUPPORT=1
      LZO_DIR=#{Formula["lzo"].opt_prefix}
      XZ_SUPPORT=1
      XZ_DIR=#{Formula["xz"].opt_prefix}
      LZMA_XZ_SUPPORT=1
    ]
    args << "LZ4_SUPPORT=1" if build.with? "lz4"

    cd "squashfs-tools" do
      system "make", *args
      bin.install %w[mksquashfs unsquashfs]
    end
    doc.install %w[ACKNOWLEDGEMENTS INSTALL OLD-READMEs PERFORMANCE.README README-4.3]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unsquashfs -v", 1)
  end
end
