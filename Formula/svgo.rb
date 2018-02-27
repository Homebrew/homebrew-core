require "language/node"

class Svgo < Formula
  desc "Nodejs-based tool for optimizing SVG vector graphics files"
  homepage "https://github.com/svg/svgo"
  url "https://github.com/svg/svgo/archive/v1.0.5.tar.gz"
  sha256 "7b0a3ce0308ea6bead17dcb22a2a1195f4bf1b44c1f7ebf3462eb0c51a827139"

  bottle do
    cellar :any_skip_relocation
    sha256 "0462b5807fc9189590bd276a34e9440b1729b0fbd4d41db63d05560289e0d349" => :high_sierra
    sha256 "dc850a128d4b7a2cfefe91b23a74dc3f392e4fe1000fea1779c285cc4cda4351" => :sierra
    sha256 "11596ad45134fbd785785990392a36d90cc33124bc060c594ebd38fad484a5a1" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    cp test_fixtures("test.svg"), testpath
    system bin/"svgo", "test.svg", "-o", "test.min.svg"
    assert_match /^<svg /, (testpath/"test.min.svg").read
  end
end
