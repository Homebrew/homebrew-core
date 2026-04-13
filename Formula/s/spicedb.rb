class Spicedb < Formula
  desc "Open Source, Google Zanzibar-inspired database"
  homepage "https://authzed.com/docs/spicedb/getting-started/discovering-spicedb"
  url "https://github.com/authzed/spicedb/archive/refs/tags/v1.51.0.tar.gz"
  sha256 "88c785a990b78e1653fba5277ff7002a0cb25f9a72b89cc2a8faf5902b34a9c1"
  license "Apache-2.0"
  head "https://github.com/authzed/spicedb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "733467766c98ab39700a1bc958415677b0815830888e912c881b791d7e9a1165"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9e724555f5448085cd044d363511422095f152fc63629c6036e807358f099d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d9d94718cf9060b41998f25cca0e8faecf77e3dfe926a225583dcddb304fbbe"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e196a8ea84d1d65a0d17155aecf0d7848e2d888b239ba0308c6bb26528af406"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d9198096e34b19480e3f237a4c2321a97a6ace0c352dcd8fd9375e2938ed163"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1321f164b3d9f8fef2135e87858d2b805d2d9005dd9a7b88bd1fd49bbc30e34d"
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
