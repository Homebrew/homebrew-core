class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.11.4.tar.gz"
  sha256 "db0f24bd62a3b071f3a3ec72ff36216c1d562246b6d4083e388e5e5644d2dd4a"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15c01d45494acfb55fccecd0f742af21b7210f2c58ad4360e938d57ad00ef904"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4525c2674c336569a50b089dccca665b054050bf6643cdf6911a67b41f2bf53f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc23df53f6f133a35f0770606703d5f1ea632a511f41fd713da2d52ecb802f58"
    sha256 cellar: :any_skip_relocation, sonoma:        "99b6eded687313a42952228a8311c92d189f8d530431c7f43fbe831af8a873c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7cd3eb394d01c1a64a673be260206fb4aedbfe4fe08a129b6d5739716fad3b5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54e0e5be4ccf96e0e43c9ae93b6cf74351d57e2367b0133325439a80a8ca4fe5"
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
