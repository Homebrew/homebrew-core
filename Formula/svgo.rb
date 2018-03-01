require "language/node"

class Svgo < Formula
  desc "Nodejs-based tool for optimizing SVG vector graphics files"
  homepage "https://github.com/svg/svgo"
  url "https://github.com/svg/svgo/archive/v1.0.5.tar.gz"
  sha256 "7b0a3ce0308ea6bead17dcb22a2a1195f4bf1b44c1f7ebf3462eb0c51a827139"

  bottle do
    cellar :any_skip_relocation
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
