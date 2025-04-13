class Squashfs < Formula
  desc "Compressed read-only file system for Linux"
  homepage "https://github.com/plougher/squashfs-tools"
  url "https://github.com/plougher/squashfs-tools/archive/refs/tags/4.6.1.tar.gz"
  sha256 "94201754b36121a9f022a190c75f718441df15402df32c2b520ca331a107511c"
  license "GPL-2.0-or-later"
  head "https://github.com/plougher/squashfs-tools.git", branch: "master"

  # Tags like `4.4-git.1` are not release versions and the regex omits these
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "e18983058459bb34a878aa55400fdb33fffe5dd01d7ed52601f8228cb1e3d8f2"
    sha256 cellar: :any,                 arm64_sonoma:   "21f37d4cd4db720d9c1f15ce0cad88397a816b7801f30d715cf2f28fc91df08d"
    sha256 cellar: :any,                 arm64_ventura:  "2d8bf130f1b58fa03252b6cccbab2f0d4ffa600b33996a40e61d91d73f7fd55f"
    sha256 cellar: :any,                 arm64_monterey: "6cef6a569617ae5135c3eb170ee09f7fea7736da13b953f2efb44d024e947a4e"
    sha256 cellar: :any,                 arm64_big_sur:  "fd3ad11d7192e0faad3906f5556aca470d2b8404ce07f6cded1514af2c286689"
    sha256 cellar: :any,                 sonoma:         "7c2ba3c8a22abeba1f4f2e5d4118d62b169124cd61f0c3fbdeecd16ccd158927"
    sha256 cellar: :any,                 ventura:        "f77526a0a06e07ffba3e86a57c09391f3e962f221543ba424276beea2de6be29"
    sha256 cellar: :any,                 monterey:       "0f4721b581fa57db435d884bc4af98ce7c58e3ba92262e2277676b1e44e4cb1f"
    sha256 cellar: :any,                 big_sur:        "821ae58379b5a2465979686d50f3f54d26b7707e5aaa8180eea6d6da5559b07d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d2f6ea709f9ab4cdc4ebd038804296a1bb0b040c0d5bfbbe5a84e744f1a02372"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48347e06cf3d3bd099d441f38de0d32296340334bebefa048550d8b8afcb426d"
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
      USAGE-#{version.major_minor}
      USAGE-MKSQUASHFS-#{version.major_minor}
      USAGE-SQFSCAT-#{version.major_minor}
      USAGE-SQFSTAR-#{version.major_minor}
      USAGE-UNSQUASHFS-#{version.major_minor}
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
