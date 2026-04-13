class Squashfs < Formula
  desc "Compressed read-only file system for Linux"
  homepage "https://github.com/plougher/squashfs-tools"
  url "https://github.com/plougher/squashfs-tools/archive/refs/tags/4.7.5.tar.gz"
  sha256 "547b7b7f4d2e44bf91b6fc554664850c69563701deab9fd9cd7e21f694c88ea6"
  license "GPL-2.0-or-later"
  compatibility_version 1
  head "https://github.com/plougher/squashfs-tools.git", branch: "master"

  # Tags like `4.4-git.1` are not release versions and the regex omits these
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4457ab0b11eff5278270c2bcf8de450879d4e8d9d3b6b3c2aac3d3aef822e5db"
    sha256 cellar: :any,                 arm64_sequoia: "279c65c00b406c9bff6a6db0ea2d2912502cabae119acb12f1ca1d0702645e28"
    sha256 cellar: :any,                 arm64_sonoma:  "67388efdf366eb667070a2a3c89259f0bd94ddc358b89fa3da9db3b54d5acbe3"
    sha256 cellar: :any,                 sonoma:        "d0946ffe57592ee0837e4f9930c6af5fa5944054e1cc7ad19b4375c03a7537f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72d51e9a40472471e870fbf47e31f77bdb2dcd58848a0575c6f46e4824045226"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "931a2bcc184485cc0b1d449de2a3e8bfbb128c655194648915d9638469f1f16c"
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

  # Fix Darwin `struct stat` field selection (`st_atimespec` vs `st_atim`).
  # Upstream PR ref: https://github.com/plougher/squashfs-tools/pull/356
  patch do
    url "https://github.com/plougher/squashfs-tools/commit/f88f4a659d6ab432a57e90fe2f6191149c6b343f.patch?full_index=1"
    sha256 "3f3f568514c57fd50f508fef67e0e293a9668067801f42d4471b429a79bd1575"
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
