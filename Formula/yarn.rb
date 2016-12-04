require "language/node"

class Yarn < Formula
  desc "Javascript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/0.18.0/yarn-v0.18.0.tar.gz"
  sha256 "8fb1843d2a1283972ff5fead9d6c9f9002de793ecec6dfec7abec908403ecd19"
  head "https://github.com/yarnpkg/yarn.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f85dfe3f763dea1ad3b54d02d3109b44876bb9a47625d19df5678a256ab23f4" => :sierra
    sha256 "37a98accd1968b6a1799e1bdbd712eb77af98a025acd24bd3df1983a9405cbad" => :el_capitan
    sha256 "50eb9a58288ca8650e76e9ae0e57d0f44496a02e0bea6e123f5bf2dfc78078fa" => :yosemite
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
