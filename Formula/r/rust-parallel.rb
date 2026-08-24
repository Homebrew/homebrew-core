class RustParallel < Formula
  desc "Run commands in parallel with Rust's Tokio framework"
  homepage "https://github.com/aaronriekenberg/rust-parallel"
  url "https://github.com/aaronriekenberg/rust-parallel/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "9efb8f574ebbe82fad1b89cd94362f75c3b46e7bdf29fc5c640cb9dd10ce2852"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4698fe34a0108b36436af0568f2e5a8b47151c8c78da04693d84c02e66394b86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97023de4183bdf157ce3713fa6e9d5bdd52aef1a932d1871b81699badd636df7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a611ca1c52ca98fe2f02826b5b13c8af13d3fab0571a2e9de643246f7548d441"
    sha256 cellar: :any_skip_relocation, sonoma:        "88b62226152306c8a04c8895b72820150e42cf7e3aa374e2aa7525a2a8eb886b"
    sha256 cellar: :any,                 arm64_linux:   "e3b05ae08f756c4a76eea32db46424201ec6b0e697c37d1c9d6419843194bd37"
    sha256 cellar: :any,                 x86_64_linux:  "6831a7aa897be1a15493de30b6c18f1ce217a90ebf131035a980a0cd8272ca13"
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
