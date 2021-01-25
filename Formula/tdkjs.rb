require "language/node"

class Tdkjs < Formula
  desc "Tixte Development Kit"
  homepage "https://tdk.developer.tixte.com/"
  url "https://registry.npmjs.org/tdkjs/-/tdkjs-3.2.0.tgz"
  sha256 "6c0e28b22fdb50b8bfe8d113457d048364e8be7dbe09df84dbf4135a5a0c0665"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4de478f9836d71f03230b6ca3f5926e374359989f64c2c9b662b89dd1fc2ae79" => :big_sur
    sha256 "43f5d7c2bf9b903b1fea73e50a26fbd42757e3434f0dc9f80b652a49c89ba1a3" => :arm64_big_sur
    sha256 "d59d6292d1982f2bfb6fac6f3e25d638b131b2ad9c36598ef5ad5ee4f5eb76e3" => :catalina
    sha256 "9edeabf99f8d427626ee1500981ed3bb3738be523abcfa600457588afca605c7" => :mojave
    sha256 "09ace9b6ab20a91e582b8d95ba05abe45b046231cb457cf87c7d2704352778f8" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "printf", "'''tdk.init()\ntdk.setColor(\'red\')\nfunction animate(){\ntdk.circle(0, 0, 20)\n}''' > test.js"
    system "tdkjs", "test.js", "output.html"
  end
end
