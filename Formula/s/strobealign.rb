class Strobealign < Formula
  desc "Fast short-read aligner using dynamic seed size with strobemers"
  homepage "https://github.com/ksahlin/strobealign"
  url "https://github.com/ksahlin/strobealign/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "651439789346c297b58f7774db6242b475eac9d38e7f16894b5b9eb17296447b"
  license "MIT"
  head "https://github.com/ksahlin/strobealign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a4f415254e1472484b6e6070657e7f88349c39a6c17611a6ac10542b87772c12"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5cb2dce176d5d2988f635fd900ae9f2f787344c649b38dfe52ba3ad825ec6b46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9eda3dec5153a68631b3609f56d513aeda0cb11bf48b2d60916590f20c1abf2f"
    sha256 cellar: :any,                 arm64_linux:       "c41ff50b2dfe289942fb2d73f1d1dd6e8bbaf6fbab5a3cd033c62b3dec437bda"
    sha256 cellar: :any,                 x86_64_linux:      "a996e8c408cce86a63009cb168281dd3fb2330d51bfd464136b81c40c411c0b1"
  end

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
