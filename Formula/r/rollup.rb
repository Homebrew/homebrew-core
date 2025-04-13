class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.40.0.tgz"
  sha256 "c25de66498beddeb3dec3fb9511b88c79b2b9e53c37763a12f46ce2b46387580"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d7ffc1b40946bd3fa2d38f6dca297be124056e58bfaf52b8543b72540a58ca94"
    sha256 cellar: :any,                 arm64_sonoma:  "d7ffc1b40946bd3fa2d38f6dca297be124056e58bfaf52b8543b72540a58ca94"
    sha256 cellar: :any,                 arm64_ventura: "d7ffc1b40946bd3fa2d38f6dca297be124056e58bfaf52b8543b72540a58ca94"
    sha256 cellar: :any,                 sonoma:        "9f76db576f4a9e785b853f9e37f285f5da7e1c008d1936774e8bdeafb9903c40"
    sha256 cellar: :any,                 ventura:       "9f76db576f4a9e785b853f9e37f285f5da7e1c008d1936774e8bdeafb9903c40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29c4e4474e316a19270fbb839d98e963dab302c68064530bedb74b653032631b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edae71106c74709d9008b016433917eb9891f46659ba27abeff63751c538ccd1"
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
