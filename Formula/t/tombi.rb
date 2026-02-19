class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.7.31.tar.gz"
  sha256 "9ff142c8fb4a70d082f7fbe29679de984310b92a1c06e98b37269b2cc6f22dac"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11db14afa3fefc9fa9bae2717779c7a7fd3088cbc4eab405d495d741b0b75c98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29f09e31111e72388bcc19063af888968fedc80688faea3933507164ad10974a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72b1975384258d2ba089b561c65eade40a1ee3abd5461f4d125b48b7053f8cdf"
    sha256 cellar: :any_skip_relocation, sonoma:        "05c24e31200144fd2f4adb86b36f978955a47735a51192700ebb322326310dfd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f577dcdbb02a550f474173ea27dad0f7e5a7f0ae6fa4d877e9f2b6697532fabc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e93b7ed8d256a5839a9f432c07f295f74ea1eac3880a4984bb71579c3f1a26c3"
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
