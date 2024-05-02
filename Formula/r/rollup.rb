require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.17.2.tgz"
  sha256 "7a6b38a551da8bbe252cfcb155fdd4426b2531633bd455d62b8343a32f316353"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6ad40a2490d48b7b0078c1c5a76945d2ed60677e0b7ceadf0d202c9d4b5dad6a"
    sha256 cellar: :any,                 arm64_ventura:  "6ad40a2490d48b7b0078c1c5a76945d2ed60677e0b7ceadf0d202c9d4b5dad6a"
    sha256 cellar: :any,                 arm64_monterey: "6ad40a2490d48b7b0078c1c5a76945d2ed60677e0b7ceadf0d202c9d4b5dad6a"
    sha256 cellar: :any,                 sonoma:         "f9a5b8e17e184b296446ff3a6538e3de9df1d482853126f61773a5c0ab5066eb"
    sha256 cellar: :any,                 ventura:        "f9a5b8e17e184b296446ff3a6538e3de9df1d482853126f61773a5c0ab5066eb"
    sha256 cellar: :any,                 monterey:       "f9a5b8e17e184b296446ff3a6538e3de9df1d482853126f61773a5c0ab5066eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7825cd4d526bcb52598ef0f1fdfa4150ca741af094d8860da64a4c3fd3f8802f"
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
