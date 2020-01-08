require "language/node"

class Svgo < Formula
  desc "Nodejs-based tool for optimizing SVG vector graphics files"
  homepage "https://github.com/svg/svgo"
  url "https://github.com/svg/svgo/archive/v1.3.2.tar.gz"
  sha256 "b1e65808957d5eaa07173f1729a9fe04d985a3a50da01fa2cc85583f7b27df59"

  bottle do
    cellar :any_skip_relocation
    sha256 "48a66950681297bed8bf89dbcfeab2c34147784bccdd5ac92f5664b73f530457" => :catalina
    sha256 "631a5e5bf726f9f3a2c53ddfc7fd5061953bf905208972091c77ea7a10e41599" => :mojave
    sha256 "5fe6407fa998ce2431d435e24bd565332d939b680fb624ddbfd5ad2316799305" => :high_sierra
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
