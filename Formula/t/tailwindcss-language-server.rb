class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https://github.com/tailwindlabs/tailwindcss-intellisense/tree/HEAD/packages/tailwindcss-language-server"
  url "https://github.com/tailwindlabs/tailwindcss-intellisense/archive/refs/tags/v0.14.15.tar.gz"
  sha256 "adfa033177772300681014010555e506a8a376799a5caeb747b8fbbc415cd4b9"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/@tailwindcss/language-server/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b27167adfe1c178e4951ffa9d43d6eee48916d7448d6dae8a25f5a40aac28ce5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b27167adfe1c178e4951ffa9d43d6eee48916d7448d6dae8a25f5a40aac28ce5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b27167adfe1c178e4951ffa9d43d6eee48916d7448d6dae8a25f5a40aac28ce5"
    sha256 cellar: :any_skip_relocation, sonoma:        "b27167adfe1c178e4951ffa9d43d6eee48916d7448d6dae8a25f5a40aac28ce5"
    sha256 cellar: :any_skip_relocation, ventura:       "b27167adfe1c178e4951ffa9d43d6eee48916d7448d6dae8a25f5a40aac28ce5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d84633f851b29b958373b36619d4b19b0d4286ea47547c661cfe7a7a31bfff5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d84633f851b29b958373b36619d4b19b0d4286ea47547c661cfe7a7a31bfff5"
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
