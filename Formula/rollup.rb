require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.69.1.tgz"
  sha256 "2b66b1118c5883ba524153d57eeb4d093ceec81fb52f7da3f7a65922503168b7"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10d7f5c72dd85a61a57322436f4e38c7b7909d961dcb3e871b14164cb6b788e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10d7f5c72dd85a61a57322436f4e38c7b7909d961dcb3e871b14164cb6b788e7"
    sha256 cellar: :any_skip_relocation, monterey:       "14f73f8a1122cacce46e43f6562cfd5ed29d5dc2846284830c968128194d2f10"
    sha256 cellar: :any_skip_relocation, big_sur:        "14f73f8a1122cacce46e43f6562cfd5ed29d5dc2846284830c968128194d2f10"
    sha256 cellar: :any_skip_relocation, catalina:       "14f73f8a1122cacce46e43f6562cfd5ed29d5dc2846284830c968128194d2f10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87c6b862dcf8523e313c3ebd7e9c300016739f4cb205615c64a90be276fa487a"
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
