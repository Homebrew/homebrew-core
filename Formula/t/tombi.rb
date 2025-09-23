class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.8.tar.gz"
  sha256 "90113aa65fcb9a43e0d65f3612a6013133a6afd785591bd5a31e8098ddc8a3a4"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2fa4ee7cf9a8a947d312a8f0d9973aec6be94c70df6915ce70e4f60735d29aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f895ee9479f2d80ea53643737fb7bb925554473cd7255a276e241a5846d051e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37d17b7cb312f8869adac13dbbebb414e41d10d8880f0a26102663d84da52bcb"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1f440fdcb14d8224a88acf0e3d2c0a00d17f47fd1fc42dc6197e52f7632761b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9f86fa536b2c18ffcff1461e48a9e1516c8c9d88dad54a5e9caa7e0155230c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d8bf1fbc3d3448ded9efda018f9a1f23e4b9bff3812b16b6c59fa28f070177e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/tombi-cli")
  end

  test do
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

    Open3.popen3(bin/"tombi", "lsp") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 1
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
