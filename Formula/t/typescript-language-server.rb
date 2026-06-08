class TypescriptLanguageServer < Formula
  desc "Language Server Protocol implementation for TypeScript wrapping tsserver"
  homepage "https://github.com/typescript-language-server/typescript-language-server"
  url "https://registry.npmjs.org/typescript-language-server/-/typescript-language-server-5.3.0.tgz"
  sha256 "398cacc17fff2108652e7b4050e3182008d17063246b3fea7dcf5fae2ce1560e"
  license all_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8c98a7ade2a6b709b01fe5075e8663d616df5cc82e6bfd1cb07bb822a0e28680"
  end

  depends_on "node"
  depends_on "typescript"

  def install
    system "npm", "install", *std_npm_args

    node_modules = libexec/"lib/node_modules"
    typescript = Formula["typescript"].opt_libexec/"lib/node_modules/typescript"
    ln_sf typescript.relative_path_from(node_modules), node_modules

    bin.install_symlink libexec.glob("bin/*")
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

    Open3.popen3(bin/"typescript-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
