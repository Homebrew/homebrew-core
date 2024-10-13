class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https://github.com/tailwindlabs/tailwindcss-intellisense/tree/HEAD/packages/tailwindcss-language-server"
  url "https://registry.npmjs.org/@tailwindcss/language-server/-/language-server-0.0.25.tgz"
  sha256 "d9dbfb8d0beb4f4f6032fe11c2935da50096a4506cf3c4954af48741865c3dd6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b06a662e763a33e0889881ef40106fcdd7f4de64235647a5ae8310f303d71f29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b06a662e763a33e0889881ef40106fcdd7f4de64235647a5ae8310f303d71f29"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b06a662e763a33e0889881ef40106fcdd7f4de64235647a5ae8310f303d71f29"
    sha256 cellar: :any_skip_relocation, sonoma:        "c91eb06193445ef906eb1e4dc1249f5923d8ba0cd910b1b96f09a7f38802ae4b"
    sha256 cellar: :any_skip_relocation, ventura:       "c91eb06193445ef906eb1e4dc1249f5923d8ba0cd910b1b96f09a7f38802ae4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b504733af7143d471aff34c3aacfd7c908aff8ec12cbe73ccec108a74398bff"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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

    Open3.popen3(bin/"tailwindcss-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
