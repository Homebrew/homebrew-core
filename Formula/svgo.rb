require "language/node"

class Svgo < Formula
  desc "Nodejs-based tool for optimizing SVG vector graphics files"
  homepage "https://github.com/svg/svgo"
  url "https://github.com/svg/svgo/archive/v2.5.0.tar.gz"
  sha256 "a3cb6e095c43a21ea2317f00e48b10b41ad729b96bf11c1846a3d3b25dc527e0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "67398482ddb88f63a3dcb29db1c5e06b918c8ba6acfc6d05257a0c19a1d285be"
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
