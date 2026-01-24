class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.7.24.tar.gz"
  sha256 "5658120da99a341a225fc4d19936095aca4a216f44abeb54ddea04ad2b36b37e"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "846614e5894e444b8f55531ac5a779e38a5f722202395f7db0d941181a7e28a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24da959ffce71af750a1f26ef636834a1899c68f59c3a07cf501fff9ea006707"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e3ea60b11b6930815ccaba0b7b98d50172022366fc04ae7b14aadf8b4f42cfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4809c055cf4c9c22d97cef12b619975beca3faf071a2e53a66df5ff18ac0afb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5e86564d0a139208df335f583ccec44a0587a8883f22d55616f9ca349b4e402"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce2a11c6aa8eaf87261d00351cd5523f9ea293869f383ad5f38f542f7537478e"
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
