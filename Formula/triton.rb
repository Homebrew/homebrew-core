require "language/node"

class Triton < Formula
  desc "Joyent Triton CLI"
  homepage "https://www.npmjs.com/package/triton"
  url "https://registry.npmjs.org/triton/-/triton-7.0.1.tgz"
  sha256 "9a857aade94c45edb4b1bba212a103c591bf1cde6b3f2cad1a9f85bd7d0471e9"

  bottle do
    sha256 "8076f9d3e55399ba25ab931a19518189d5cd6e01241171140b3a42a97e98c4ae" => :mojave
    sha256 "636d290a02708b0da5bd5253255992577582f7f302c1525646a05dd12106e189" => :high_sierra
    sha256 "6c50d2c6a7afa147faf8933c7ab6eefcede05a12aadcc5060b58b0883d0f8089" => :sierra
    sha256 "b0aa58088e9ae79da67cfcb9c277116b53906e1a528629edb8350c797976568d" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/triton profile ls")
    assert_match /\ANAME  CURR  ACCOUNT  USER  URL$/, output
  end
end
