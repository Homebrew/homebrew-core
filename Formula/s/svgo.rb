class Svgo < Formula
  desc "Nodejs-based tool for optimizing SVG vector graphics files"
  homepage "https://svgo.dev/"
  url "https://github.com/svg/svgo/archive/refs/tags/v4.0.2.tar.gz"
  sha256 "f83f6d0ab9c12b7773683b78c203c18e52aa7a8f3f0ea0cb59fbbacb4dbf21fa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5b6aa7e3a85ff54e31cf22afb49459d90e35ff979381e7b622c8d409f556df21"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    cp test_fixtures("test.svg"), testpath
    system bin/"svgo", "test.svg", "-o", "test.min.svg"
    assert_match(/^<svg /, (testpath/"test.min.svg").read)
  end
end
