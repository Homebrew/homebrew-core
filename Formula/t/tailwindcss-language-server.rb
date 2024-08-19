class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https://github.com/tailwindlabs/tailwindcss-intellisense/tree/HEAD/packages/tailwindcss-language-server"
  url "https://registry.npmjs.org/@tailwindcss/language-server/-/language-server-0.0.22.tgz"
  sha256 "17a3f8d4acbfb698834366f01a1de6d5bd62748b80f357c04ab694a7aa672975"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "83beccd20edf52d29d6438a39d1bd7e313e7f9343de7241fe6c24a5078143eae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83beccd20edf52d29d6438a39d1bd7e313e7f9343de7241fe6c24a5078143eae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83beccd20edf52d29d6438a39d1bd7e313e7f9343de7241fe6c24a5078143eae"
    sha256 cellar: :any_skip_relocation, sonoma:         "54a446e83c28adc839a823e1a688918e1751771032b43e4b7c970da7ef862578"
    sha256 cellar: :any_skip_relocation, ventura:        "54a446e83c28adc839a823e1a688918e1751771032b43e4b7c970da7ef862578"
    sha256 cellar: :any_skip_relocation, monterey:       "54a446e83c28adc839a823e1a688918e1751771032b43e4b7c970da7ef862578"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c33ad18b70149f63aac8104b9c20b7ea16aea05804ce7093e0b67b318ed40af3"
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
