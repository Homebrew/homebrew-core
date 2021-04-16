require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.6.12.tgz"
  sha256 "c69ada8830332c285267ec28e6eb76ed2ecb1a162e5ff064c05ab5990fabb8ac"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2486b25eedc48b6605c7602dadeb2600464d97ecb172ab47c8745dee0e8bbc91"
    sha256 cellar: :any_skip_relocation, big_sur:       "5673a37283548a128e978b08c35889ce8f4d8243381c973aa60343eb8d5812cd"
    sha256 cellar: :any_skip_relocation, catalina:      "39051cfd070da7be97b54ec21a40f9dd05dcf5a2066b1e357c4281d796f4aa1a"
    sha256 cellar: :any_skip_relocation, mojave:        "087509bf3ec2ed729f0a20a0a8a0dc59e181f6a1d2e8b5b9260d6ba259f0a106"
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
