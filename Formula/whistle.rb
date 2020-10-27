require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.5.26.tgz"
  sha256 "b43d86b2be7b098d2f9871c2d550c5f3ec1e725bec7c4e5a6f9b0c391e594426"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "8f8f932e8976c2bc2c9c687c00e089569fb2eb7f5b6ce935055b2c74468a9472" => :catalina
    sha256 "8a4d0d462a255ff0919628700c6ac456ca7d5a9ffd049273a44114bfd04af406" => :mojave
    sha256 "e31fc5e7f9b1df1bd2b4275d6ad0aa742bc1b7b97a063669af404e495259bc2e" => :high_sierra
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
