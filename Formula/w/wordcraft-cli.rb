class WordcraftCli < Formula
  desc "Headless WordCraft CLI and MCP server to convert, inspect and script documents"
  homepage "https://getartcraft.com/apps/wordcraft"
  url "https://github.com/storytold/wordcraft/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "00201455e853ffb34a2a82efdb8a1ce11795ed10339a3f51cfd9dfe468e5227d"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/wordcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "141cf183e1a2d0bf17bd8914809156d9357e4b5fe7b01a33822dcb16f42c96ab"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3585c4b90ffa08fe56ba05165787cc2d7ce31fc5c87b4edcebb541f296f8e52a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cc13ebcb674574de8cdd624766659eb8a3a5f709050f534e4a4b9a8e4400b052"
    sha256 cellar: :any,                 arm64_linux:       "9b383b38580c74e6c7c19541a6077fe0b1f338973fe105f38de1052a19338dad"
    sha256 cellar: :any,                 x86_64_linux:      "d1492223530956ee94dc8f84e015af67a91ad9b25a530f1044d3e18f178f7614"
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
