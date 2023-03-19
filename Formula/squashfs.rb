class Squashfs < Formula
  desc "Compressed read-only file system for Linux"
  homepage "https://github.com/plougher/squashfs-tools"
  url "https://github.com/plougher/squashfs-tools/archive/4.6.tar.gz"
  sha256 "afc157495fa90d2042172fc642237afe1956f1a5beb141058bba3256b8d92013"
  license "GPL-2.0-or-later"
  head "https://github.com/plougher/squashfs-tools.git", branch: "master"

  # Tags like `4.4-git.1` are not release versions and the regex omits these
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "58c8745b53df2992c562478b518a74e65bad8c02589c166da551998fdb658b69"
    sha256 cellar: :any,                 arm64_monterey: "50dcadbee689df7c02ebe5d670130702adffccdb571065708f46e1ac1931e987"
    sha256 cellar: :any,                 arm64_big_sur:  "598644964161de2d652b91dd290a5a5e0e690de017a949330efcf9ad29ce5596"
    sha256 cellar: :any,                 ventura:        "722e80872808ded8cf150daaaddaae5f431ccd027f351d13bd0c2d0c2ec3a8fb"
    sha256 cellar: :any,                 monterey:       "885f25d16305d7cdaefe226e5601eb07c990d471f428d095e4107b3dd1264e85"
    sha256 cellar: :any,                 big_sur:        "7363ce181dc2581dc4862218bc08ad20dc24729fe93c2ac63b0e0090dc714670"
    sha256 cellar: :any,                 catalina:       "3bd185a9c1a765fb32186dfb141315932ca36b9b3efce9213e5e1289f739d65d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aef2b6dbbd4c705660275eb97408cf64bb9e4a8a5119a5646e08d2f19bb0b8a0"
  end

  depends_on "gnu-sed" => :build
  depends_on "help2man" => :build

  depends_on "lz4"
  depends_on "lzo"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "zlib"

  # Patch necessary to emulate the sigtimedwait process otherwise we get build failures.
  # Also clang fixes, extra endianness knowledge and a bundle of other macOS fixes.
  # usptream PR ref: https://github.com/plougher/squashfs-tools/pull/233
  patch do
    url "https://github.com/plougher/squashfs-tools/commit/4a33df67a4ec67d32a6a58745517c8fbaa47d602.patch?full_index=1"
    sha256 "d079a51e56da1501e118af90bf4e3ebabf207ceaca3f0aab0194d15f5d499845"
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

    commands = %w[mksquashfs unsquashfs sqfscat sqfstar]

    cd "squashfs-tools" do
      system "make", *args
      bin.install commands
    end

    ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec/"gnubin"
    mkdir_p man1
    cd "generate-manpages" do
      commands.each do |command|
        system "./#{command}-manpage.sh", bin, man1/"#{command}.1"
      end
    end

    doc.install %W[
      README-#{version}
      USAGE-#{version}
      USAGE-MKSQUASHFS-#{version}
      USAGE-SQFSCAT-#{version}
      USAGE-SQFSTAR-#{version}
      USAGE-UNSQUASHFS-#{version}
      COPYING
    ]
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
