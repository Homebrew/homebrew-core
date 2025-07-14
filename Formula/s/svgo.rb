class Svgo < Formula
  desc "Nodejs-based tool for optimizing SVG vector graphics files"
  homepage "https://svgo.dev/"
  url "https://github.com/svg/svgo/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "dabd71f420d29747e8a10b15c4fafff7477ff2de2846c20f8e84de3bc093adaf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ec0f78a0a81069dcd687212bb5afc0a980197b1f762d35a47ec58f4c2a416473"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    cp test_fixtures("test.svg"), testpath
    system bin/"svgo", "test.svg", "-o", "test.min.svg"
    assert_match(/^<svg /, (testpath/"test.min.svg").read)
  end
end
