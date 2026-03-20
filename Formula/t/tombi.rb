class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.9.7.tar.gz"
  sha256 "573832408c0298e128126870e07576ee00eac04c29610759a89c8c103edb0162"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d26ae28cb0f453ef27a3f99eb102b270c514ad6c69ac48647b5e9e28b9445666"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ed2d82116a3b257c0e2cf4dc42da58e490a4953db025f0e65505bf9a2de880e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22ddbcf12bd7e5808bdb9d767c172e45fd17396c7299f9e669de02219786c9cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e72040ad34a0029443ef2e495afeb5376fe91599edee4f516316e9657f0abc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c936c27544a9bc6689cf07822698ce2de3680c1802865b677378368ee5976e52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74e2ae23e7f2db3afd873c00a5d4d9f217f0dfcce058251a397303cbcf00b62f"
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
