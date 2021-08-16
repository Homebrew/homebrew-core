require "language/node"

class Svgo < Formula
  desc "Nodejs-based tool for optimizing SVG vector graphics files"
  homepage "https://github.com/svg/svgo"
  url "https://github.com/svg/svgo/archive/v2.4.0.tar.gz"
  sha256 "bd1e611295cd851015a1e27f3814b18c1275b77ecc2132fb5bc776c163619ca4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7d90d4b6d709987731d1552fd4d8fbaa3ec6f7ffca8fe9e90d8c8cc497037d80"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    cp test_fixtures("test.svg"), testpath
    system bin/"svgo", "test.svg", "-o", "test.min.svg"
    assert_match(/^<svg /, (testpath/"test.min.svg").read)
  end
end
