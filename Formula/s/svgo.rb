require "language/node"

class Svgo < Formula
  desc "Nodejs-based tool for optimizing SVG vector graphics files"
  homepage "https://github.com/svg/svgo"
  url "https://github.com/svg/svgo/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "e121c5b27c00d0f52bc3dbb68ea23d695ed6a1ef9cea97931c39bd991eb95f8c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "41922841b0706d87ce668d8bd6e7ddf05fb6998b2b90c9dae5f62e37353985df"
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
