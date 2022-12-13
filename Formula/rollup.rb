require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.7.4.tgz"
  sha256 "e3a3af57632ad901b1ed9f897bb384f796f03db8ad80f7578d5daf9ea5c1da35"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b6fe6b345af6a999d19de2bda9ea212da297f4871580dcb618d72866ea36c79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b6fe6b345af6a999d19de2bda9ea212da297f4871580dcb618d72866ea36c79"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b6fe6b345af6a999d19de2bda9ea212da297f4871580dcb618d72866ea36c79"
    sha256 cellar: :any_skip_relocation, ventura:        "071abdcc5d3c858c724e5358d991a0299fcbe4d9e81d7f3dbd8e4e6f56ccb35c"
    sha256 cellar: :any_skip_relocation, monterey:       "071abdcc5d3c858c724e5358d991a0299fcbe4d9e81d7f3dbd8e4e6f56ccb35c"
    sha256 cellar: :any_skip_relocation, big_sur:        "071abdcc5d3c858c724e5358d991a0299fcbe4d9e81d7f3dbd8e4e6f56ccb35c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f565805472e2a1ce2d62e936ff09eccb8bf99be9f41e8e6dcd215873983142a"
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
