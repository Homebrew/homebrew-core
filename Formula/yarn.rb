require "language/node"

class Yarn < Formula
  desc "Javascript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/0.16.0/yarn-v0.16.0.tar.gz"
  sha256 "cd1d7eeb8eb2518441d99c914e5fd18b68e2759743d212dfd8f00574a1de6da8"
  head "https://github.com/yarnpkg/yarn.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "04d5fe5e5667d77b40a882a1bdbe08625bd52e0d228af7aa925455760bafd58f" => :sierra
    sha256 "291ad03475ea4770f357559dc9116309796bf1af83c13644cafcd00163283bce" => :el_capitan
    sha256 "84a717ce964d4ec5cd69ae6336a79db27fa7580cee1c978e33e310e4eb8e36a3" => :yosemite
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
