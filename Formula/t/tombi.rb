class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.32.tar.gz"
  sha256 "ce6323ee5b3b59a1fb59d315f5891c37cf3de932ebc34bbd2c2db848ae9286d2"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c01b450f452e280a5c4805fbe1307799767e5476c6a427103156331cbb680f29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c562942f1739ea3063eb75bbb8d4ad11222b28304f40e79a5561c9c0bffd886"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa1df57bc4c45feb07190bf8240aa843dd0a6c4b45718a2188f180ae981d9ec1"
    sha256 cellar: :any_skip_relocation, sonoma:        "36c938fa59f0ec14a86bc98ef558aeed3d4d217c2aa509dd72aafbf50469e512"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82711926402b000c831eb9841932d3c27440568adbdd17848281e6bd6209a68a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc0764af17afa730a0dadbb15fe901beb20653db1be4084b28fedc55a658553c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/tombi-cli")

    generate_completions_from_executable(bin/"tombi", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
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
