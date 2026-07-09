class Spicedb < Formula
  desc "Open Source, Google Zanzibar-inspired database"
  homepage "https://authzed.com/docs/spicedb/getting-started/discovering-spicedb"
  url "https://github.com/authzed/spicedb/archive/refs/tags/v1.54.0.tar.gz"
  sha256 "16ddc20aab4afaa00ab2ed439a196b510fb20bd72ce66fdd602b1a44da07e11d"
  license "Apache-2.0"
  head "https://github.com/authzed/spicedb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9e59938cfece9a4f408eda4843bf9bca9d46fbd5d64d4f753f22aaf3ecbc08d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7cfc369005346f1a84be91ff976123b171599f5d7dafdd0cc6031836c28b1d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8442953d9ab7c2680eb64650a9ed7b20dbe69405edd4ac9b4ea34ee62d4c8541"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d6093d1347236e6686d9da874f2a1f90bc3610dce5875466291f2c1798f151c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "812860744890ea5c9fa4039f3b02f2afd2deee7314cbd7ef8cf3ea0318238322"
    sha256 cellar: :any,                 x86_64_linux:  "4c64539bb3ecd281a6bff46bf8edc27326188fd5a85133c68c2a1156436b6849"
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
