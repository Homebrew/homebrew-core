require "language/node"

class Svgo < Formula
  desc "Nodejs-based tool for optimizing SVG vector graphics files"
  homepage "https://github.com/svg/svgo"
  url "https://github.com/svg/svgo/archive/v1.3.0.tar.gz"
  sha256 "ee45023a0f84a7e326965f2a7f9b698fcc4e2518277be1ebec9186aeac4a2aad"

  bottle do
    cellar :any_skip_relocation
    sha256 "03e7f05bdf23d6f2d5ca2582f238d87a9e0d1a30b16a6ef9f076d8522ac2d814" => :mojave
    sha256 "7289fa9ff788b90a54c0366c5caa9bc14034fde631e1c45b625b6b81e0d1de3c" => :high_sierra
    sha256 "537153ae152735bba011228bfd8c3ea680ca9a2acfb79236e6b445835c71b2ba" => :sierra
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
