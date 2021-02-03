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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6d7b74c58893d2094e5094da3bb29d43c1ec96ed4933c7c05d16a86d58530035"
    sha256 cellar: :any_skip_relocation, big_sur:       "3933da9e9d4da7a2113b6d9985d8440ae992323729277f7f9680e732002d455e"
    sha256 cellar: :any_skip_relocation, catalina:      "193e546cb0b7a0bbb0478caffd442a3de4b0ff57fae944c7de65f73be74593ea"
    sha256 cellar: :any_skip_relocation, mojave:        "9a99fd867586905c0276f964db23f3fc6f8cbdd2ee31bdb71b244a72f2e16b05"
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
