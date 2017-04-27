require "language/node"

class Svgo < Formula
  desc "Nodejs-based tool for optimizing SVG vector graphics files"
  homepage "https://github.com/svg/svgo"
  url "https://github.com/svg/svgo/archive/v0.7.2.tar.gz"
  sha256 "93b36477366e6b48b9bc3f9086232ae7fc16b87fa36acc1d524720ea58123fcf"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    cp test_fixtures("test.svg"), testpath
    system bin/"svgo", "test.svg", "test.min.svg"
    assert_match /^<svg /, (testpath/"test.min.svg").read
  end
end
