require "language/node"

class Yarn < Formula
  desc "Javascript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/0.17.3/yarn-v0.17.3.tar.gz"
  sha256 "883df435f68ce47c93c2e4be27acbd4122ae52ef4d334f75104c0c5e187a9173"
  head "https://github.com/yarnpkg/yarn.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c7dd1b52cbf45c9a22fcf5e9f09c48a43805953b23efcec4dc7780e1e831238" => :sierra
    sha256 "c1444b8785f79e19f5bd7d7ccda75703f4a12cea30f56881a279800103668d21" => :el_capitan
    sha256 "12a7b8cbe7c360cd16890560fe4af63d23e661d62f457f2df6a0bfcd928f33e8" => :yosemite
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
