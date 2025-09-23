class Squashfs < Formula
  desc "Compressed read-only file system for Linux"
  homepage "https://github.com/plougher/squashfs-tools"
  url "https://github.com/plougher/squashfs-tools/archive/refs/tags/4.7.2.tar.gz"
  sha256 "4672b5c47d9418d3a5ae5b243defc6d9eae8275b9771022247c6a6082c815914"
  license "GPL-2.0-or-later"
  head "https://github.com/plougher/squashfs-tools.git", branch: "master"

  # Tags like `4.4-git.1` are not release versions and the regex omits these
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5b084216ccb224844823d4f8547052f62e3e03a8550dc07509a84e98f7a4e406"
    sha256 cellar: :any,                 arm64_sequoia: "e14ece392f8839650c3c27cfdc8b225d63f6fa84eef0783dc9a4c59ba06f7cc6"
    sha256 cellar: :any,                 arm64_sonoma:  "dc48cced5cf0810b4fdc220a6b967296057dd02365453d2e2eface15938e962d"
    sha256 cellar: :any,                 arm64_ventura: "77773e74b3052034873568c8c9e14541eac01fe4a5a3815919561a8cae72ed24"
    sha256 cellar: :any,                 sonoma:        "a40660ed6e73724773716f7e823daa9feaf10f453a0ed4e4829bc6ae9519b173"
    sha256 cellar: :any,                 ventura:       "33a23dafbf737cb4c48eb987ec92af8a029a2547c45a1b78f4e588a6ef9d61d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c06087b02d6708073d7a5cfa6de460c4bc31d0f6355cb178d92d7702cf8077f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a268a6b8f83b8f16ddfdffae4c9e30cfaf827ad4d36e84aaaf6311bedc37f914"
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
