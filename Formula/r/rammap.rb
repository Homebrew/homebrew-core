class Rammap < Formula
  desc "Extensible and performant aligner and read mapper"
  homepage "https://github.com/jwanglab/rammap"
  url "https://github.com/jwanglab/rammap/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "d6d349495da8fb26e50ce6408235a587a297f666063f01ca8ebf05439b47d33c"
  license "MIT"
  head "https://github.com/jwanglab/rammap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c230660b760455357ef639a9d5ed521cafca8f0d427b916b8c0420ab9f1a49c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93df8805e393847485dedc6de1f8a0c0aa9bce162c486723e6dee92bb75e84e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c004cc6781f948985fdda36982f013f9f9a7eb627c9151d08eb26715a6389482"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1453cd0dbb877a0756061e58e84d6a07be60fd3ded457efb6e7ad33c9235287"
    sha256 cellar: :any,                 arm64_linux:   "ca1ad43da63c59688c85dc0dface39ae63a40eec96a58c88cbb6c6ee997d1de6"
    sha256 cellar: :any,                 x86_64_linux:  "2f08907e5d89e9a4b604d567606738528222893b05b51b6ff5a1bc58f03542a9"
  end

  depends_on "rust" => :build

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
