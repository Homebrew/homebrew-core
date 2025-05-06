class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https://github.com/tailwindlabs/tailwindcss-intellisense/tree/HEAD/packages/tailwindcss-language-server"
  url "https://github.com/tailwindlabs/tailwindcss-intellisense/archive/refs/tags/v0.14.16.tar.gz"
  sha256 "a797432cc9104355465dea01a66adc05f9850194eadb134c9f2bd2e55ba0f073"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/@tailwindcss/language-server/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c7bdf45cc3af1039199c1fde931d30990992f636ba8c48c6c0bcfcc39a04c26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c7bdf45cc3af1039199c1fde931d30990992f636ba8c48c6c0bcfcc39a04c26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7c7bdf45cc3af1039199c1fde931d30990992f636ba8c48c6c0bcfcc39a04c26"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c7bdf45cc3af1039199c1fde931d30990992f636ba8c48c6c0bcfcc39a04c26"
    sha256 cellar: :any_skip_relocation, ventura:       "7c7bdf45cc3af1039199c1fde931d30990992f636ba8c48c6c0bcfcc39a04c26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f4c3dced312b20f23f23cf130f34dda99440e912209fcd7ae4c74275a33e009"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f4c3dced312b20f23f23cf130f34dda99440e912209fcd7ae4c74275a33e009"
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
