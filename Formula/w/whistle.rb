class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.105.tgz"
  sha256 "f00847550d96af7079f86a7353a8763317f4df5012dd3c5670798ba791670207"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "71720018ca4cec14fb0292ceaf9996cef94b757cc8df142cc931fa424d7ae192"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"whistle", "start"
    system bin/"whistle", "stop"
  end
end
