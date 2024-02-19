require "language/node"

class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https://github.com/tailwindlabs/tailwindcss-intellisense/tree/HEAD/packages/tailwindcss-language-server#readme"
  url "https://registry.npmjs.org/@tailwindcss/language-server/-/language-server-0.0.16.tgz"
  sha256 "338e1ba6dec23fd941a8b6e0b6328c7dfe77e686f0ed1eff070f63ec36d113d8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26ae967f5162607e7e5da363720533878ab53e45aac157a3a48ab5a81acc6d8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26ae967f5162607e7e5da363720533878ab53e45aac157a3a48ab5a81acc6d8f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26ae967f5162607e7e5da363720533878ab53e45aac157a3a48ab5a81acc6d8f"
    sha256 cellar: :any_skip_relocation, sonoma:         "619f3b52323277d6ab4261c282fc99c6864f6dfefdae0f116fcf2aa920614ea1"
    sha256 cellar: :any_skip_relocation, ventura:        "619f3b52323277d6ab4261c282fc99c6864f6dfefdae0f116fcf2aa920614ea1"
    sha256 cellar: :any_skip_relocation, monterey:       "619f3b52323277d6ab4261c282fc99c6864f6dfefdae0f116fcf2aa920614ea1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4a43089ff4492d021c63a6537243c0e2d05f55ad2bf6cd3a725430c7db3494b"
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
