require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.9.1.tgz"
  sha256 "9bb5d8dd7a6561a078fdd729086eb10febe67f2eb41ef8a8ffcdede85112b8af"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4871f69ff33e34116442383f44af7c6fdde569fbec34c126ad7e71abc052f82e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4871f69ff33e34116442383f44af7c6fdde569fbec34c126ad7e71abc052f82e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4871f69ff33e34116442383f44af7c6fdde569fbec34c126ad7e71abc052f82e"
    sha256 cellar: :any_skip_relocation, ventura:        "1d17de6253bc34cb004f96bb97263fa4ccb19ae8fd866442542d29c7f4f40622"
    sha256 cellar: :any_skip_relocation, monterey:       "1d17de6253bc34cb004f96bb97263fa4ccb19ae8fd866442542d29c7f4f40622"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d17de6253bc34cb004f96bb97263fa4ccb19ae8fd866442542d29c7f4f40622"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "656e96999634b913d6b4c28fe56fc354af966bb61019397a53586b0d4d9c9928"
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
