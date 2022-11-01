require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.2.5.tgz"
  sha256 "1d1e479e9f58696aa131bde2df985b08660e5f25b3fb80d54f95f35bd33f1526"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbd6372785a85aee83151228c965b7cf32ace898c856371bd75cd685d17b9633"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbd6372785a85aee83151228c965b7cf32ace898c856371bd75cd685d17b9633"
    sha256 cellar: :any_skip_relocation, monterey:       "30b3bda80e7072ae36dc9e4b35f58e79c787f1004d103da0370ed32dd586569b"
    sha256 cellar: :any_skip_relocation, big_sur:        "30b3bda80e7072ae36dc9e4b35f58e79c787f1004d103da0370ed32dd586569b"
    sha256 cellar: :any_skip_relocation, catalina:       "30b3bda80e7072ae36dc9e4b35f58e79c787f1004d103da0370ed32dd586569b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afbcbf37401c66cb81f9ce2a301f91c99e4afb37a5625616b787ae86a89eecca"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    deuniversalize_machos
  end

  test do
    (testpath/"test/main.js").write <<~EOS
      import foo from './foo.js';
      export default function () {
        console.log(foo);
      }
    EOS

    (testpath/"test/foo.js").write <<~EOS
      export default 'hello world!';
    EOS

    expected = <<~EOS
      'use strict';

      var foo = 'hello world!';

      function main () {
        console.log(foo);
      }

      module.exports = main;
    EOS

    assert_equal expected, shell_output("#{bin}/rollup #{testpath}/test/main.js -f cjs")
  end
end
