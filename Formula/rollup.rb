require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.21.5.tgz"
  sha256 "2f8f5e9ffc974ae29c17fd9f1d0cc71be8250a93b3500d241700a246a4b6fd85"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1667d1305ea5ca97e504d7e9bf2bb3d74baccc064352a66a63e3c4e7e0f662c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1667d1305ea5ca97e504d7e9bf2bb3d74baccc064352a66a63e3c4e7e0f662c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1667d1305ea5ca97e504d7e9bf2bb3d74baccc064352a66a63e3c4e7e0f662c"
    sha256 cellar: :any_skip_relocation, ventura:        "e81479669aec13f66b4d3222278aeb5576298120865880c2dd707b02f0571f31"
    sha256 cellar: :any_skip_relocation, monterey:       "e81479669aec13f66b4d3222278aeb5576298120865880c2dd707b02f0571f31"
    sha256 cellar: :any_skip_relocation, big_sur:        "e81479669aec13f66b4d3222278aeb5576298120865880c2dd707b02f0571f31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e06522b81d3a2f176ea7e7cf6fe396eca83c2cb4903f249ee0c01bede84fa7f8"
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
