class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "7a278319e2df2c3a60b3d6c8c0e3bd428eb4e74fd83f10eba1206edced9004ef"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d68d304510ebb6d6bf34c4bbdf30e986502b9b3a03a91b0dd6d230e125667cfe"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "11d3927e667e7c8ae88b76a97b7ed97071b3a0e74b385eb0a56190967ad07fa6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8d7145965a4bcd5832239c213638380cf8b38c5deb1983c6f0af3d895620d263"
    sha256 cellar: :any,                 arm64_linux:       "12edabc54674d03ca116c90e3b4200944e7228ac3bfea746fbe7e5c568081c5d"
    sha256 cellar: :any,                 x86_64_linux:      "27bdad3a69a27e27e252b5f8c63465adb871cd74462d6b8225185cb524057b77"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args, "--manifest-path", "rust/tombi-cli/Cargo.toml"
  end

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
