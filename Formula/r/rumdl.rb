class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.3.7.tar.gz"
  sha256 "919996ab0fcdb16cfb23dc9219be185ca6caa2c93857029ff25cee2c1f89cefa"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "7df192b2b5290094805a5c599120884a8dfb1308257567ae3f695874e8598968"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6d35ef041b84d8c479e38099265cd5858b5999ff041f11b3486b3e908f0731ee"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c5e5ff2b2aaaa58c4eaf2fc1c098008623a47f51d7121f7142a624da2258a05f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6a19c7a2b18b0ec1769e050295b14e4081f1d46d3ee6871d8291c2da06c43016"
    sha256 cellar: :any,                 arm64_linux:       "fc866d126050548c8e7a6a4033e311ed9730b19b09d68a353ba45bb5ff7ad24a"
    sha256 cellar: :any,                 x86_64_linux:      "b3f23443144d77839d60ce54b4652d61f9a0f210bf7c820d8356fccd35ac3bf6"
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
