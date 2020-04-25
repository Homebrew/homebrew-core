require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.5.3.tgz"
  sha256 "6885585307bbebf47b22a11dfe079461350c673f7599271516e4b7e3dd0d0f4d"

  bottle do
    cellar :any_skip_relocation
    sha256 "09282bd5c79b1749c6fcee85f30d3e0bf189d6188e6da1005516978142ecffbf" => :catalina
    sha256 "c84424b92cd4145a2f3171f4210d88cb8070f9e5ff9d105a33531c9df40c6bbb" => :mojave
    sha256 "d59a9791b30474c6b5757e69f2e71f88eab3d70cc7414c8c82af823551fdda39" => :high_sierra
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
