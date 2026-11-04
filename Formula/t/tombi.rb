class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "f86e50fc0e049baf6e1a6536767c22aca8b5ba9d62c711faf900750d82cf5b47"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "628deaa50c52814f8e808160ffce6b321246d4a917cbf8272322da1c2a5c05d6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "89abc4df76e761bab229c781d5669f5a4edb5fc6386cebc84c405bb58ffa2d6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a3ddda2c9837bfc6d94970bc3ac90852991be96ef6b8eb2c720b5db795f43d1d"
    sha256 cellar: :any,                 arm64_linux:       "23bf8b0051ea2aa31896b12361ed49222ab8022988df68719e41123957c70e8f"
    sha256 cellar: :any,                 x86_64_linux:      "6b326a37591cedb0d74198b2150d399f5521b871ae6ce4a9d7cac7812d5430d8"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args, "--manifest-path", "rust/tombi-cli/Cargo.toml"
  end

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
