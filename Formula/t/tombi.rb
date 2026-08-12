class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "c4187ed6982b5a83449f101ce29e4ec57879b908ad47102e977dd88e1006b69a"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a040a7d0b3e9c56a0f30921645f3d511bdc378ba14aedbef6546e6da535e7583"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b20b805f78d75fa26b49f0b9d589dc5ff6e1d9c63a27f446d1b6b0e8b19c6e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f8f12450fd99aa072433d802909b17c98f8332270cef8a32feb3ad9b50434c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "5eb38e7c260da0c485d0e1dbb9b7493ee64de99c6152236795378ada93d1eb53"
    sha256 cellar: :any,                 arm64_linux:   "bee90b9794e38fb7883f8006808f8a13edd69707c37a70e2324bf1ff40916c06"
    sha256 cellar: :any,                 x86_64_linux:  "8f9b82bd2be7d7ac2259810d87108c8da2ed7a0891ca572396cef45fb7991bd4"
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
