class TypescriptLanguageServer < Formula
  desc "Language Server Protocol implementation for TypeScript wrapping tsserver"
  homepage "https://github.com/typescript-language-server/typescript-language-server"
  url "https://registry.npmjs.org/typescript-language-server/-/typescript-language-server-4.3.4.tgz"
  sha256 "9a8aef1dd532f9b4b38087b002b949d9e761ab31fe1dc2f0bfe43ac223150385"
  license all_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2266c2f21fcd3c94c369759aee6b98550ae724129e32fbe1de82fd15b1b76297"
  end

  depends_on "node"
  depends_on "typescript"

  def install
    system "npm", "install", *std_npm_args

    node_modules = libexec/"lib/node_modules"
    typescript = Formula["typescript"].opt_libexec/"lib/node_modules/typescript"
    ln_sf typescript.relative_path_from(node_modules), node_modules

    bin.install_symlink Dir["#{libexec}/bin/*"]
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
