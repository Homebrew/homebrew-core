class RustParallel < Formula
  desc "Run commands in parallel with Rust's Tokio framework"
  homepage "https://github.com/aaronriekenberg/rust-parallel"
  url "https://github.com/aaronriekenberg/rust-parallel/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "81f932a61b0b0f1092064abe5c009e127e41db03ccd30f5f8a7bb560cc613f74"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b684350fccdb692f878dde5f410096c216f75dc033d597cf1ff3360c209e764"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8a775c541e5372f1156ac8eb18ff868bd055aa373bb02b5dba462412bb5cdb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eff64d362e6f0d25846ce0fb9dd162c9b8dca820c85912befd4a7fc68a8d5358"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1207ff552b2d0af03ba0bda91cdd23f887503911b438a6a39cc830676cd4ef0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "387eb5be2ec26d07ae997a2ba6ed1cd978b5778b9c2f93f7487ee7c0cc279c20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d408fd9a56f1830181231658449305374186aebbf1340a2dc2fee64c69ae7a60"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    testdata = testpath/"seq"
    testdata.write(1.upto(3).to_a.join("\n"))
    testcmd = "rust-parallel -i #{testdata} echo"
    testset = Array.new(10) { pipe_output(testcmd) }
    refute_equal testset.size, testset.uniq.size
  end
end
