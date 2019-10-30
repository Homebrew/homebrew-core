require "language/node"

class Svgo < Formula
  desc "Nodejs-based tool for optimizing SVG vector graphics files"
  homepage "https://github.com/svg/svgo"
  url "https://github.com/svg/svgo/archive/v1.3.2.tar.gz"
  sha256 "b1e65808957d5eaa07173f1729a9fe04d985a3a50da01fa2cc85583f7b27df59"

  bottle do
    cellar :any_skip_relocation
    sha256 "1e53fffd3bacf1f66295e8aa1fdf4316fcb6a4183d72da07d35084aa1d591b90" => :catalina
    sha256 "862d1f99485c687499445b72655ccc33cd0b0438f5f98e258bed6fb8a56b281a" => :mojave
    sha256 "6619af1d5bbe0b8a0100b105e8387d158c6d04c847feb03cc4dd05e7747b08da" => :high_sierra
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
