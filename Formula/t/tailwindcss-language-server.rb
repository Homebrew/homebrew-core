require "language/node"

class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https://github.com/tailwindlabs/tailwindcss-intellisense/tree/HEAD/packages/tailwindcss-language-server#readme"
  url "https://registry.npmjs.org/@tailwindcss/language-server/-/language-server-0.0.13.tgz"
  sha256 "60055b10f3e5750fcb58e236bcab870304bde4056c2cdf7813a18a1712f1c8a6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1be79f7f4986c94f1b18f6555090c5edc5bacc73bb919d87f36678e65f83d726"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2022c5f04210065f10b27a9d8f1b89246d8e81c7f087813aed4589117a80267"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2022c5f04210065f10b27a9d8f1b89246d8e81c7f087813aed4589117a80267"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2022c5f04210065f10b27a9d8f1b89246d8e81c7f087813aed4589117a80267"
    sha256 cellar: :any_skip_relocation, sonoma:         "4560ffad1beb68d361d7c93125dd13c32cf973027ac3fead4ab4d4d1975b5416"
    sha256 cellar: :any_skip_relocation, ventura:        "d2867ed73a0fd7216ca806d1be8690503ddbd7540cf32760e9d80f5751169398"
    sha256 cellar: :any_skip_relocation, monterey:       "d2867ed73a0fd7216ca806d1be8690503ddbd7540cf32760e9d80f5751169398"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2867ed73a0fd7216ca806d1be8690503ddbd7540cf32760e9d80f5751169398"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e732f29b04de1a8307b8b061ee97a5579ca7cb1f4853c777fbbc5a429a327624"
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
