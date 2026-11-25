class WordcraftCli < Formula
  desc "Headless WordCraft CLI and MCP server to convert, inspect and script documents"
  homepage "https://getartcraft.com/apps/wordcraft"
  url "https://github.com/storytold/wordcraft/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "0803595a9a6cf24f13891558c4b5f83232beb2c230d7a3174379b04fcef520bf"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/wordcraft.git", branch: "main"

  bottle do
    manifest_sha256 "153a82a3a5cf8e7be5148126c37d7fbe0f69e368fefb9654816bd651948a8b9f"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b6819a2006c6f04de445f3d949e76e4fe8a94d990165dbcc0f808612f9edc2bc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e878d574e018f2ca44dae51eed399de3615760ca9d97dbd92516d8415c237f93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "34056cbd759010aff0dc5a5309131d955836518363a1c6cc5cdc5ecf17020be3"
    sha256 cellar: :any,                 arm64_linux:       "2e0ebfc4bfd63ee3c25b8d0e317d41bdc93015e811b2d05e76ea646a95ed0727"
    sha256 cellar: :any,                 x86_64_linux:      "71cfb130ea7212de46af4318d91416e852991bc81a15647c33453619427a8ecf"
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
