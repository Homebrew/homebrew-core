class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.67.2.tgz"
  sha256 "8fb8315cf8fdd65c168ac8170cd9d2431c0a0d10593e5e5495c340076bbfc4a2"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "93b9325b984588a1677fde7024761b69ada4b583c9007229a7c788f1f1a43c36"
    sha256 cellar: :any,                 arm64_tahoe:       "93b9325b984588a1677fde7024761b69ada4b583c9007229a7c788f1f1a43c36"
    sha256 cellar: :any,                 arm64_sequoia:     "93b9325b984588a1677fde7024761b69ada4b583c9007229a7c788f1f1a43c36"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9d04c60e48fd0c9cd60ae809ed8396f6414dbcbc6227b4b910194cb14e8004c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a3630ac8d51618951d23087963879a965148d5d8fb3f42b11325a377af45bb23"
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
