class Samtools < Formula
  desc "Tools for manipulating next-generation sequencing data"
  homepage "http://www.htslib.org/"
  url "https://github.com/samtools/samtools/releases/download/1.7/samtools-1.7.tar.bz2"
  sha256 "e7b09673176aa32937abd80f95f432809e722f141b5342186dfef6a53df64ca1"

  bottle do
    cellar :any
    sha256 "61268ac6e463a12ea7927701af28293ee54ebe7d5b740702c6a34ce644e37443" => :high_sierra
    sha256 "5a5e616d119a7908b7a1047a1da3de8eaff39ffc3823e5577cf05542b05258e0" => :sierra
    sha256 "3cd5f5a8edb2346f178f27ec79c59044a2a59910eeb8daaa15a584afe26398af" => :el_capitan
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
