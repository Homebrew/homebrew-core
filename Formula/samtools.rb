class Samtools < Formula
  desc "Tools for manipulating next-generation sequencing data"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/samtools/releases/download/1.8/samtools-1.8.tar.bz2"
  sha256 "c942bc1d9b85fd1b05ea79c5afd2805d489cd36b2c2d8517462682a4d779be16"

  bottle do
    cellar :any
    sha256 "368dbaf769be26a7c383ee6ab33b9368d70d15b144701489fa33a3475ca5301e" => :high_sierra
    sha256 "9be1d5c1a480482885a880c3004906d51b7cb1a89dac25c239513a8b04acfbba" => :sierra
    sha256 "931f8245341783d7d96789c8cc5b3eea6c8071d1ce82644486884cece294e54e" => :el_capitan
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
