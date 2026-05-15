class Spicedb < Formula
  desc "Open Source, Google Zanzibar-inspired database"
  homepage "https://authzed.com/docs/spicedb/getting-started/discovering-spicedb"
  url "https://github.com/authzed/spicedb/archive/refs/tags/v1.53.0.tar.gz"
  sha256 "4d0750ce2b99aed14a98c20361993814fb4f1ed9b49364283337850e2d82c04c"
  license "Apache-2.0"
  head "https://github.com/authzed/spicedb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aadf70bedd600402413e645f21db4ad133c5b851a9331384e176f5871c19246c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aba8a9fe90b9116b0456685ac290bc26996cc1f1979bf25a97bd7aa93acdbda6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95d0e3cf046901e80bd31cea3717f84d76cdd7a0ffebd232ddcee8d61c1f4995"
    sha256 cellar: :any_skip_relocation, sonoma:        "9484d99bf7bc1e984433a50dfbaa07076332dfb5fb030838da3b5a5fb7c2c44a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76d225128821e72eb0ec8f5f0777ed328f6dab7ff43d19589a8a87016795eb39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71c0fc58e4b467881a6db5b8e020f4003780b12c6df5358889924c31720047aa"
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
