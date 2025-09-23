class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.12.tar.gz"
  sha256 "392da8ef2ce5b2322066dabc96434a08cf409a74f778f642f79fcd9520c814e5"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c34dde5e587b0cba4b8b08e13fe53a06d6c7831c00340de0172bf042b9cdb685"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bbe03f3f0e5fdbf93e51c8abe7b0953706d2296fd47f1d1d8694050f174966c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17f5805ab72b0a7b3472ab0106b188252bc189f36b34d917ca2f835efa1c4ee3"
    sha256 cellar: :any_skip_relocation, sonoma:        "057468cb371839c20b7c4a23a89f5f48a9230063d6a2e35c1c6213fb905ee3c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d633d05e0d207f4e54b39922bff377256ee3cec10780b08f05405a0450832ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb58db1eb1b174cf243f162f06e9796ef1e46718b62c69ca748f90f13f443c54"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/tombi-cli")

    generate_completions_from_executable(bin/"tombi", "completion", shells: [:bash, :zsh, :fish, :pwsh])
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
