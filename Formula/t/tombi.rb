class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.7.22.tar.gz"
  sha256 "edf880f2b986733395f726f6785a594c15a0916403e69164c17df0e1ba25564f"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7bf97d920332b0119169a0c863ca62ecf4f31cb102107d05a870682047258c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0aa4e9cdc3b7309f12d9e176ec0f704e068eafabc3af72196f2a49bc37ac087"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "443ae1f05ac906b31c7957c2eded2fbbf5c82e9a034110c3bc87e6b65e52f547"
    sha256 cellar: :any_skip_relocation, sonoma:        "8440a7323a65d9ae19bed00d533b376bf7e6e124dfe7b39e2ebab1070d0427f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "266a0563b131248e0246f8c58e6936cd2147aab8fdae100d5ad5e372814630c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49e1981bae8b25dd9f5c9bb49fd8befc11cad13bbda2e8e74f1c28c8c120a46f"
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
