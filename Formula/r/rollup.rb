class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.52.3.tgz"
  sha256 "5ed2919009b035fd39cebab1f4f317460d49d47c18dee4224518bf010e32a6aa"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f19f6846a99a6c17f8158c4f37159855606d8c55bd8ae58652a7afdee9fd4380"
    sha256 cellar: :any,                 arm64_sequoia: "53c4c61917f585d9f4fdde443c30c8896a0c28dc9137e29c0c71d0df84502f7a"
    sha256 cellar: :any,                 arm64_sonoma:  "53c4c61917f585d9f4fdde443c30c8896a0c28dc9137e29c0c71d0df84502f7a"
    sha256 cellar: :any,                 sonoma:        "c4b1cb20ba8263e0249dbea4d8b892bb56e9ba8faf0b4646fc1e1590f7d31f72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d964467dd92fab73bacdb57825172063330b7a4935e209374f18d8157a9cdfeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8ba5eb3b2a2fe77f502445ad780835f212b88bd85109c5d0d8a0378479dfb03"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
