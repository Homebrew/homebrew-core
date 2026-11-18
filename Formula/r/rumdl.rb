class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "b7d09be500f8ec529c24aa37147485944bfdb23dafda3a31eb2a76210040b6cd"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4cc3fa3e8bd851d61d0b9164a4fdf92c8810979c1257ea4ce746103863cab452"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f5aca9e158ac69e84451efb9c2711db7f208d1cb311e22a4c9e4fec5c426f099"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8583f149a6bf1181e4362a3e75e9e39ee421e963fb5e21218ccecbe9bf0c3b5f"
    sha256 cellar: :any,                 arm64_linux:       "65bdf98217ca89dd4bd0671e5587e9c4cdd28f18072bfcbeef3b7b66e3ce22a0"
    sha256 cellar: :any,                 x86_64_linux:      "fa4304b3081e840b776faf4680b2c524bb194e5159af152af757372c447d6fb5"
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
