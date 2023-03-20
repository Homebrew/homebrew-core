class Samtools < Formula
  desc "Tools for manipulating next-generation sequencing data"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/samtools/releases/download/1.17/samtools-1.17.tar.bz2"
  sha256 "3adf390b628219fd6408f14602a4c4aa90e63e18b395dad722ab519438a2a729"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "29e0b8356b5be6d8fa0f0ec746e9a69993532e74fab80d435cde1a4784e039c0"
    sha256 cellar: :any,                 arm64_monterey: "6524696359aa7addc1c6ca9e01c5ae5488fc0aab389e48c7786640ede1063894"
    sha256 cellar: :any,                 arm64_big_sur:  "287a78e9037cb489e57fce991d60ab186360606efa9a720eb44e636fe7433b0b"
    sha256 cellar: :any,                 ventura:        "6d78aa0a7b86707f8711ac8a6114910d9a242325c914e064dee504f727adf89a"
    sha256 cellar: :any,                 monterey:       "6f6679453b493a48e32d987f5bfdc27ff038d9e08acc7bd4c3683885d7e03d06"
    sha256 cellar: :any,                 big_sur:        "eca66a7308c794074802b7910afe486180908f1af436b5680b2284baae07af77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8eeb98f5ffb9f15cebc8c62eb8222bf0ddda2153f73de28253e8c205a0394324"
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
