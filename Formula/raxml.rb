class Raxml < Formula
  desc "Maximum likelihood analysis of large phylogenies"
  homepage "https://sco.h-its.org/exelixis/web/software/raxml/index.html"
  url "https://github.com/stamatak/standard-RAxML/archive/v8.2.11.tar.gz"
  sha256 "08cda74bf61b90eb09c229e39b1121c6d95caf182708e8745bd69d02848574d7"
  revision 1
  head "https://github.com/stamatak/standard-RAxML.git"

  def make_clean(makefile)
    rm Dir["*.o"]
    system "make", "-f", makefile
  end

  def install
    make_clean "Makefile.PTHREADS.gcc"
    make_clean "Makefile.SSE3.PTHREADS.gcc" if Hardware::CPU.sse3?
    make_clean "Makefile.AVX.PTHREADS.gcc" if Hardware::CPU.avx?
    make_clean "Makefile.AVX2.PTHREADS.gcc" if Hardware::CPU.avx2?

    bin.install Dir["raxmlHPC-*"]
  end

  test do
    (testpath/"aln.phy").write <<-EOS.undent
      4 20
      Cow       CACCAATCATAGAAGAACTA
      Carp      TACCCGTTATAGAGGAACTT
      Chicken   CCCCCATCATAGAAGAGCTC
      Human     CCCCTATCATAGAAGAGCTT
    EOS

    system "#{bin}/raxmlHPC-PTHREADS", "-f", "a", "-m", "GTRGAMMA", "-p",
                                       "12345", "-x", "12345", "-N", "100",
                                       "-s", "aln.phy", "-n", "ts", "-T", "2"
    assert_predicate testpath/"RAxML_bipartitions.ts", :exist?,
                     "Failed to create RAxML_bipartitions.ts"
  end
end
