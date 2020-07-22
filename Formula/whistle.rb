require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.5.14.tgz"
  sha256 "b19e5b255af539910bf0c02e57aefff0d831b3f37490424d3b3aa4854ad5b5f6"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "6ea3f0cfc3c58a538b377545426a121b2aed4cd079db0878b6846dd0e77ff282" => :catalina
    sha256 "2bd39cfe9cc7bf21e74a5b49d8ef204c5b8102a6ade920c5fe29dc2f5c8d706d" => :mojave
    sha256 "48946b695facc96bf1072128d907ad54e7dcce82f1912a42383ab6b966a41795" => :high_sierra
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
