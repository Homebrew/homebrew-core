class Spicedb < Formula
  desc "Open Source, Google Zanzibar-inspired database"
  homepage "https://authzed.com/docs/spicedb/getting-started/discovering-spicedb"
  url "https://github.com/authzed/spicedb/archive/refs/tags/v1.56.0.tar.gz"
  sha256 "e8c15ecc241e3f50feeab0c63062c961e4558608f25376623ce38e44ec3897b1"
  license "Apache-2.0"
  head "https://github.com/authzed/spicedb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d96cec014f6421be9b1a0f5bc6997e3340eab495e2071c3418ed394d49d7f55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3cfc8cb92be51820f4688fea839c0b296623df72126fbda56cc2394b24696024"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "522db4869b1135a48fa6098d1a9656a4576e9617257fd028d8263874f3c128fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4163f9ebfca13a58b4db264b9c937e48afcdcd0b6c5c08679f9148b456153bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f55016154543d3bc7c186c222b5eb47307982c11ae14beefc786597420cee89"
    sha256 cellar: :any,                 x86_64_linux:  "ea8549998563b9e51fd39398d5f5c4ff46b02bb49305e854d95ed97e42843efc"
  end

  depends_on "go" => :build

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
