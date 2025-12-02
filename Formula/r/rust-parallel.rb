class RustParallel < Formula
  desc "Run commands in parallel with Rust's Tokio framework"
  homepage "https://github.com/aaronriekenberg/rust-parallel"
  url "https://github.com/aaronriekenberg/rust-parallel/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "b9acd592f6ad4e033452c339b2c8c437bda86235822105fd53c8d7f3070feed9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0dea919d575ec4cc8a61327ab38e1c609855eccaef4b6c87b2d0313ec7830c16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de6d0e7cf51ca3f61ae973d6a51ad3402df21fa6682989ddc7b2da350c3a2098"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfa05d7ca901727019e240197bb3adaaec11c17db1660963abb05ed114fbc793"
    sha256 cellar: :any_skip_relocation, sonoma:        "4beb7981c9acff532587d91245f7ef899c24eef922718a1e56b499b3492b88bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95f8ecb0c43d324f8739933a75d9b0077c0e67c2c19ff4476ae41e0be7bff0c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2713a869e80e9763fbe0d82970dec5c452e2112ae4a9384eb65aee2f6e81e4c1"
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
