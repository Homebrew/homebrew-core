require "language/node"

class Yarn < Formula
  desc "Javascript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/0.18.1/yarn-v0.18.1.tar.gz"
  sha256 "7d16699c8690ef145e1732004266fb82a32b0c06210a43c624986d100537b5a8"
  head "https://github.com/yarnpkg/yarn.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fe9927b6f9b57fadb4196edfb9e7af2d5336f96708ff5e3337a4fd08e7f28878" => :sierra
    sha256 "f9260b6856ea91e6b112fd684abc868fb99a518f371df18c573669556b493aa7" => :el_capitan
    sha256 "cc5dea51f5b64379fcf0a45861ca6a44ea2e844aace74b726091d8a6b901d300" => :yosemite
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
