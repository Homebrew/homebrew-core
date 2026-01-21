class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.7.21.tar.gz"
  sha256 "f3c8e7cc107f4fd5d921c525611b3001f692d3a5769f3e040501902a0003b8dd"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0cad566835fadbfa5a26bf74760cd2ee7455f546b6feff379084185525e2600"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "420eaa0d74e9677ddad4003f37a9d08dd21bfdab4237783643826dc3cb0d6d7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54f493027d474f6ffe5ba1a2d1cadc1090651eedeca44d58dbe567a17d3e2a56"
    sha256 cellar: :any_skip_relocation, sonoma:        "9987e29c1423d4fce1b21b83da586b9bd053e01262b371867901ae2c4730c43e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e58845cbc3bcf42ac8e0c98c520b48a810fbfea40c57e43026be3ede819eb688"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d002876fd5e9c14f56e224fb4d63d77049399b7390249022f7c00cd2dbb8003c"
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
