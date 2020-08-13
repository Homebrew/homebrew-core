require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.5.16.tgz"
  sha256 "303feeac4a7b4ed4824402ac707b97a18d18a69b442da6950f28abcdabcb766b"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "a3e780b7bbb2a1ee05f337bb64b68410c18389d7c693ea3ed098b1388a0225e1" => :catalina
    sha256 "a355ba263a9f1f0933e220277656c19bd14f3fd06e6859f385b9c26d40b1239a" => :mojave
    sha256 "2b79c05130eff84ca8a99d5c61b6d9226b2353774ceb1b7bd95d273e64540a4b" => :high_sierra
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
