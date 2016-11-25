require "language/node"

class Yarn < Formula
  desc "Javascript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/0.17.9/yarn-v0.17.9.tar.gz"
  sha256 "6846f46d6a500dca8f4490f80da62898a9162f94cdb7486c2e86787092d2fd8d"
  head "https://github.com/yarnpkg/yarn.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "65033d0c1235caed412854daf1e1ce19a95dce77ddb0179ef2abcab37173bec0" => :sierra
    sha256 "45169fd2b8e2bb10f48eb1e3981bbe36705de02297534d477feb79b72a68e69f" => :el_capitan
    sha256 "4e0ed7e47a9cd1852b50432a2f8008eb929e237785c533f6ccb2e2a843ee28b1" => :yosemite
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
