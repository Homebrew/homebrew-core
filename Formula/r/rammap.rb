class Rammap < Formula
  desc "Extensible and performant aligner and read mapper"
  homepage "https://github.com/jwanglab/rammap"
  url "https://github.com/jwanglab/rammap/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "66d96ba52cd4ed6f1365aa3f1b1e736aeccbbcab71b8b590d3b7cc997b1a7fbd"
  license "MIT"
  head "https://github.com/jwanglab/rammap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2fedad69bfb4425e5c0373f617dffeb98562f29fbac5e8f8b49816dbe1f05773"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c581cab3411839cea869625335457898c9e597b57d9d9c454eabc51438511a9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "38b1ce9ff42b9f110c8602eb394c284e30bd8e4b103d781642151c8005974fd0"
    sha256 cellar: :any,                 arm64_linux:       "a3d2969beb53ebe998c400587c1e4cc40821b8ad086554a6ffa529316e2f0526"
    sha256 cellar: :any,                 x86_64_linux:      "8660ed0bf9b4750387fb5a92898d46e65d5ec1fa8e80fb14bff359997ea41285"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "rammap")
  end

  test do
    # Deterministic pseudo-random reference; a repetitive one would not seed.
    seed = 12_345
    reference = Array.new(1200) do
      seed = ((seed * 1_103_515_245) + 12_345) % (2**31)
      "ACGT"[(seed >> 16) % 4]
    end.join
    (testpath/"ref.fa").write ">chr1\n#{reference.scan(/.{1,60}/).join("\n")}\n"

    # A read lifted verbatim out of the reference, so it must align exactly.
    read = reference[300, 200]
    (testpath/"reads.fq").write "@read1\n#{read}\n+\n#{"I" * read.length}\n"

    paf = shell_output("#{bin}/rammap -x map-ont ref.fa reads.fq 2>/dev/null")
    fields = paf.lines.first.chomp.split("\t")
    assert_equal "read1", fields[0]
    assert_equal "+", fields[4]
    assert_equal "chr1", fields[5]
    assert_equal "1200", fields[6]
    assert_equal "60", fields[11]
    assert_operator fields[9].to_i, :>=, 190

    sam = shell_output("#{bin}/rammap -x map-ont -a ref.fa reads.fq 2>/dev/null")
    assert_match "@SQ\tSN:chr1\tLN:1200", sam
    assert_match "200M", sam
    assert_match "NM:i:0", sam
  end
end
