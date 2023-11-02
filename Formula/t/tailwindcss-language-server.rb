require "language/node"

class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https://github.com/tailwindlabs/tailwindcss-intellisense/tree/HEAD/packages/tailwindcss-language-server#readme"
  url "https://registry.npmjs.org/@tailwindcss/language-server/-/language-server-0.0.14.tgz"
  sha256 "2e6f29b4d9acab4de233a6d56ae2e0cbcef8036a399e688b799c95604eadb877"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "06469ca761774da256b3c0ec95146fde4e8077f201a71b3c7953cf80f2bf7d20"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06469ca761774da256b3c0ec95146fde4e8077f201a71b3c7953cf80f2bf7d20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06469ca761774da256b3c0ec95146fde4e8077f201a71b3c7953cf80f2bf7d20"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b8884eac1f3cc960403219c5dd496f67df0659dce8ab3b8f30f30e1e9c2f1a6"
    sha256 cellar: :any_skip_relocation, ventura:        "4b8884eac1f3cc960403219c5dd496f67df0659dce8ab3b8f30f30e1e9c2f1a6"
    sha256 cellar: :any_skip_relocation, monterey:       "4b8884eac1f3cc960403219c5dd496f67df0659dce8ab3b8f30f30e1e9c2f1a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d3b03d738cf5193813da95bb74f0258581032bc3375a2218c90e8d2437aebc5"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with their native slices
    (libexec/"lib/node_modules/@tailwindcss/language-server/bin").glob("*.node").each do |f|
      next if f.arch == Hardware::CPU.arch

      if OS.mac? && f.universal?
        deuniversalize_machos f
      else
        rm f
      end
    end
    (libexec/"lib/node_modules/@tailwindcss/language-server/bin").glob("*.musl-*.node").map(&:unlink) if OS.linux?
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

    Open3.popen3("#{bin}/tailwindcss-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
