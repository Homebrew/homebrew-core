require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.17.2.tgz"
  sha256 "80de55ea230314cd82f48e7231ec7009b52c10585393fbe81c5c9d5107d556e5"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e79deb6d33b8c96b0d832c2f9979be9c78afd0509e8662bd5d72b5a89c19a4b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e79deb6d33b8c96b0d832c2f9979be9c78afd0509e8662bd5d72b5a89c19a4b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e79deb6d33b8c96b0d832c2f9979be9c78afd0509e8662bd5d72b5a89c19a4b8"
    sha256 cellar: :any_skip_relocation, ventura:        "d621391a398df67288ea223559d867201228940cebe89083babb8d5deec0de7e"
    sha256 cellar: :any_skip_relocation, monterey:       "d621391a398df67288ea223559d867201228940cebe89083babb8d5deec0de7e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d621391a398df67288ea223559d867201228940cebe89083babb8d5deec0de7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c661620d73427eec54b8c8fef5d4ae363cd3ea8b82aa738dd4903d3f4063201"
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
