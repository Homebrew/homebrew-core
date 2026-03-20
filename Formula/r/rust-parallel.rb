class RustParallel < Formula
  desc "Run commands in parallel with Rust's Tokio framework"
  homepage "https://github.com/aaronriekenberg/rust-parallel"
  url "https://github.com/aaronriekenberg/rust-parallel/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "7b9b1f5e9a61e0617a92f4e1210cf67a1a928869942c2d86b41cbc1f26a660b1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0c2d7a401196e8756721d45e5f533df56543b464a0950b67b4188cf6f85c539"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09475d11933fcd43407db874eb84e05feae9ebed551b4cab3e800a0a79d68849"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecc58c88531ab1b9f7494bddeaa93ab90b51333ce512de2b01e7d4a75153b791"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3a9da5cd40b4455bef6b101cdcc7e8ced8ab13a1e8bf79ec70e68948f8e3998"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dff2a4e4f014263649ee745bc91f1f102d0fcd4ed4ebe950f5d2ec6538f160aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4c01defb874e635f9a50400e3ae2539673d02834020b7db9a6e2b104dad852b"
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
