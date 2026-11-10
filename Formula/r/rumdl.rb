class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "ee83677c6fdc4b52c919dd1e0c614d9c37211e785f270f978c75644272fae244"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5574d2eb59429278adaf9f222c55889722d6e663448a600e1ad4a86c13aee2c2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "67f73ccec6fef5a71f086857ac2858dbb04b112799c67add584140265f9fffe7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "12938647c37b513980afb6205ebe7ac895c728e01e2a54637acf5b2046e15d7e"
    sha256 cellar: :any,                 arm64_linux:       "d5b625beb03d475390c02f80f6386bae725b2aa87e73a16d14323254e2a645d1"
    sha256 cellar: :any,                 x86_64_linux:      "9d761912ec0e914175ca495c522445b90d166c04f59f25bd828b1f3ac53917df"
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
