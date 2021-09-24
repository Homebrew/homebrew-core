require "language/node"

class Svgo < Formula
  desc "Nodejs-based tool for optimizing SVG vector graphics files"
  homepage "https://github.com/svg/svgo"
  url "https://github.com/svg/svgo/archive/v2.7.0.tar.gz"
  sha256 "f264ce02076906497963d4d5166e0f01966d294bae59221928f7a0fc3e6ee793"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "94dc08bba6eaa7ae533440815b257ba8233d79d2ac4d7f685e764c41bd9301fe"
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
