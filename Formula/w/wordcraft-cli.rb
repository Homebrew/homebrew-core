class WordcraftCli < Formula
  desc "Headless WordCraft CLI and MCP server to convert, inspect and script documents"
  homepage "https://getartcraft.com/apps/wordcraft"
  url "https://github.com/storytold/wordcraft/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "0f2ef27987a129bcd78e600131f16443491e7a38bf8aabf09a48d35c8298567f"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/wordcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c933d10a2048b37bd54e41f6c270bad155642489ab7bfc5c60802502a5bb1cc0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d972e9f8b61f3dcc117bd6b804d759a3c0ce087b7e330d7e6d36036d1599ec82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1e76e7fba0834594a75628810ca5122b6bda1f3cfdb9cf2a621e4c19300d0ccc"
    sha256 cellar: :any,                 arm64_linux:       "1edbe65fd96875f437aa7605fa25feba38b5d91e19b080fcca6eadc432ed2a6a"
    sha256 cellar: :any,                 x86_64_linux:      "d45812ac44333df9632410b06c4fa28d3f5f64763e5894a7d71d5ccdd1315922"
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
