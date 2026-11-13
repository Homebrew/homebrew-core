class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "1fdb1688fe1d23f3dd74e7a6c219c66173affa3de7a2e3ffd6cbdaa5a0c09a6c"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b1d4d9a9a3294e90e1df8e0502a74660f4319c933ba5f9bbdadd1fbcf0f5b784"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e343171f4a1ecb62af5390de45b7b930f207ff6e69bc225d2f8b3d4aaea4344b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "07260b28bfb01f825eb650d364b5304ea03be911430720afa112e44a820e5dc5"
    sha256 cellar: :any,                 arm64_linux:       "0eae124d1efee35d99f412abe37f4c03eeda0595d51ae9b48dd28ec663d98ba0"
    sha256 cellar: :any,                 x86_64_linux:      "521b7e82e343948002106eac9b2b10fce737068fb9eee00f5d93021206b7916d"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"rumdl", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rumdl version")

    (testpath/"test-bad.md").write <<~MARKDOWN
      # Header 1
      body
    MARKDOWN
    (testpath/"test-good.md").write <<~MARKDOWN
      # Header 1

      body
    MARKDOWN

    assert_match "Success", shell_output("#{bin}/rumdl check test-good.md")
    assert_match "MD022", shell_output("#{bin}/rumdl check test-bad.md 2>&1", 1)
    assert_match "Fixed", shell_output("#{bin}/rumdl fmt test-bad.md")
    assert_equal (testpath/"test-good.md").read, (testpath/"test-bad.md").read
  end
end
