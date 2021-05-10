require "language/node"

class Svgo < Formula
  desc "Nodejs-based tool for optimizing SVG vector graphics files"
  homepage "https://github.com/svg/svgo"
  url "https://github.com/svg/svgo/archive/v2.3.0.tar.gz"
  sha256 "0c22647a9fba0cf80ffb5fb15e55401d62eace98a993348ee485cd8ffd4f410b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "abdbb490e21ec5540881fb2e52025560b870d21d76ce78a6e71358200fe72000"
    sha256 cellar: :any_skip_relocation, big_sur:       "df7af8e4c6d010ca928f04d14ce34abbe08b1b8249ba42ffc301f6067356e123"
    sha256 cellar: :any_skip_relocation, catalina:      "48a66950681297bed8bf89dbcfeab2c34147784bccdd5ac92f5664b73f530457"
    sha256 cellar: :any_skip_relocation, mojave:        "631a5e5bf726f9f3a2c53ddfc7fd5061953bf905208972091c77ea7a10e41599"
    sha256 cellar: :any_skip_relocation, high_sierra:   "5fe6407fa998ce2431d435e24bd565332d939b680fb624ddbfd5ad2316799305"
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
