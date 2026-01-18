class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.7.19.tar.gz"
  sha256 "dbe7f92d487807125fad4c10c8ef3a9b5bd59e5e3ed8d378a1e81ba89697fbc2"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96afd4f1bac8bb0cec56b70b8849562192bb4ce61b1a0a2dfa4692c2c6811206"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0198bd7da3814a152d3f1189b41a8af55195890158a375d155e23eb393d54fec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a51863a4505c4beb77bb0639579838e054129b80fdd608391d28d0786de0e2d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c7a88d0003c14220ee2e12c2aa23695ac852e3c6c8406d259f24064ede9bdc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac671dc2ccda46edd84efd58aca7bbbc176673aa864a4daee3879c78adba62ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8230e66ed321b3d00f6530b0cee82abeccaa1655f1c4ea0ba9b91cec1957dbf5"
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
