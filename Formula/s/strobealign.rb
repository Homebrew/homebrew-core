class Strobealign < Formula
  desc "Fast short-read aligner using dynamic seed size with strobemers"
  homepage "https://github.com/ksahlin/strobealign"
  url "https://github.com/ksahlin/strobealign/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "651439789346c297b58f7774db6242b475eac9d38e7f16894b5b9eb17296447b"
  license "MIT"
  head "https://github.com/ksahlin/strobealign.git", branch: "main"

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "tests/phix.fasta", "tests/phix.1.fastq", "tests/phix.2.fastq"
  end

  test do
    cp pkgshare.children, testpath

    system bin/"strobealign", "--create-index", "-r", "150", "phix.fasta"
    assert_path_exists testpath/"phix.fasta.r150.sti"

    output = shell_output("#{bin}/strobealign phix.fasta phix.1.fastq phix.2.fastq")
    assert_match "@SQ\tSN:NC_001422.1\tLN:5386", output
    assert_match "SRR1377138.1\t99\tNC_001422.1\t", output
  end
end
