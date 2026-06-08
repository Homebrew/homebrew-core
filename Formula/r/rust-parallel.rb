class RustParallel < Formula
  desc "Run commands in parallel with Rust's Tokio framework"
  homepage "https://github.com/aaronriekenberg/rust-parallel"
  url "https://github.com/aaronriekenberg/rust-parallel/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "cc46ed110c3150d797ffbb3aa50209b93390beaef44f3b7c8fbd4adca46724ff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "465dbbc9008598094a1369048b09b67cf86a3261f3cd2cb17e5cd451687b023f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb83a9b4281d7988b17a34ad74d2d854ed36442e06c4f211b1336a7b5060c365"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab4f7a740ede946626f962a501ecf9ff40e4b0bb020e03e765520a79cc5834c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "20ed463f327f83aca5eb4932eaf75b257921ac860d3ee5d9bcc1d606245da308"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be8a523ad79ccf15adc622ff13b46352e9ad5462ad80911e1b275d606e2a2ad8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0366106a5adefbb4d0f04b9b928cf01f0e93239391d174e788396ef3e564aeb6"
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
