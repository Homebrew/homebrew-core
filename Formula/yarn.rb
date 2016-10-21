require "language/node"

class Yarn < Formula
  desc "Javascript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/0.16.1/yarn-v0.16.1.tar.gz"
  sha256 "73be27c34ef1dd4217fec23cdfb6b800cd995e9079d4c4764724ef98e98fec07"
  head "https://github.com/yarnpkg/yarn.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "01ab99abd61a20a10eb99ebcfe2d5ce2fc49671848531ab1a0f21728e9cf8a3f" => :sierra
    sha256 "4c2f2ed16e4c529c7a77e09d8107ce4392e4e8cedff10bee76d4193c0d8ad420" => :el_capitan
    sha256 "4842ee650f3af9e6794bfa877fd2459a55cb60909b62193c97df45e5097c8b63" => :yosemite
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
