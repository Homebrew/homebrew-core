class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.9.20.tar.gz"
  sha256 "a137dfc380aa22c7ac156c99600d1b45680fc1b88c0e68cf11aea8589d919c5a"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e43a22f07cfa1e27850066d67a3cff8ceef7315a101ee318ed9992a856cd8eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78f1f0e0bf17928ccc9ea1bf538729005333fcd3c0aacca4827cb7897e33b5cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dab486807a67589df6a67cd8ef722992fa3ce1313e4d2272b4737833ea4e68f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "0541e22f2f1e92d5b949a3d8feada18ca393bde9de76a7cda28f46d5fd7b62a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6dc5c5f93c32397a290843dbf75efbea2be9cd7211ffa21114d0c60f361099a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d050fa134aa5aa293b4df2679127db9ca16cdb489bcc549ceecc536262e07130"
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
