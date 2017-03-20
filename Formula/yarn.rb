require "language/node"

class Yarn < Formula
  desc "JavaScript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/0.21.3/yarn-v0.21.3.tar.gz"
  sha256 "0946a4d1abc106c131b700cc31e5c3aa5f2205eb3bb9d17411f8115354a97d5d"
  head "https://github.com/yarnpkg/yarn.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "232c7a76da36b77a0c199296ed31fcf9459a2d0b3104b627dd81e38d233cf5b2" => :sierra
    sha256 "b62a9a3bfce10f12dbde2305f8edfd6f481ac4dace9781233ba596b2f7eb648f" => :el_capitan
    sha256 "203bb0a466b611b76686b902f8382672d68f262750195625b3953e3f951125b7" => :yosemite
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    inreplace "#{libexec}/lib/node_modules/yarn/package.json", '"installationMethod": "tar"', '"installationMethod": "brew"'
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"yarn", "add", "jquery"
  end
end
