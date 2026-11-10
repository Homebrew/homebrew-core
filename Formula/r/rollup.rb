class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.68.2.tgz"
  sha256 "f08039f7cc75ec05aea1106e9deeb550e69509d228c7865a649cb4a2ad531120"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "ef8afbf94fb2bc4070befba8412e49be707a5119d021f7427868040f3f6203d3"
    sha256 cellar: :any,                 arm64_tahoe:       "ef8afbf94fb2bc4070befba8412e49be707a5119d021f7427868040f3f6203d3"
    sha256 cellar: :any,                 arm64_sequoia:     "ef8afbf94fb2bc4070befba8412e49be707a5119d021f7427868040f3f6203d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "046b7e86fac1bdd11761fc25b9b754d66053f973a7502bf3bd14b41deed694e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b13b216f6bb505e197b30fe8b7aa86348b3d47c044b6f273f290bf8bfa085f54"
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
