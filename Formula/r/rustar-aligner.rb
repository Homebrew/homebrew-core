class RustarAligner < Formula
  desc "Rust reimplementation of the STAR RNA-seq aligner"
  homepage "https://scverse.org/rustar-aligner/"
  url "https://github.com/scverse/rustar-aligner/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "36bc9b578bfec649b0339642a8eb0cce6bbdf1d8f6ab7a63e7848b0e4ad8e443"
  license "MIT"
  head "https://github.com/scverse/rustar-aligner.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"genome.fa").write <<~FASTA
      >chr1
      GATTACAGATTACAGGCCTAGCTAGCTAGGCATCGATCGTAGCTAGCATCGATCGATCGA
      TCGATCGATCGATTTACGCATCGATCGGCTAGCTAGCATCGCATCGATCGATTACGCATC
      GATCGATCGATCGCATCGATCGGATCGATTACAGGCCTAGCTAGCTAGGCATCGATCGTA
    FASTA

    system bin/"rustar-aligner", "--runMode", "genomeGenerate",
           "--genomeDir", testpath/"index",
           "--genomeFastaFiles", testpath/"genome.fa",
           "--genomeSAindexNbases", "6"
    assert_path_exists testpath/"index/SA"

    (testpath/"reads.fq").write <<~FASTQ
      @read1
      TCGATCGATCGATTTACGCATCGATCGGCTAGCTAGCATCGCATCGATCGATTACGCATC
      +
      IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
    FASTQ

    system bin/"rustar-aligner", "--genomeDir", testpath/"index",
           "--readFilesIn", testpath/"reads.fq",
           "--outSAMtype", "SAM"
    assert_match "read1", (testpath/"Aligned.out.sam").read
  end
end
