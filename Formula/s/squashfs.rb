class Squashfs < Formula
  desc "Compressed read-only file system for Linux"
  homepage "https://github.com/plougher/squashfs-tools"
  url "https://github.com/plougher/squashfs-tools/archive/refs/tags/4.7.4.tar.gz"
  sha256 "91c49f9a1ed972ad00688a38222119e2baf49ba74cf5fda05729a79d7d59d335"
  license "GPL-2.0-or-later"
  head "https://github.com/plougher/squashfs-tools.git", branch: "master"

  # Tags like `4.4-git.1` are not release versions and the regex omits these
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "d06e5f17cf7235d2dcd274fe30cdca11ee1c9ab85fb6c3c3e1e9da228882e300"
    sha256 cellar: :any,                 arm64_sequoia: "cb58e3a0f2f10527b378d10ba3cefe218e83581ac0de3a3855f852cb03644693"
    sha256 cellar: :any,                 arm64_sonoma:  "f40a37fd3e22bfd8dbb3d5d9b8eaa6b05404402f77fd0f32f4c7e582e7266156"
    sha256 cellar: :any,                 sonoma:        "cb1c63bed26142887ee3a803c7707c44cb022cffdd00336db65da70009d90f62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55850287f13c7e1902cd00466ff8c32162a70312e013dfab9dc79187b0281d89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b2c587b9bdee5c8b461ee022f724b0c2f83edeee935d18d6f8484e4713df3e8"
  end

  depends_on "gnu-sed" => :build
  depends_on "help2man" => :build

  depends_on "lz4"
  depends_on "lzo"
  depends_on "xz"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      EXTRA_CFLAGS=-std=gnu99
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
    cd "squashfs-tools/generate-manpages" do
      commands.each do |command|
        system "./#{command}-manpage.sh", bin, man1/"#{command}.1"
      end
    end

    doc.install Dir["Documentation/#{version.major_minor}/*"]
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
    system bin/"mksquashfs", "in/test1", "in/test2", "in/test3", "test.xz.sqsh", "-quiet", "-comp", "xz"
    assert_path_exists testpath/"test.xz.sqsh"
    assert_match "Found a valid SQUASHFS 4:0 superblock on test.xz.sqsh.",
      shell_output("#{bin}/unsquashfs -s test.xz.sqsh")

    # Test unsquashfs can extract files verbatim.
    system bin/"unsquashfs", "-d", "out", "test.xz.sqsh"
    assert_path_exists testpath/"out/test1"
    assert_path_exists testpath/"out/test2"
    assert_path_exists testpath/"out/test3"
    assert shell_output("diff -r in/ out/")
  end
end
