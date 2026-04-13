class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.60.1.tgz"
  sha256 "b8996e688ff1542e8aa7f0d07a11a06e58fec2a5ae6fc01c73ef1550b27e0127"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a630fa508c95250677afeaadf0821ca95ae8914f46332b01fb2601e0de24d877"
    sha256 cellar: :any,                 arm64_sequoia: "d1a340565032d66690a26d72e4b8259ebcef07c78663a68a23ba19cb4aca57e5"
    sha256 cellar: :any,                 arm64_sonoma:  "d1a340565032d66690a26d72e4b8259ebcef07c78663a68a23ba19cb4aca57e5"
    sha256 cellar: :any,                 sonoma:        "efdc23118e932a4a4b9955e983cb602b95c0a76a1ab10affaff19cbbd3c02fc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da92429101f50232a2a9dfc3656ad93252dc6b2110001baa91edb7105c898e0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2034c0a711fef988b461139146e54b9f5bdb0fa9cdfdb6507e21bcf6c364547a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Replace universal binaries with their native slices
    node_modules = libexec/"lib/node_modules/rollup/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node"
  end

  test do
    (testpath/"test/main.js").write <<~JS
      import foo from './foo.js';
      export default function () {
        console.log(foo);
      }
    JS

    (testpath/"test/foo.js").write <<~JS
      export default 'hello world!';
    JS

    expected = <<~JS
      'use strict';

      var foo = 'hello world!';

      function main () {
        console.log(foo);
      }

      module.exports = main;
    JS

    assert_equal expected, shell_output("#{bin}/rollup #{testpath}/test/main.js -f cjs")
  end
end
