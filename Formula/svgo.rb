require "language/node"

class Svgo < Formula
  desc "Nodejs-based tool for optimizing SVG vector graphics files"
  homepage "https://github.com/svg/svgo"
  url "https://github.com/svg/svgo/archive/v1.1.1.tar.gz"
  sha256 "9eaf72ce0b15e7643c2f3003c83358da41baa87c1dc81f9976c47e0fcde5cc5e"

  bottle do
    cellar :any_skip_relocation
    sha256 "551bf258d6507d2f0f59929340540648411fe3dc67053949067c197f54edd3e0" => :mojave
    sha256 "08d0632b31fbbb8c18b924f3a1266c193ba41c142ab46fac04f01d63be0cbb75" => :high_sierra
    sha256 "39c7140696f44623b74d8f81cf8ed4ee8779cea21eca70d35d87d0031b94ca7b" => :sierra
    sha256 "bc141b8dbcd54137fe0bb83719fb2816d7a8e0d7cc7fbeeb5332fea861380c79" => :el_capitan
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
