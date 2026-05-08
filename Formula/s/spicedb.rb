class Spicedb < Formula
  desc "Open Source, Google Zanzibar-inspired database"
  homepage "https://authzed.com/docs/spicedb/getting-started/discovering-spicedb"
  url "https://github.com/authzed/spicedb/archive/refs/tags/v1.52.0.tar.gz"
  sha256 "14be7dd41e87d7ef6c89ee158cc5e086ba7053cd9c2bb2e2a275ee6d7b204776"
  license "Apache-2.0"
  head "https://github.com/authzed/spicedb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c960290666c82166c8f1e67fe57acfaf44aa24169b7be76111b3dcb742b7a5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5a055ac7f4027d47ae491660cad06c6e9fae074dbb00897ccbe445bd38e65d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97c28d0f9be8b782668aa94b325b79f7b98c78235780749f9c53af3337360fb6"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3b89e992b2498e5c0cb63c19b60a9052315ea3ee1369e23992b1dce8ca219f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0919286b51675dc9257bf78f14e47fb16bc81a5c50b46e210b2ae841554b33de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "810d02f1a15eb7e92bbc408aeac022f3ad9345faad4dae1b80efcf59e938691c"
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
