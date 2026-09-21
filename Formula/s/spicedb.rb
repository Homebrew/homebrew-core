class Spicedb < Formula
  desc "Open Source, Google Zanzibar-inspired database"
  homepage "https://authzed.com/docs/spicedb/getting-started/discovering-spicedb"
  url "https://github.com/authzed/spicedb/archive/refs/tags/v1.56.2.tar.gz"
  sha256 "a8e0fabc378a3c31417ca325b8737b5cd299d6b96213ce69d44a44b0c2e2916a"
  license "Apache-2.0"
  head "https://github.com/authzed/spicedb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5b2b2ce622949aad3e3dc24af075eef0725fc2e15975c23c1cfa63ee4ab82ac3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d1e2c3a2e99cda8524603ae8761877478281118284ab00d6d62f5783840fcee9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9af145f8b6e067b47a3b75855c37ebd06bfba0d4233d874cb3ef5b448c2842a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "71af2b6210b73393eb1fb8e0c73324f99c880cc7139fb59deffd613a00702a9e"
    sha256 cellar: :any,                 x86_64_linux:      "313b6b70fd0eedc59fd530d0fc4b7742a356f5d58992c4107a7fe92da109f43f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/jzelinskie/cobrautil/v2.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/spicedb"

    generate_completions_from_executable(bin/"spicedb", shell_parameter_format: :cobra)
    (man1/"spicedb.1").write Utils.safe_popen_read(bin/"spicedb", "man")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spicedb version")

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

    Open3.popen3(bin/"spicedb", "lsp") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
