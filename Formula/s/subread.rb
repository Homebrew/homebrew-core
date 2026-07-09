class Subread < Formula
  desc "High-performance read alignment, quantification and mutation discovery"
  homepage "https://subread.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/subread/subread-2.1.1/subread-2.1.1-source.tar.gz"
  sha256 "6392d7c66831cdd767e58251892a79a51b6fab8ed0ba9671ad5e85ff1ab01eaa"
  license "GPL-3.0-or-later"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    cd "src" do
      if OS.mac?
        # The bundled Makefile hardcodes x86 SIMD flags that clang rejects on arm64.
        inreplace "Makefile.MacOS", " -mmmx -msse -msse2 -msse3", "" if Hardware::CPU.arm?
        system "make", "-f", "Makefile.MacOS"
      else
        inreplace "Makefile.Linux", "-mtune=core2", "" if Hardware::CPU.arm?
        system "make", "-f", "Makefile.Linux"
      end
    end
    bin.install Dir["bin/sub*"]
    bin.install "bin/exactSNP", "bin/featureCounts"
    bin.install Dir["bin/utilities/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/featureCounts -v 2>&1")

    (testpath/"genes.saf").write "GeneID\tChr\tStart\tEnd\tStrand\ng1\tchr1\t1\t100\t+\n"
    (testpath/"reads.sam").write <<~SAM
      @HD\tVN:1.0\tSO:unsorted
      @SQ\tSN:chr1\tLN:1000
      r1\t0\tchr1\t10\t40\t50M\t*\t0\t0\t#{"A" * 50}\t#{"I" * 50}
    SAM
    system bin/"featureCounts", "-F", "SAF", "-a", "genes.saf", "-o", "counts.txt", "reads.sam"
    # The single read overlaps gene g1, so its assigned-read count is 1.
    assert_match(/^g1\t.*\t1$/, (testpath/"counts.txt").read)
  end
end
