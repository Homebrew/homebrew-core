class Spicedb < Formula
  desc "Open Source, Google Zanzibar-inspired database"
  homepage "https://authzed.com/docs/spicedb/getting-started/discovering-spicedb"
  url "https://github.com/authzed/spicedb/archive/refs/tags/v1.51.1.tar.gz"
  sha256 "46ad21d26dc92712f4c26afccc13f95f5d44cd89f378328bdff0e6cc7757e190"
  license "Apache-2.0"
  head "https://github.com/authzed/spicedb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "623b076c0d338f9d4db0b09bc731a7b0244fe429d0edbbdf885a8c8edb9181dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "449d95be45c53bfdf3df5427094b116517e2635d9bc89eb2b30b1a17a7768c9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28a0904cd9a8aab028bf84f71e906645d600112ca7ed5ab288a6d6840f2ded1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "76a640589facd385fcaca8cc1168fda1c62c324ba62764f9affdd3e688dbc759"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21d514f4960cb2151279603aba3a7265907ac01f225d838c2227af08687a8308"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3286aa41ef553c3224865086407b54a378d203dcb7fb4cde0f97aadea03472cd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/jzelinskie/cobrautil/v2.Version=#{version}"
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
