class Samtools < Formula
  desc "Tools for manipulating next-generation sequencing data"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2"
  sha256 "083f688d7070082411c72c27372104ed472ed7a620591d06f928e653ebc23482"

  bottle do
    cellar :any
    sha256 "4683ff94610e9bb6e58a26c0d71410fe3570e5225410acda302dbfe00ea7e274" => :high_sierra
    sha256 "46d52a403e444fae04968e36331ca11b922289603d0a0c6a133f1544c17e13b3" => :sierra
    sha256 "50730568acf901ed0635ce71503aa225eb17e87b07b8f55ddb60ff2b43cae54e" => :el_capitan
  end

  depends_on "htslib"

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
