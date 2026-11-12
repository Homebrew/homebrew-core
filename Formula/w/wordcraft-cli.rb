class WordcraftCli < Formula
  desc "Headless WordCraft CLI and MCP server to convert, inspect and script documents"
  homepage "https://getartcraft.com/apps/wordcraft"
  url "https://github.com/storytold/wordcraft/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "55e6e6ca0e988a7ba320bef506e3910d2e2e5c1d1599a79571e144947438ab92"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/wordcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "67611ff2194577a4ba1bdceac08e43c006ff0a639371cd19f52ac139e5678883"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3bbe80ca953ded7783bd7fcfa0f47147f67263fe965491b4c66494240ecc05c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "12e851b2fe33920b74cd92682852ecb4c44d1983a69d8398bd36a41dbe4ee2b4"
    sha256 cellar: :any,                 arm64_linux:       "8de0d939ed5fa19a728ce52e02dc11cafa67a0bc818354b21fa0ff6ca7f78e64"
    sha256 cellar: :any,                 x86_64_linux:      "0bf68826a24bd53ccd234aaab49fe35c4cd2f2ac466387ecfd2da20305b49a12"
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
