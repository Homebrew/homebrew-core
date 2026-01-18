class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.55.1.tgz"
  sha256 "e713356132bd5cef1ff664c4bbe2c2c2f327aa49f139b14f288d81f1c4ee8beb"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4b2900e43b8c189109a4e5fdd072f142d6614b2a54c03b1c07d68bc597045dee"
    sha256 cellar: :any,                 arm64_sequoia: "d49819aade2e48465df3ca7ff76c5b97f85dfeb6aa38a4f0d2ae89cd54a9f592"
    sha256 cellar: :any,                 arm64_sonoma:  "d49819aade2e48465df3ca7ff76c5b97f85dfeb6aa38a4f0d2ae89cd54a9f592"
    sha256 cellar: :any,                 sonoma:        "709441bf765878fbfb17a1e54aaef387b73f6bcc5845667e2f3884caf4133644"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cefc5af98eda83ae6111e76f29923e7779f47a99a46a3b1a64afb3eb31704d47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "136d48c797387766edae28715441b910ddf8db684fc07dbaf16e41cf549db385"
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
