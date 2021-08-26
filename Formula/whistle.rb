require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.7.18.tgz"
  sha256 "351d8d76210db7f29356b7b5b96d2a2e6cfff96143ff15919134408943425c41"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "05a70b6d4e67164dd15292a318aa5a4ce38aa6b9c6ce2993ec9deceab1bc4157"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"whistle", "start"
    system bin/"whistle", "stop"
  end
end
