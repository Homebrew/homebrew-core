require "language/node"

class Yarn < Formula
  desc "Javascript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/0.17.6/yarn-v0.17.6.tar.gz"
  sha256 "54c4d615fe388a2ccdaf3998911447ff5ea11ff19c1dd45558fed40f31cac8e4"
  head "https://github.com/yarnpkg/yarn.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "15faf6c8eb58ed7a83b3f4a92955cc440cfed3d61e06529ef22649c15f9fc5c1" => :sierra
    sha256 "010b0ba47d7c2c86b7de1780316a0ec01fb247eebff69b0babf018ae2117a0b9" => :el_capitan
    sha256 "ee914bed61db7ddc1bc1910c0cfbb5abc72939819d0ea2ef0fdee0effc453190" => :yosemite
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
