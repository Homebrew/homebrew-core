class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "4ca7e4abca24f5fb3fa9c1cd0f9ab6e2e27511c6e272e711dc82e6655fcb06f1"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4bafdb41be9e75e9dad9523b5022b9b7846cfeb3a90c8ab277278f27a7f24c52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c89edf86882cc04cbd63a74c3b121e76e5b1d6c5c9e34d9ec75861e5fe0eaf60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9fdf57b1a83a6613b7938e00962c26d0bd600db8da43a95002a1a34a12cbab3"
    sha256 cellar: :any,                 arm64_linux:   "163a094bc778d4bcc79ee296b9512ace025932eebe6c6cfea9efd2c62f6670ad"
    sha256 cellar: :any,                 x86_64_linux:  "20abfedd1bc20ee40014d0e256e4ac9980ee1bbc4b145d5c073fb816dc90275b"
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
