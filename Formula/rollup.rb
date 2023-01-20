require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.10.1.tgz"
  sha256 "509dceddb2f3110c8320f6bdba7202e916948d49602659c65726febf31b2c276"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4021a70a80825aa2a697785bebf6dd6d5267394dad7618d03cc949c1eddc9d4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4021a70a80825aa2a697785bebf6dd6d5267394dad7618d03cc949c1eddc9d4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4021a70a80825aa2a697785bebf6dd6d5267394dad7618d03cc949c1eddc9d4e"
    sha256 cellar: :any_skip_relocation, ventura:        "f3d2215720e4f951d47195509f341fe32de519eb0ab1f3678cbb8d85fbb071c3"
    sha256 cellar: :any_skip_relocation, monterey:       "f3d2215720e4f951d47195509f341fe32de519eb0ab1f3678cbb8d85fbb071c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3d2215720e4f951d47195509f341fe32de519eb0ab1f3678cbb8d85fbb071c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed3fbc8a5d71b1002062cf8264b4782e6a6f789756a25a624b7441603c028993"
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
