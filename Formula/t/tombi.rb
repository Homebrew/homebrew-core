class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.9.tar.gz"
  sha256 "4fa71758e792db89c3578a26510fd64cf4ce079d8606a698daed958ca482e812"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dfa42e81cfbe6034dde4019562aab9cb9685284c0d5e557aed305fb8571ef218"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54fbb95e52244f67aca3c406efa35efa75fc47404dc5d0792ac77625e41dab9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb3a2fb3f3fa5d59c1bda74c977301da0d42e9c2c14dd93bd75c48ebcbfcc282"
    sha256 cellar: :any_skip_relocation, sonoma:        "a84d644be678518cf83471aa98274a30efa6ddc217c635e7da42de033921e207"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f80eb1aa7c2003e42056f37f1431c5614740479196b9794e3e6009fc0e164784"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9792ab226a11c9d8c6f99022f29157e856360fb73b5d989a889d8a47cf51c032"
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
