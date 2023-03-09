require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.19.0.tgz"
  sha256 "3fd5b528e34cc206e19bf87865a4a83010d49a9c8e5177fffa4c15120dc8859b"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c063cc1476eeb6d204e0f7a7ccb124f591e666c09ab861b0ce98afc439bd3d57"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c063cc1476eeb6d204e0f7a7ccb124f591e666c09ab861b0ce98afc439bd3d57"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c063cc1476eeb6d204e0f7a7ccb124f591e666c09ab861b0ce98afc439bd3d57"
    sha256 cellar: :any_skip_relocation, ventura:        "3b27d8ce82d99aee71ac6c117d68bcb9ec90174f91fbb9accd735503addb97d7"
    sha256 cellar: :any_skip_relocation, monterey:       "3b27d8ce82d99aee71ac6c117d68bcb9ec90174f91fbb9accd735503addb97d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b27d8ce82d99aee71ac6c117d68bcb9ec90174f91fbb9accd735503addb97d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c97424bd24de3ee754e5718ae8f1b9d062c207f6586b87f8878b52b5d3eb6903"
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
