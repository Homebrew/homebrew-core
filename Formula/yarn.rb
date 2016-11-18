require "language/node"

class Yarn < Formula
  desc "Javascript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/0.17.6/yarn-v0.17.6.tar.gz"
  sha256 "54c4d615fe388a2ccdaf3998911447ff5ea11ff19c1dd45558fed40f31cac8e4"
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
