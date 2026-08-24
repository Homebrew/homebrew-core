class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "193f4639385aac8e23eab09113198c024ba47360b5b416be57e03011ed04dcf3"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c6ae43612229ba8e0014010f91d5e8a9fe47f453ce2bd9403c8b4974d05830c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6b8ffed62bb96d6ae6b574d305aa0182283ba90d7e4f88b5910279174460605"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6367d04877de876d904cc62d37b0c875254705dc5010679a6b6c78844a991ff5"
    sha256 cellar: :any_skip_relocation, sonoma:        "0eaa1889dd00eae44ff73fa20e2fc34fdabba03d015c68e07cc2a3c4d5ea07c6"
    sha256 cellar: :any,                 arm64_linux:   "29f0cd36449ae5c921da77b821a5ef1b5aabc13bf90a105447cb2153a2a8644c"
    sha256 cellar: :any,                 x86_64_linux:  "7ca8e567b3eb47c34120d89c183b9e51767d41ff911ceffa3813b2b844173a45"
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
