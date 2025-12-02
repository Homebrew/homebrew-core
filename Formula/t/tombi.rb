class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "929065d6b56869ae506673ff04b7edb217b7e6e844bec6fdb454a8f96181b63d"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5223bb3bdf3d85e852dee1b7c3e859692834f246931e3d4837cf2e4da987667"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "326e19c688d1c372fb300173115fe5197d90d0aa4068a50ce287ddfd8177de66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa7aea78cb9832d240d32ee818aaf33ca9dbd4f554ff32354468ea1cd2fc41c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb11338698648ad6d3db835d94c80d2d803416552152f2fb21f74e63a1edd4fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e95ba50522f8048da9d7e37e376944f2c14668ec256b4226f07a38bb9c811ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ff137241b0261184a25ea8a94f4b641e4892fad36913a4160536b1c3d2de298"
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
