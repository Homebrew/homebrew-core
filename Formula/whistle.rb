require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.5.8.tgz"
  sha256 "1b19f2781480727d6a27fb4b35c2633c0d68b1624b91620a9ae10d1082337732"

  bottle do
    cellar :any_skip_relocation
    sha256 "f72788a3e477fb2f361b338a74ac6b42fbfa95c4529dc082f8c7ef8e48b15d58" => :catalina
    sha256 "497e289aa1b1aad83e73565c50c31177985ac3d21ce76f0466f115ff65fe2fff" => :mojave
    sha256 "415a91b644d3c8120951ec0ee3dfd19889403a4003b087b0267f6de27667809c" => :high_sierra
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
