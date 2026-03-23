class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.9.9.tar.gz"
  sha256 "afc7bb6f33c77a6e56f77bb594f2a0173d9164c8566961b95322e04bc0a5555b"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ce3ba03081683b42ae92cc468a3df1a79c0252a97e8f05a6cdafe7e1a62560c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1977927075e85b7c01b5d58bd204bacd275b210b72234c20e3ce71389407f40f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7115fcec8ab2f97c235a7c541001fb69c025716bd773eb3fea3d19f68e5940fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "a252107aa04e3fdbf7dcd64ea3d673ec10b56e8865700e14be9cc0e539c0d037"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd8371cfdd21eaf32e5a7a5d71eee77d3e49458bd2675515d1f1ae37395e5a97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a01b64458d960f9ddf2cc994b045d9c3beb2d58b6f1e1c08fe965e479d4abef"
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
