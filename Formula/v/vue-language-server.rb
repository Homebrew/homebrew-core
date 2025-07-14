class VueLanguageServer < Formula
  desc "Vue.js language server"
  homepage "https://github.com/vuejs/language-tools"
  url "https://registry.npmjs.org/@vue/language-server/-/language-server-3.0.1.tgz"
  sha256 "91226013de0ed6a61d77f62845ec7c0894a9ad2d793e96e84f30a12a7623da71"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "813b125a0878ed2d073b9d5013b71860fa8d63c40647455ccd6e66cb87c97db2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed696f58069fffc34b10e1fc73db513604fdc3f9bf2f480393132228f0ecf6df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d385a611799f7b415566ac95d70f7139fc0d58817a5222c18145ce36ab21eee2"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a7889cd30d9597ae1ea9f89b328f61cd2358ea965d192339ec2391bdaf0884e"
    sha256 cellar: :any_skip_relocation, ventura:       "48dd2b9436d98863ebde91eff15344e340ff4df44b07f82519ed68bf907f6fae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f59c485732941332ec9e7a28fe240fe3da52066b475d6dde1227d207145be65"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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

    Open3.popen3(bin/"vue-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
