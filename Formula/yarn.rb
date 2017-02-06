require "language/node"

class Yarn < Formula
  desc "Javascript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/0.19.1/yarn-v0.19.1.tar.gz"
  sha256 "751e1c0becbb2c3275f61d79ad8c4fc336e7c44c72d5296b5342a6f468526d7d"
  head "https://github.com/yarnpkg/yarn.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "254562a81321bea97a91346a5654c02a2a6e438c0b667d3544d8fcf38b69bf86" => :sierra
    sha256 "628a3f71dd020f4aa2842af963acde57445d5bcdc8b5a9db6e92f9b2aa2d82f7" => :el_capitan
    sha256 "541559528f798ebca981794c74310d2216486535aaf034997829b15383df7a23" => :yosemite
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
