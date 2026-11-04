class WordcraftCli < Formula
  desc "Headless WordCraft CLI and MCP server to convert, inspect and script documents"
  homepage "https://getartcraft.com/apps/wordcraft"
  url "https://github.com/storytold/wordcraft/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "ff57541e7a6b71b8ab87b52a0736e71c783c003f7fb2470ccf9352161632f46d"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/wordcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "201362910509d936af13d814b4974d313e409e399763105c2e0cbe5728206eee"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eb34d4edb9e80a3d7f55a5864d35059f69c926454d3ff8d2e92206778737f993"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "49448cc7f9fa4a23d29a27c712501feb6670ad2da4bf41ab3506582b0cce4a6b"
    sha256 cellar: :any,                 arm64_linux:       "3851498f0c41ebfc2aab211a442081dc34634a26e310c81f80f5a5aa84284522"
    sha256 cellar: :any,                 x86_64_linux:      "c44ea8b721ffd18c62e2a2eea2101637a668283e7e1d5f7d5d397551028de44f"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/wordcraft-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wordcraft-cli --version")

    system bin/"wordcraft-cli", "run", "--cmd", 'text.insert={"text":"Hello Homebrew"}',
           "--cmd", 'select.text={"text":"Homebrew"}', "--cmd", "format.bold", "--save", "test.docx"
    block = JSON.parse(shell_output("#{bin}/wordcraft-cli inspect test.docx"))["blocks"].first
    assert_equal "Hello Homebrew", block["text"]
    bold = block["runs"].first
    assert_equal [6, 14], [bold["start"], bold["end"]]
    assert bold.dig("props", "bold")

    system bin/"wordcraft-cli", "convert", "test.docx", "test.pdf"
    assert_equal "%PDF", (testpath/"test.pdf").binread(4)
  end
end
