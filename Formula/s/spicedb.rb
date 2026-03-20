class Spicedb < Formula
  desc "Open Source, Google Zanzibar-inspired database"
  homepage "https://authzed.com/docs/spicedb/getting-started/discovering-spicedb"
  url "https://github.com/authzed/spicedb/archive/refs/tags/v1.50.0.tar.gz"
  sha256 "847d6f37e6123723be557e7665fcc57f72ee54dec05bfbe9b6887bb0844e07ee"
  license "Apache-2.0"
  head "https://github.com/authzed/spicedb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "364bf7f3e93e657924223e5750d93dc904f20018ce5d32fd25630225c9a98f09"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "840538c6763554fe63704d50a6c33559a5d0c7b3165a0143418e80f73ae33a80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6ae1e7a319e86a2d86b23f0c07a2e41911c26c45747fedc60a38b48fb34e5f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed9af191cd87a654ca09150d802ae3669b84406fbcbb6a4b44a599e5cc90e511"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23690922684971c39346285cc4e96e455e2929ff38f4e240745b7d82d51bbf59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a7dc326507a6e1d02011d019dbc14bdf0b4bb88cc85a2372aaccc6c930f8f45"
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
