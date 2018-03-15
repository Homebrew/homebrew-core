class Seqtk < Formula
  desc "Toolkit for processing sequences in FASTA/Q formats"
  homepage "https://github.com/lh3/seqtk"
  url "https://github.com/lh3/seqtk/archive/v1.2.tar.gz"
  sha256 "bd53316645ab10f0aaba59e1e72c28442ee4c9c37fddaacce5e24757eff78d7b"

  bottle do
    cellar :any_skip_relocation
    sha256 "a2fcc7104562aeba2bcbbfd43ca2af2d6adc9825d6823776fad2c2332248a66e" => :high_sierra
    sha256 "e2c95a305e1a1f0624e909739e6c27ac4e4665790101c5d3d7ca1086f37b59c6" => :sierra
    sha256 "8a8ca9859f928227a15443d4203507bbe0fec28ac1c21938d1298c8180d66b35" => :el_capitan
  end

  def install
    system "make"
    bin.install "seqtk"
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCT
      CTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    assert_match "TCTCTG", shell_output("#{bin}/seqtk seq test.fasta")
  end
end
