require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.6.5.tgz"
  sha256 "61e7c099ff62b42ca8bd5f57995f1829aa2bd76d0e9a83d6c3cb2810834eb184"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur: "ae6eea40588a9e68c0ba769b55bbd4ba1718c00036da9d45a42d6d11d1b711f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "81a509e7df5da26887bf5c8219d333080dbfe9cb21416c9922b16d1057203a4e"
    sha256 cellar: :any_skip_relocation, catalina: "388bed876a8f7f1ca726636955f87bd47f32f7e99df0ced41ad9125c7477b1e4"
    sha256 cellar: :any_skip_relocation, mojave: "a329c193d488b3016070449b29be42ffa91615a1571721ac34d84ebfd4b08771"
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
