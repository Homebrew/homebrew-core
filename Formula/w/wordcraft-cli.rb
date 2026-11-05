class WordcraftCli < Formula
  desc "Headless WordCraft CLI and MCP server to convert, inspect and script documents"
  homepage "https://getartcraft.com/apps/wordcraft"
  url "https://github.com/storytold/wordcraft/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "931c7742bd46e52cbfd033158ecd51345a39dbfa8e5e3de37609428be7d9c982"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/wordcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "12287f94ca66a0f9c69fd69a2b5423cce28b30ba493c34fbfc6d1aacc927afcc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6f6aa7faeb8dea6004bc221641b75ede613d03a6e0b66c1eedaf659a8faa3810"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fc6a3eb7aff301827bdf6c233fcfb75e1f867fb4bef5e924f7d1694173d6395a"
    sha256 cellar: :any,                 arm64_linux:       "29b4d7cd62239a8eed7cbcfb98efd2b6b6102d815439047c095325522f22e671"
    sha256 cellar: :any,                 x86_64_linux:      "1b2cf57fbd2d6463481bce4ef293daaf301034502daf8b48dd54c2c243e47228"
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
