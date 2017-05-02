require "language/node"

class Yarn < Formula
  desc "JavaScript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/0.21.3/yarn-v0.21.3.tar.gz"
  sha256 "0946a4d1abc106c131b700cc31e5c3aa5f2205eb3bb9d17411f8115354a97d5d"
  head "https://github.com/yarnpkg/yarn.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "9858ac5a34367b65a20ee828cba84ded38ac1bd9920f6c11c28e5d3a896755cf" => :sierra
    sha256 "de303f2b4ab5fe273082118825b01c3ef64bb4e109fc62d36eeb37d23dfe7b81" => :el_capitan
    sha256 "9b0b0e12931a58f5ef2a29372a353f46a65d81de492cf919cb9ece34019cd999" => :yosemite
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    inreplace "#{libexec}/lib/node_modules/yarn/package.json", '"installationMethod": "tar"', '"installationMethod": "homebrew"'
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"yarn", "add", "jquery"
  end
end
