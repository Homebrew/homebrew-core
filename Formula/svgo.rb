require "language/node"

class Svgo < Formula
  desc "Nodejs-based tool for optimizing SVG vector graphics files"
  homepage "https://github.com/svg/svgo"
  url "https://github.com/svg/svgo/archive/v1.1.1.tar.gz"
  sha256 "9eaf72ce0b15e7643c2f3003c83358da41baa87c1dc81f9976c47e0fcde5cc5e"

  bottle do
    cellar :any_skip_relocation
    sha256 "56dd992871e910b590cef6facabc033b1737d7ec12a8cc366a491ddcc9e7b338" => :mojave
    sha256 "33251a1558bc0d5479d49189d1dd3d9dd27af77d0a4e03d97f8f905cda2bfd72" => :high_sierra
    sha256 "5553d5bca19b519bfaed0edf43f33839371983b7b9840d4804a51a365281eca1" => :sierra
    sha256 "b255cdc0b1d51ddf9103fd3bc2e527c7556715c91c6e79f65806b3b6bbe475ef" => :el_capitan
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
