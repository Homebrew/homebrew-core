class WordcraftCli < Formula
  desc "Headless WordCraft CLI and MCP server to convert, inspect and script documents"
  homepage "https://getartcraft.com/apps/wordcraft"
  url "https://github.com/storytold/wordcraft/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "2012e3462595d712764fe23d1786136ba2e50907fcac3d08b1a3b2dfdcfd4d9d"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/wordcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5ca4e0280ff849978babd53b9de46297af532fe821716286a89f3fa263f1c887"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0e59fae4a125e5902ca892713499bf810f5819ba76a97658ba1a90d5ba4a9f27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a68c1cd928dfcb11577f01c8f584e13d0b2e3d60e04c0cb9b4fdd1e512c6f0b2"
    sha256 cellar: :any,                 arm64_linux:       "03c02899af09338472741427c1e522b9e22e6509bb5110d9f1c86af87ab9b0e1"
    sha256 cellar: :any,                 x86_64_linux:      "64d56568da75ab4da43feb5a54364f6688199c2f2d6e424c25c1e638e067a253"
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
