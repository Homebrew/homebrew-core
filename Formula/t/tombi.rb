class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.9.17.tar.gz"
  sha256 "975ca54ffd40cc2fe1d3b262009732aa9f5c377f956cec9bee27173bddc8c204"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07a15e14e349450e7e10d27e0453d618673aeb79d853b18444ba91f90bd652fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72c7314ab6b970639d0ffcebf933c440b18ae6f0d1dee6f0b349ac96901184be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8d53261faa26900bb738c0b212edb0f7b0f7f360fcb86114aa9be2630fab2be"
    sha256 cellar: :any_skip_relocation, sonoma:        "65c801fd87ccc8384c8f9c13f5f6b83a897f8a34ec39a1431f6811b12a218c12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39518bbc29c68508e076b487d7f26bb3f6e2179d15afc60f9e8364549f7df764"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a990c746613adceba9a8795e42ef31cb2646b74abb09eeeea382bfcad321b15a"
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
