require "language/node"

class Yarn < Formula
  desc "Javascript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/0.18.0/yarn-v0.18.0.tar.gz"
  sha256 "8fb1843d2a1283972ff5fead9d6c9f9002de793ecec6dfec7abec908403ecd19"
  head "https://github.com/yarnpkg/yarn.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "13506efb3ea4af4d462df95bd3c5021abdbad756fb52e125d9b367e6873fc7f5" => :sierra
    sha256 "ca800a0961c1952619057f94df6b9d7ea1475b5ae816c27218ba9c9fc9fe93c4" => :el_capitan
    sha256 "61cdd813cf5ce5b66c07f6bd211abe2370b60900c45882a6f782b3c828f63548" => :yosemite
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
