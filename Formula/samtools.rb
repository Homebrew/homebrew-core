class Samtools < Formula
  desc "Tools for manipulating next-generation sequencing data"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/samtools/releases/download/1.12/samtools-1.12.tar.bz2"
  sha256 "6da3770563b1c545ca8bdf78cf535e6d1753d6383983c7929245d5dba2902dcb"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "90bb0238ac2b339a77305494d4be5413a446cc3f74276215834b4464c5c1e13f"
    sha256 cellar: :any, big_sur:       "91e903cb284e1ea536117a1c583ab66d40691251dc23fe2904c43548b0759c9b"
    sha256 cellar: :any, catalina:      "1ba9234ba9de00494f56515347be7027161fddd0ae7f44e88db9809cfa9440a2"
    sha256 cellar: :any, mojave:        "441bf778fce091ac24cfca18b967b1693e54bea5cd44e217f7427597c8a38271"
  end

  depends_on "htslib"

  uses_from_macos "ncurses"

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
