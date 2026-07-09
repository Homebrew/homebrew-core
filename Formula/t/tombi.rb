class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "207dd1e3febd28a970f99da140f375d60fd838d0017e0f641648b6b5b77cbc3f"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75ff3afad7342a9b4865bc4c3906744f6788810a377dc0de5abea50d2c7b1445"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23156edc0b511b60b261a24e50b99978092ded05bf98908db9c414d2bf5db443"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c3928055c2a85bf7e936b4d42bb0d0eaec34ab1bc2e35951b51cbd75ffadb54"
    sha256 cellar: :any_skip_relocation, sonoma:        "ade2b9524e6cf0e2a9bed4720e8e5f8895bcd4d653bb99a7573a1921cfe759e7"
    sha256 cellar: :any,                 arm64_linux:   "69b6802d817d2af3a7218b2478f553cc84b71d47cf7756054dec4f65419f6218"
    sha256 cellar: :any,                 x86_64_linux:  "e23a8473e57205ab9b54d6b92e1dad81ca4f89b68a37676e5b1a69bb26a92ca2"
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
