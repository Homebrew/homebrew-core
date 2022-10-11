require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.0.0.tgz"
  sha256 "d43e54465996ab150abf8ed55069fee5c4fd90a2a3524b70ed7a8ad8a2c6d3e0"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4bbd1550678960ba21d1c72396f43bae8ac63a4784cb387e3a1f7c127106580b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4bbd1550678960ba21d1c72396f43bae8ac63a4784cb387e3a1f7c127106580b"
    sha256 cellar: :any_skip_relocation, monterey:       "1c3d34fb52b8c066378935e093192e9e94ae9a671b15f444c46bcea8f6f1f3b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c3d34fb52b8c066378935e093192e9e94ae9a671b15f444c46bcea8f6f1f3b7"
    sha256 cellar: :any_skip_relocation, catalina:       "1c3d34fb52b8c066378935e093192e9e94ae9a671b15f444c46bcea8f6f1f3b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eff29d478ea48a3ba26b515894989cb80691da9a868e5a55bc2ae7e07daa6b80"
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
