class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.28.1.tgz"
  sha256 "71a4260c090107cf495f09a4696f17602dc627be8f691a61e2aea07205c0da71"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "815768f12a2fdc90ed036f00d32b7455da96bacba573470af644f07f9b395992"
    sha256 cellar: :any,                 arm64_sonoma:  "815768f12a2fdc90ed036f00d32b7455da96bacba573470af644f07f9b395992"
    sha256 cellar: :any,                 arm64_ventura: "815768f12a2fdc90ed036f00d32b7455da96bacba573470af644f07f9b395992"
    sha256 cellar: :any,                 sonoma:        "116352c0dd8add8ee59b2d3e89e4c09c1ef86e7afbddd38b00d8940c9c08914f"
    sha256 cellar: :any,                 ventura:       "116352c0dd8add8ee59b2d3e89e4c09c1ef86e7afbddd38b00d8940c9c08914f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0885f823df80f89ce941615853ca0315e08d62ccecf7fe0191ce355811422292"
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
