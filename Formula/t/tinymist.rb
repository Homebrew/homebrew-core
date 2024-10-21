class Tinymist < Formula
  desc "Language server for Typst"
  homepage "https://github.com/Myriad-Dreamin/tinymist"
  url "https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "4b919f2a823b727edb6601d9675a2716baa816ea5e510b09fea4d0d696cc31a0"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61132e0038f415e656dd121c9af547e20e176093726b929d2ee34228382836db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a24202f7cd6e24885af84d5b0b2bcf2cf17e7e3f3201b163d9246224491a2c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a61519f2b5bdda54616214cfdf9b81a9503a382093acc78a0f6d28abb2c44bc7"
    sha256 cellar: :any_skip_relocation, sonoma:        "28a13ede32ca2679a6087563534451649a61404b65b8b5766ec3108acd70c460"
    sha256 cellar: :any_skip_relocation, ventura:       "218c95b18efe29e714f5b995da602c2dc17749945933d5976433162915e1fad9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a717c6bc45ed0d76aa593bf6acb017252bbfcdaf06eb21f88d27c7a573f8c7af"
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
