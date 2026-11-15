class Spicedb < Formula
  desc "Open Source, Google Zanzibar-inspired database"
  homepage "https://authzed.com/docs/spicedb/getting-started/discovering-spicedb"
  url "https://github.com/authzed/spicedb/archive/refs/tags/v1.57.1.tar.gz"
  sha256 "cee0740dfccb9b7e52ba45e51a0db31a1efcb400f8c6517023ce881da804ca3d"
  license "Apache-2.0"
  head "https://github.com/authzed/spicedb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f06f824b363a4fc038b9a56e59c84c632cf603ee53e94f7d422826c38fe087be"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e38e17c5e9ecccefe9bc213452144db38bd8ca218ef43695ed6ad4521b3a92ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d17c0841b9870112fc85cea0f4bd8552ab875ab19bdfff0a53909fbb4652a55d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d6e2b433228a7ae24a90a2ea4a844cda55b3b50c419fd0e136757bb1a172634f"
    sha256 cellar: :any,                 x86_64_linux:      "59cbfbd25c3dd88d746acbba94cfa2d2041d17248bb678b8a5c58891b2b47d3d"
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
