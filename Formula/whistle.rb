require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.5.25.tgz"
  sha256 "2253a5556ca56c354be687a77602e38079a8b541968bbfea8f6d10534abfd34b"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "8b0b38d0724fd046289639c289cd87dc0f7b4e127cb3bf55ec5fd37a390484ff" => :catalina
    sha256 "83487ff5f87aea8e4bddf2b0a6dbdfcd77c67ebf75c82ec59d64e4df3e8e3a59" => :mojave
    sha256 "492ff0f1e3dadef8ebd18a08464d29a2aba4a45458d881f81d7f1af140e97808" => :high_sierra
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
