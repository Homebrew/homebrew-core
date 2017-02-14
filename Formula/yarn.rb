require "language/node"

class Yarn < Formula
  desc "Javascript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/0.20.3/yarn-v0.20.3.tar.gz"
  sha256 "e7d052aba18716616213a602d66528eda7a2bdda7962fc23644ce53e74b1e1d5"
  head "https://github.com/yarnpkg/yarn.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f8f865fe65d72a3db18c41add745fe9d27bdffac6d4e641f425b8b33931f02fc" => :sierra
    sha256 "fbf183d9f0499d3981f609bfc0307baff87017a7f200aad0cb74936b80ea0eee" => :el_capitan
    sha256 "524e48a17168f757337ca057cfc4ceeca886dcc6341fa2a0bc7f84927141d4a7" => :yosemite
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
