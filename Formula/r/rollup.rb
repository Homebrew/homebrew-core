require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.12.0.tgz"
  sha256 "98177634601ccdd5b2cd160886ffc29c5e792c3a83871cb0542fd1b74ce726e0"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "71518529be800aa98a81e8ef149b3c05af01f8f50f43806cf0efdc98a3c981ef"
    sha256 cellar: :any,                 arm64_ventura:  "71518529be800aa98a81e8ef149b3c05af01f8f50f43806cf0efdc98a3c981ef"
    sha256 cellar: :any,                 arm64_monterey: "71518529be800aa98a81e8ef149b3c05af01f8f50f43806cf0efdc98a3c981ef"
    sha256 cellar: :any,                 sonoma:         "146b5e72b9ee7c252517b39e4cfa81f2844edab050f171692390f79e71fdc2e2"
    sha256 cellar: :any,                 ventura:        "146b5e72b9ee7c252517b39e4cfa81f2844edab050f171692390f79e71fdc2e2"
    sha256 cellar: :any,                 monterey:       "146b5e72b9ee7c252517b39e4cfa81f2844edab050f171692390f79e71fdc2e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0efe1e4317c020e84a75b25cfb8e4af9b285f1d868b3b5a6e137b402598a761"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec/"lib/node_modules/rollup/node_modules"
    (node_modules/"@rollup/rollup-linux-x64-musl/rollup.linux-x64-musl.node").unlink if OS.linux?

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
