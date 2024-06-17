require "language/node"

class Svgo < Formula
  desc "Nodejs-based tool for optimizing SVG vector graphics files"
  homepage "https://github.com/svg/svgo"
  url "https://github.com/svg/svgo/archive/refs/tags/v3.3.2.tar.gz"
  sha256 "bf79f18acd85764bd12ed7335f2d8fdc7d11760e7c4ed8bd0dc39f1272825671"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "997bdea1555ce56b4af7d5625ddef78a3653143f29a4f9f1ddc74025889a8f05"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f775ef89b2f0cc9b6ed05a0c0bbf8dae7dc012441c9f7a2fe4463aeb71de6712"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "995ef55373fa12452f5a12bcc93f1456e1dfb91925ef2ebc61444ef79480a0ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "441ee23a5c71c64a1b6cd24695cfd721c66cb1cd6076fc5a3b2677e0a04ecc69"
    sha256 cellar: :any_skip_relocation, ventura:        "48dad74504f73b434c60fceada41d8299b1560520e4f09209a25d503f050c689"
    sha256 cellar: :any_skip_relocation, monterey:       "07941cf1f74d0aba4723d32aba2f87b8b785efcf53bc3f1bf060371673c3bfbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f83cba0d234e7c703b59cbc60b4e36ed3b6b072e18fc623093fac142c58305a6"
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
