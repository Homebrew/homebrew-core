class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https://github.com/tailwindlabs/tailwindcss-intellisense/tree/HEAD/packages/tailwindcss-language-server"
  url "https://github.com/tailwindlabs/tailwindcss-intellisense/archive/refs/tags/v0.14.25.tar.gz"
  sha256 "f07d66a945a45d824c593b46a8949d5daa6970cb6a961f1c57909e8a6d13e9d4"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/@tailwindcss/language-server/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9ac1973d306ab06989354353b1ec6f17412295eabae9a353870cfcfdfd2c635"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9ac1973d306ab06989354353b1ec6f17412295eabae9a353870cfcfdfd2c635"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a9ac1973d306ab06989354353b1ec6f17412295eabae9a353870cfcfdfd2c635"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9ac1973d306ab06989354353b1ec6f17412295eabae9a353870cfcfdfd2c635"
    sha256 cellar: :any_skip_relocation, ventura:       "a9ac1973d306ab06989354353b1ec6f17412295eabae9a353870cfcfdfd2c635"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90b0b851ebbe242cb64bd34658a009d2fcea2707335dd885abf72ee7788f3ffc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90b0b851ebbe242cb64bd34658a009d2fcea2707335dd885abf72ee7788f3ffc"
  end

  depends_on "pnpm@9" => :build
  depends_on "node"

  def install
    cd "packages/tailwindcss-language-server" do
      system "pnpm", "install", "--frozen-lockfile"
      system "pnpm", "run", "build"
      bin.install "bin/tailwindcss-language-server"
    end
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

    Open3.popen3(bin/"tailwindcss-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
