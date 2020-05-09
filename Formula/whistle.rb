require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.5.6.tgz"
  sha256 "237d68e913125cdc10afb27bf20338c787e17bb8e4aa521a7d286787322a0666"

  bottle do
    cellar :any_skip_relocation
    sha256 "1cd9f1304b7a134b9eb4961d0d29e826eedabe8fce3ec93bbd8626f708c93d97" => :catalina
    sha256 "3e200e410e187ccae587b3888923bc5ac4b64ed29322ad71d494a269125aaf56" => :mojave
    sha256 "18f5ec57cce61eca7e708f437b5de5ff7de63ec4f6a15bcd3fc9fbd4f9a95f43" => :high_sierra
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
