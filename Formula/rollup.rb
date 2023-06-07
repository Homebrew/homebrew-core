require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.24.0.tgz"
  sha256 "5da9a2c3726b143843beade173abc95fd2321471d975464383478321029e5ebc"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73eac0c38a79210d4f7165eca8a04e98416f1699bf60f218e507bb4f872817b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73eac0c38a79210d4f7165eca8a04e98416f1699bf60f218e507bb4f872817b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73eac0c38a79210d4f7165eca8a04e98416f1699bf60f218e507bb4f872817b1"
    sha256 cellar: :any_skip_relocation, ventura:        "4a077ef8b19b070bef541f594c8ba0b83044781425fc7c8d5cde9098b1ed7d07"
    sha256 cellar: :any_skip_relocation, monterey:       "4a077ef8b19b070bef541f594c8ba0b83044781425fc7c8d5cde9098b1ed7d07"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a077ef8b19b070bef541f594c8ba0b83044781425fc7c8d5cde9098b1ed7d07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6865c451ad9f5652f53805df5529519c2e44841996c04f0ea6e7b4224fa9c2ac"
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
