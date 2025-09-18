class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.10.tar.gz"
  sha256 "7ac110a7a0e94804bfe250826839b2290b863546d6146e22ffc9cf83de080373"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c068453731d9a70bd37fa879f9b189bca37b3a84587865ae8ea2eb95686fe54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "817b36e526db546de7f91b72f4a64659c60dd4c4b1eb06bc30fb1271df824e61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d28555714281eb25ea282d4db41cd8a2f4cbedab6998d4cdaa06fdc294edda93"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff6f33a4dd0a753a6ea889a72080778cbfb0fdbc9b4920feecdf94b02aaf1627"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abfde34420e5243942e294127384cddff610c8ad92e28ce160343cf328e46fd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c3a2965125adb7e35873b45174ed9dfc1aff8a5a4ccad8f86ac801da499d229"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/tombi-cli")
  end

  test do
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
