require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.58.0.tgz"
  sha256 "8377f0d2563e4660302b99435758328a363d9c4d9103398595cd720ca47f3dca"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "617bfc7501e8c60ef651635ffc627f483468dfa2f6306f287081c32d471db170"
    sha256 cellar: :any_skip_relocation, big_sur:       "f4e32e70cdbda7e2ff7adf70ef59fe57e2b239caf9e324679b3e210c61d8044c"
    sha256 cellar: :any_skip_relocation, catalina:      "f4e32e70cdbda7e2ff7adf70ef59fe57e2b239caf9e324679b3e210c61d8044c"
    sha256 cellar: :any_skip_relocation, mojave:        "f4e32e70cdbda7e2ff7adf70ef59fe57e2b239caf9e324679b3e210c61d8044c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98e42ae04d8aa15dcde7707070074341ae2cfcc847819126b2e64013cd081d8b"
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
