require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://github.com/avwo/whistle/archive/refs/tags/v2.9.24.tar.gz"
  sha256 "e1d5892b300227c658ec7975c139cabf13c4c1b07abd9501a7ebedab52632790"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fbc6574d7d2385a318ea0c6442b3bc7d54d7d294d22dbd82aa889ccaab4c7324"
  end

  depends_on "node"

  def install
    system "npm", "install", "--production", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"whistle", "start"
    system bin/"whistle", "stop"
  end
end