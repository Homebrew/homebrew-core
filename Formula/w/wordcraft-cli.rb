class WordcraftCli < Formula
  desc "Headless WordCraft CLI and MCP server to convert, inspect and script documents"
  homepage "https://getartcraft.com/apps/wordcraft"
  url "https://github.com/storytold/wordcraft/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "164414206491bbd011e58e039e9e17b9c055875d66307792ad5778b930f6a328"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/wordcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f28d1e6269e7fe19f6f2b8bb0417eebd05ae2ffde44838492eb6079487cb7ec6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "be7176b3777ed4341e00e19eb247242350abe3465093025c037af58ccf77c87b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "253564de9983f1af4caae8724d471a44f508b5c78a3b922aa3b16197c3a3e9b3"
    sha256 cellar: :any,                 arm64_linux:       "2c0948ac3272ff513644fb268220a486e38563e12894d6248247ad05231c388a"
    sha256 cellar: :any,                 x86_64_linux:      "510cdf41e80bcc598a19ba642907e8f9427cb1cca75bf517a4ae55bc5b443573"
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
