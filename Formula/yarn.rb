require "language/node"

class Yarn < Formula
  desc "Javascript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/0.17.10/yarn-v0.17.10.tar.gz"
  sha256 "592140a9d387a892935ca49ee93a8207b95073e2b732693987420dd1a7606672"
  head "https://github.com/yarnpkg/yarn.git"

  devel do
    url "https://yarnpkg.com/downloads/0.18.0/yarn-v0.18.0.tar.gz"
    sha256 "8fb1843d2a1283972ff5fead9d6c9f9002de793ecec6dfec7abec908403ecd19"
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e6fbd90d01383a5c6b99ca85eb8940954e82e1416bfc31ed990a4a0e7f962b63" => :sierra
    sha256 "dac363aa991c0e512ebb73e9c6533200b895e1e33e73fa37df67ecab24ce40b7" => :el_capitan
    sha256 "6d756e5ab52733a59eea767f5ba410d46a166ac9dc656050426ba5ea5b49261e" => :yosemite
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
