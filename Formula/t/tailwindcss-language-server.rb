class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https://github.com/tailwindlabs/tailwindcss-intellisense/tree/HEAD/packages/tailwindcss-language-server"
  url "https://github.com/tailwindlabs/tailwindcss-intellisense/archive/refs/tags/@tailwindcss/language-server@v0.0.27.tar.gz"
  sha256 "128ac08f1e5fd02f023b07b675c7ab490f5a463ac552480048edf6357220e826"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/@tailwindcss/language-server/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c9353b2c1101406fc3554badb7be2fa19230d7a257c1a49372aee738a3de5de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c9353b2c1101406fc3554badb7be2fa19230d7a257c1a49372aee738a3de5de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c9353b2c1101406fc3554badb7be2fa19230d7a257c1a49372aee738a3de5de"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c9353b2c1101406fc3554badb7be2fa19230d7a257c1a49372aee738a3de5de"
    sha256 cellar: :any_skip_relocation, ventura:       "2c9353b2c1101406fc3554badb7be2fa19230d7a257c1a49372aee738a3de5de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cc158f2e27c2e31468fe58debd5abfc838945d73a4f8300ee5748b683fa13b5"
  end

  depends_on "pnpm" => :build
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
