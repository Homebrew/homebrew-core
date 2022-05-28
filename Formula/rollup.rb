require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.75.1.tgz"
  sha256 "122474b7b6d3eced585a589a17e3f185562267786bbcbdb73f736c8b63e8b766"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "412c08e595da50165ba84a14237ba7b9b2223fb38e025acd23ace292b717c7f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "412c08e595da50165ba84a14237ba7b9b2223fb38e025acd23ace292b717c7f0"
    sha256 cellar: :any_skip_relocation, monterey:       "e0d419ec8d915e09deafee4f5687ec8a8ede66093c2a5340ca46460f535c2ff7"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0d419ec8d915e09deafee4f5687ec8a8ede66093c2a5340ca46460f535c2ff7"
    sha256 cellar: :any_skip_relocation, catalina:       "e0d419ec8d915e09deafee4f5687ec8a8ede66093c2a5340ca46460f535c2ff7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bf24ebe4b492485a8399d97fecb75535eb0175e41b48de1ab1878553e40013a"
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
