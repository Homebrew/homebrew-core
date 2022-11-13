require "language/node"

class Svgo < Formula
  desc "Nodejs-based tool for optimizing SVG vector graphics files"
  homepage "https://github.com/svg/svgo"
  url "https://github.com/svg/svgo/archive/v3.0.1.tar.gz"
  sha256 "ef503815522b6e5ea133f2baf394edebb9d881bab79f29d339c9f3468fa69a02"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "55b7cca8c2dd5a82b85c784ab338577895e0e312a922fd5cdd9213cd562cc2bd"
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
