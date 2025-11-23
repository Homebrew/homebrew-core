class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.53.tar.gz"
  sha256 "2dcdf5c433c963e399b08dc5ce2da27cad67fba78859cc224e6a3c049bb1a850"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06d253050475c3f93a93235287eee9ea377cf34df46d6dba2c0837cdd82641e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b642be7236381b6650b5f6c9f13a6bca11d0a6e36baf321d716d4f3d730fdc2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cf0b9258047b8f3554aa3070df1a31e24791dc8efb8347ddffd1c9ec21c27f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3401990e7dd3481e0b65b2376c81fd7dd1799210f840fc53dd2c376e8e7052a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e003621c6cc00c24058182bce4406aa7bbd700f410862f61800bcbeabcb4ba82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c109190997150f56fda4acfa7fbf3f987f674b1c8cc68003310c5baadd441ecb"
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
