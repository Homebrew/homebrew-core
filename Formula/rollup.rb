require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.16.0.tgz"
  sha256 "56202298cc637c6667e3f2bf21e12982fb9c503b0df96372089b616525efcb24"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07ad21ede68300942a2266a36c9f3994decf33a629e950e8f6b52640cde2900f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11bf194d81dab76ffc6407615e344a4674e820f346754fab262320cdd709191c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42d7a043bd9587a405df085721ce766bce28fd3a0482a4ca1facc7b48ed645c9"
    sha256 cellar: :any_skip_relocation, ventura:        "72db511ba39d2c9e19a88c06ebe647ba109893579c4cc8b1d157b3c96515147c"
    sha256 cellar: :any_skip_relocation, monterey:       "7889a832498e68fa167231a72240754984ef94f06d27e094140b4d4751ff9c8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "0dea70a2d2750f52108f7a6e2e697ae21fdd4df78266af84e4b701ec9703dcf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51d22fd799e63794951cc4d7d62864f25893be4b5df8d252c1b9ca78b1e98dfc"
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
