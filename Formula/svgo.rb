require "language/node"

class Svgo < Formula
  desc "Nodejs-based tool for optimizing SVG vector graphics files"
  homepage "https://github.com/svg/svgo"
  url "https://github.com/svg/svgo/archive/v1.0.4.tar.gz"
  sha256 "e40a753734f45d6e1a35617c4a8c1e945f7cdb3e776b244131d80f5ba21ec0fe"

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
