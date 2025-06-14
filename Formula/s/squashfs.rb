class Squashfs < Formula
  desc "Compressed read-only file system for Linux"
  homepage "https://github.com/plougher/squashfs-tools"
  license "GPL-2.0-or-later"
  head "https://github.com/plougher/squashfs-tools.git", branch: "master"

  stable do
    url "https://github.com/plougher/squashfs-tools/archive/refs/tags/4.7.tar.gz"
    sha256 "f1605ef720aa0b23939a49ef4491f6e734333ccc4bda4324d330da647e105328"

    # add the missing pthread.h header, upstream pr ref, https://github.com/plougher/squashfs-tools/pull/312
    patch do
      url "https://github.com/plougher/squashfs-tools/commit/8b9288365fa0a0d80d8be82a3a6b42ea1c12629a.patch?full_index=1"
      sha256 "cc3007de92a90c8caefb378b8405cde29c7acf570646d0bbc2bd0dcac1113a24"
    end
  end

  # Tags like `4.4-git.1` are not release versions and the regex omits these
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "17a8eef6f5e4f1651dffacbf86ab7431b1b2141cc6c607f2512f505c7396d048"
    sha256 cellar: :any,                 arm64_sonoma:  "9072950634ac3014a50e01ec2654f20441f493ff701273e4266be1538f4b81f3"
    sha256 cellar: :any,                 arm64_ventura: "879c9257a584c0ef27090c43d5139aba5536b4d5bd517561da8bcc51e8b9531e"
    sha256 cellar: :any,                 sonoma:        "dfd8c515ff9a00d292d016a49f297128c0d9340776cf27083533ea5d2676701b"
    sha256 cellar: :any,                 ventura:       "6ff29851e64d2d375bb08f6a48f2da29690d027109d7fb08a92999392d0a6eee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2de4bd709da9d0906ae7b919084c783abe591fa4234cbed0b7bc6bfb84f1116a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01e6538dea4e6e553d1e6f95ab8f7776fe578abfa56122207ee3a1b4f61a2e8b"
  end

  depends_on "gnu-sed" => :build
  depends_on "help2man" => :build

  depends_on "lz4"
  depends_on "lzo"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "zlib"

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
