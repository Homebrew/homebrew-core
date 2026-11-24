class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "f71a52b2febe75f36ad7193a6bb1e5b3be85ee834a14c5992dc62dd11b8ea559"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "b038f404d8193cb1668b88fa806cb2a13b772339243907624f7f4cd3f87e9d49"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "caf1f28f33ed61728e53aae05a1305cd171ec25577e0b1d9919d73a358bffdf8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "57a922ffb7d62080fb1ac1c2cbfbecc989fb43d1ef176e526ca12a07588d07c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2498d805c3bb88578294662b85b990c16a811e5c0956201c17a81d799804e00b"
    sha256 cellar: :any,                 arm64_linux:       "c7c007752f26f12b112cc945e268de629f161cffcff6622c15ef79ef7ae4a8e3"
    sha256 cellar: :any,                 x86_64_linux:      "eb1b8f5f3a442f3c6d9f0a8f993dcd6fc638806782268acef43e1e458a4483e3"
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
