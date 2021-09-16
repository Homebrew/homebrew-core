require "language/node"

class Svgo < Formula
  desc "Nodejs-based tool for optimizing SVG vector graphics files"
  homepage "https://github.com/svg/svgo"
  url "https://github.com/svg/svgo/archive/v2.6.1.tar.gz"
  sha256 "407e75c7d616df5f1382b6cf27164a59726658f5b8426a1fb4efa12632ae091e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ff8067529ac3a87a3c6b9720cad22a71b7177c42f53874ce485ab6aa9f06649f"
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
