class Spicedb < Formula
  desc "Open Source, Google Zanzibar-inspired database"
  homepage "https://authzed.com/docs/spicedb/getting-started/discovering-spicedb"
  url "https://github.com/authzed/spicedb/archive/refs/tags/v1.57.0.tar.gz"
  sha256 "d9ef895cd0544ac43af5773d68d08c8e7c6bc02ac4fd21357e037715824759df"
  license "Apache-2.0"
  head "https://github.com/authzed/spicedb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e22f422a6eec4bcc7b58eb8c9549f2b371698a83b33d97d7b2025e1736bc2a81"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7ddde79f0a56bec14720f9528b81180a7e5de46ec4bc9df20bff100c320399f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4bfd5688f3f77db129669d2166bb7d40b23d19d531a7ec6252e63b265336e96b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7796aedefaff5d52b33d81dd02a352df4dc7abbe59edf15eb7587ec29a4e35f8"
    sha256 cellar: :any,                 x86_64_linux:      "2119f291750f6c361d70bf93a54f306f8e55af4641964364155447d2d7014c3c"
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
