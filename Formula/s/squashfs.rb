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
    sha256 cellar: :any,                 arm64_tahoe:   "e2cee5166e1e9461ab5cecb429bdb1bc86f0a345b5fb4ae3b55a5dc8b81d1037"
    sha256 cellar: :any,                 arm64_sequoia: "67c4ba832d3d8e03f6160d2d287d11825e13685b0a11a716564fb3f041dabf6d"
    sha256 cellar: :any,                 arm64_sonoma:  "489b9cf9e5228bdd6b8176ff8b43e8cf3a1dd117bdda0d0bc6d64f52d32408ba"
    sha256 cellar: :any,                 sonoma:        "ce60ff8f9345d6cdc7d5f26f4deabdb75d861138f6068d7952334e399161d24f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "315c19c678535e71df91af9f0cef727b7080bd9c75f8e5c86bd28fd8cbece29b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b070dd272ab724f2740ca86f476b2d3d44facdfa331523360b8614ded0772ce"
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
