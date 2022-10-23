require "language/node"

class Svgo < Formula
  desc "Nodejs-based tool for optimizing SVG vector graphics files"
  homepage "https://github.com/svg/svgo"
  url "https://github.com/svg/svgo/archive/v3.0.0.tar.gz"
  sha256 "24ff02b7d6413c48f94bfaf81cf251e79f20e453f26fc33dbec620b4dd9de6c3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "005e511a5ff8b56d009f3e7c69f9d7949cbedfc658eb1f4cdef1c61fe7c99d2e"
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
