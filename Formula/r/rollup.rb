class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.63.4.tgz"
  sha256 "aac827efcca56aaacbfc4f24fb4ba9df85a654417250627cd5f9616694f6ef51"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "9b61f36acc74cc3f826c267cf7efa22b84a74de824c40bc7a0206eaf2e70fc41"
    sha256 cellar: :any,                 arm64_tahoe:       "9b61f36acc74cc3f826c267cf7efa22b84a74de824c40bc7a0206eaf2e70fc41"
    sha256 cellar: :any,                 arm64_sequoia:     "9b61f36acc74cc3f826c267cf7efa22b84a74de824c40bc7a0206eaf2e70fc41"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c6810a6dfef25ccdd28d2de9c785b9c0a23bb975c64ae8d5d0394e868dd3ba58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5b562c143cd7c989af9d083f5878da0a14ccf77117582be031ffcd0cc033f084"
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
