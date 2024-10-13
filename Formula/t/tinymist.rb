class Tinymist < Formula
  desc "Language server for Typst"
  homepage "https://github.com/Myriad-Dreamin/tinymist"
  url "https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.11.32.tar.gz"
  sha256 "877d0c3722ac863d5f6f6469bd8b7b9a7ee461a2e4f50310ed0d42b795c1f182"
  license "Apache-2.0"
  head "https://github.com/Myriad-Dreamin/tinymist.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db0a8d50ea3b7479ddf55dd1253e75488c771bcb3ccdd1ec9a817747f8ec4ee4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a53ae8745338ce5d30dadf508a62c3565d4e799df17f2897b93009fc88d1a660"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a0ee762787d7350008d9950cdf39f915484deb029f889b376fdafd00aef1bc7"
    sha256 cellar: :any_skip_relocation, sonoma:        "93e0cda62885d645e98b392c50e944c4d41a3a2e61de0e9a683994461ddc95a2"
    sha256 cellar: :any_skip_relocation, ventura:       "103dc9c9071723396f3a8d0a5596c444d6c73a29e7a53537e3b936370d22f213"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0000922118e944caffab992a8555e6d668904a9edff32e6792b24ad77ded02b1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/tinymist")
  end

  test do
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

    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = IO.popen(bin/"tinymist", "w+") do |pipe|
      pipe.write(input)
      sleep 1
      pipe.close_write
      pipe.read
    end

    assert_match(/^Content-Length: \d+/i, output)
    json_dump = output.lines.last.strip
    assert_equal 1, JSON.parse(json_dump)["id"]
  end
end
