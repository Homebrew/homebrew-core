require "language/node"

class Svgo < Formula
  desc "Nodejs-based tool for optimizing SVG vector graphics files"
  homepage "https://github.com/svg/svgo"
  url "https://github.com/svg/svgo/archive/v2.8.0.tar.gz"
  sha256 "481f48ca2e3fd158bba6cb733308337fd9e895667db9e1264ed91181e476ff61"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "53ff19006e1dc04a0b78cb4f13ed14f621ce8d232df10a156b035172c98a560a"
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
