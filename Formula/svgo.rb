require "language/node"

class Svgo < Formula
  desc "Nodejs-based tool for optimizing SVG vector graphics files"
  homepage "https://github.com/svg/svgo"
  url "https://github.com/svg/svgo/archive/v1.0.3.tar.gz"
  sha256 "e6ddea3af2322ef41f884e768e976543e4a4d6aa7c371efc71e36c4ed0e7f568"

  bottle do
    cellar :any_skip_relocation
    sha256 "e18b1d92ed76b373d45331cbbe13889ba4dd93a4e98e196136790e2176208a1c" => :high_sierra
    sha256 "9be67362766f22081a510c174ac264680063f9789c97924443df173dbce0abc6" => :sierra
    sha256 "df12ec11fb4dc610eba368fee7e872edcfeecc7a2dee4f5a02fdc49fa093e17b" => :el_capitan
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
