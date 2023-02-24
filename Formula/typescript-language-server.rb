require "language/node"

class TypescriptLanguageServer < Formula
  desc "Language Server Protocol implementation for TypeScript wrapping tsserver"
  homepage "https://github.com/typescript-language-server/typescript-language-server"
  url "https://registry.npmjs.org/typescript-language-server/-/typescript-language-server-3.3.0.tgz"
  sha256 "8e713bbd54f86c2193ba8acc94a47435136b2eb54a3c64205d982311f4c428d9"
  license all_of: ["MIT", "Apache-2.0"]

  depends_on "node"
  depends_on "typescript"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)

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

    Open3.popen3("#{bin}/typescript-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
