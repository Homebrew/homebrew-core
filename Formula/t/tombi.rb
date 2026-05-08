class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "01dd7723b9705a86883cff0b8328116ee254d33130aae5552e01715dc86366af"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af23236edb168c940c5f0f78679ac42bc4b6180885e52cb3f3417ee509231da0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9821120935ee5346b8b8d07c56052bd703dc803cebe59747ef00d9392a5aaa66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ee1c7f48ab469cb17ee0575c7184f55e8fa5f0d0ba263c2c06b31f851122362"
    sha256 cellar: :any_skip_relocation, sonoma:        "335bf38d8b792894fdcf2ab223acb247fc8cdc15ef840c29bf3a704b16ba09a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "097a065ef1de89eccef3a45f13510543b324bb06d1ee29e0b269c0a085108220"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f6a425f336a4627703e514d8684f8c3bd39cd8e0e828906fbdb31ff5e9e4208"
  end

  depends_on "rust" => :build

  def install
    ENV["TOMBI_VERSION"] = version.to_s
    system "cargo", "xtask", "set-version"
    system "cargo", "install", *std_cargo_args(path: "rust/tombi-cli")

    generate_completions_from_executable(bin/"tombi", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tombi --version")

    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    Open3.popen3(bin/"tombi", "lsp") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 1
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
