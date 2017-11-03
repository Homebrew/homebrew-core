require "language/node"

class Svgo < Formula
  desc "Nodejs-based tool for optimizing SVG vector graphics files"
  homepage "https://github.com/svg/svgo"
  url "https://github.com/svg/svgo/archive/v1.0.2.tar.gz"
  sha256 "1f1de2220f2f50b9307d04a344dc56b7de9f2eca12dfa2f849800d6c98466d42"

  bottle do
    cellar :any_skip_relocation
    sha256 "517da44d06d29d397b2973f32622744663766a8a09a9ee664227d7b1d61bf5cf" => :high_sierra
    sha256 "dd20753e218c3254e91c4a48de1ab1e8dd6de48e78fe27f75b78c0befb15ab38" => :sierra
    sha256 "dc1027305d5b3af2b89e326f739caf954f59237e59c435d7f6d168f8e39afc86" => :el_capitan
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
