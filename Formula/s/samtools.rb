class Samtools < Formula
  desc "Tools for manipulating next-generation sequencing data"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/samtools/releases/download/1.23.1/samtools-1.23.1.tar.bz2"
  sha256 "32266198a4bc6a6df395d8526688c9697d9c8e472f888c749fdde2e08ea88dd2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f90e6a1ab4dfb450306fc386b77aff90777e89d4fe918135209fd95d9c0d81e5"
    sha256 cellar: :any,                 arm64_sequoia: "1917a110f8464fc967a692f375c939250d730f1776cdb614b2d9333300f1a2a3"
    sha256 cellar: :any,                 arm64_sonoma:  "49f2737b5def65598ca2fa8811463a64a32c7aea8484969f5a24e0f9ce198248"
    sha256 cellar: :any,                 sonoma:        "64e86c434b6878b264e05310ef29cd6dee574156b5b51fb638caf372a48a37ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e32b90bbb900986a7b082eba4bdf35495a65c1330c927d439c3bbcc9186ce3bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2d8d142e02362f0009664adac7f9e5d896311a6d1bb658b8e98782181663e94"
  end

  depends_on "htslib"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-htslib=#{Formula["htslib"].opt_prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    system bin/"samtools", "faidx", "test.fasta"
    assert_equal "U00096.2:1-70\t70\t15\t70\t71\n", (testpath/"test.fasta.fai").read
  end
end
