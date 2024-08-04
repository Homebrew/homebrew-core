class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.81.tgz"
  sha256 "7cb420cd820104160e0e9e11c5752c6b68835317edfe0bbc18de1420c7a08d54"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4277f98e603a1e3073a01cd4db448b775ce54bb4b185b7b2add9d4da8f10996a"
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
