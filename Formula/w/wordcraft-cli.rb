class WordcraftCli < Formula
  desc "Headless WordCraft CLI and MCP server to convert, inspect and script documents"
  homepage "https://getartcraft.com/apps/wordcraft"
  url "https://github.com/storytold/wordcraft/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "d35c399acbd438c3c536e31a78f35d3fc7074afcc992e8c7e092fc41fb866aa6"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/wordcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "32dab70e13f915d76b45f1cbf9d8bb4e0dd9db3136bc067c9135607a177a5cfa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "14705eb9d6937c789379072ae4a0878ba2efa9387c38b31d4317f96ff88015d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2c3adf0b3ab6515e9bd290a922523c17f7b31b3eb8ec9ba6db48547178c2819b"
    sha256 cellar: :any,                 arm64_linux:       "b13f6d1964d775e6b1eeab87c205c4c83f0bba8e0b6f5ba98dc48ca9be08b248"
    sha256 cellar: :any,                 x86_64_linux:      "6bf097fe02d211c36fe935e35e6240a3f9d2d038cf85efc888a0612aad33151c"
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
