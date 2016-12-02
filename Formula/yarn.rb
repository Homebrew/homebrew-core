require "language/node"

class Yarn < Formula
  desc "Javascript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/0.17.10/yarn-v0.17.10.tar.gz"
  sha256 "592140a9d387a892935ca49ee93a8207b95073e2b732693987420dd1a7606672"
  head "https://github.com/yarnpkg/yarn.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5890cd1cf035886592bb3fda87f6b77e8928b956f9307f51c1871d9df32fe9c7" => :sierra
    sha256 "5294a8d76261c5d2fa8658ea2ccf96a87ea7e13d9500ec976c5721a50213866f" => :el_capitan
    sha256 "2caf8440c9844720de1b0109ac48ed7761f661d0ba451c0d9c4a776abad03fae" => :yosemite
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
