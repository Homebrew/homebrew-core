require "language/node"

class Yarn < Formula
  desc "Javascript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/0.17.8/yarn-v0.17.8.tar.gz"
  sha256 "b54e762e2a54f1fb23c6b0f9c239c3791aae05aface5ea0d6498f2a7979b541c"
  head "https://github.com/yarnpkg/yarn.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "adcc3a08d0f7075c52908d9886e3fc713eafa5fbbb417ccfd2e6f7f71d4ccc97" => :sierra
    sha256 "8d2d081b171dd6bac19851855b146fe5ac77ac45a7ea432462e6ff086426ad54" => :el_capitan
    sha256 "bbfb432cb25c333f70f007844f8b5a0a3f12482a9017f3e8c09bb2b78f8805f8" => :yosemite
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"yarn", "add", "jquery"
  end
end
