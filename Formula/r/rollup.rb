class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.45.0.tgz"
  sha256 "c23a757e3cf510cc3ee2ca79e803ddbe8fcb072dfa312d19326f9b2cb2256f56"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1581b271e9651cc7218475b1cc0f94dc168462bbf402db1c0306229c9bd820df"
    sha256 cellar: :any,                 arm64_sonoma:  "1581b271e9651cc7218475b1cc0f94dc168462bbf402db1c0306229c9bd820df"
    sha256 cellar: :any,                 arm64_ventura: "1581b271e9651cc7218475b1cc0f94dc168462bbf402db1c0306229c9bd820df"
    sha256 cellar: :any,                 sonoma:        "7df4f08c5e350155fd4ad48ed465111c94fa62a1f76447594501d9abcfc86b85"
    sha256 cellar: :any,                 ventura:       "7df4f08c5e350155fd4ad48ed465111c94fa62a1f76447594501d9abcfc86b85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "560f12ee65c248bc50c4df5408a9f3704acdef1d62190e8aa5d35ff096d4ec69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4c96954597bd9c91cd42cae3dad4fe20863ec651cc87a4289406dbefedfc1d3"
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
