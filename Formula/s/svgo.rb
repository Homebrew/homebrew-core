class Svgo < Formula
  desc "Nodejs-based tool for optimizing SVG vector graphics files"
  homepage "https://svgo.dev/"
  url "https://github.com/svg/svgo/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "8c9d43624e108eab29e369fdca68ea160e57b37a364907b499b5d6a4436cb59b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5351c22c31e538f311094815088539fbb18b4ee409b5de0ae5ff8bed40279242"
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
