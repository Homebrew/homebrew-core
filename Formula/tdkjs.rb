require "language/node"

class Tdkjs < Formula
  desc "The TDK lets Tixte Developers Write Fast, Clean, and Human Readable Code"
  homepage "https://tdk.developer.tixte.com/"
  url "https://registry.npmjs.org/tdkjs/-/tdkjs-3.2.0.tgz"
  sha256 "6c0e28b22fdb50b8bfe8d113457d048364e8be7dbe09df84dbf4135a5a0c0665"

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
