require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.9.0.tgz"
  sha256 "2966ae2b8177b048342c3ee23b3ba2a894d8e7de043c153e0b50851af75c2ebc"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abc90fee5ec5591cb99a9e978b60b93da96f35c937690a583887148fc3bad447"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abc90fee5ec5591cb99a9e978b60b93da96f35c937690a583887148fc3bad447"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abc90fee5ec5591cb99a9e978b60b93da96f35c937690a583887148fc3bad447"
    sha256 cellar: :any_skip_relocation, ventura:        "2b2196bf39db14b32278e776397d0c7f0478ea8e135476dba18c683351173e70"
    sha256 cellar: :any_skip_relocation, monterey:       "2b2196bf39db14b32278e776397d0c7f0478ea8e135476dba18c683351173e70"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b2196bf39db14b32278e776397d0c7f0478ea8e135476dba18c683351173e70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f78c3196e94f15bc8b03e0169a7c8ad3a53837fd0557e6cd4806c78a2780f7b"
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
