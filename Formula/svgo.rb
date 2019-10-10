require "language/node"

class Svgo < Formula
  desc "Nodejs-based tool for optimizing SVG vector graphics files"
  homepage "https://github.com/svg/svgo"
  url "https://github.com/svg/svgo/archive/v1.3.0.tar.gz"
  sha256 "ee45023a0f84a7e326965f2a7f9b698fcc4e2518277be1ebec9186aeac4a2aad"

  bottle do
    cellar :any_skip_relocation
    sha256 "40115b5e200544fae0e76ddc2fab2057b9ec7eb97603398563c51102b8cfea26" => :catalina
    sha256 "2450cadcc6990d640c6ee60fc3c860d27b269c7abf22f62a330c33bc82450711" => :mojave
    sha256 "6e1d9b95cef7c043b31db6208c9f17eb5792889d8a600ef133b5b4252285a5f4" => :high_sierra
    sha256 "48230545029c5611b8b4051715cf63034fed87d5a3073c6e5a579a529c2f29a1" => :sierra
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
