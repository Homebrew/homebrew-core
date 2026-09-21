class Rammap < Formula
  desc "Extensible and performant aligner and read mapper"
  homepage "https://github.com/jwanglab/rammap"
  url "https://github.com/jwanglab/rammap/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "39b9e74da0b39546d39c992f8e8c91ce9da97a7ac0f0045d541c44e0106eb17b"
  license "MIT"
  head "https://github.com/jwanglab/rammap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7a01caa76af6e0d40977553b4c40c91214c7e121be6b78f10a88a53eafe183d4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9e0f269ccf869bc30e115ebcd37e195d3e453b5c87b80871ea77cc9bca713971"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1a7162807a86f553fae6d85cbcd23bc9765cb5ce8bf60c6269c909ded28b11a1"
    sha256 cellar: :any,                 arm64_linux:       "f4ec690be0d9953cf5cf152f597d5b8add4d41ea4e3756a9fed40fe961cdc194"
    sha256 cellar: :any,                 x86_64_linux:      "07d0137fe3ec3f1b6fb2f076f3555d602e40abf1bfe315cdb6d55d836bf60bc7"
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
