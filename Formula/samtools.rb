class Samtools < Formula
  desc "Tools for manipulating next-generation sequencing data"
  homepage "http://www.htslib.org/"
  url "https://github.com/samtools/samtools/releases/download/1.6/samtools-1.6.tar.bz2"
  sha256 "ee5cd2c8d158a5969a6db59195ff90923c662000816cc0c41a190b2964dbe49e"

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
