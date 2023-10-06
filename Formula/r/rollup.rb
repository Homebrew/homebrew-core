require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.0.2.tgz"
  sha256 "59831182c9a4dc2f7a6fb4aae5005c1dbfc29cd7fb0feed55edb68703e906e43"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5e04b3777fbb39b48d2c28874b87e6fd6f99684cd62d2319eb0e7cbbc5fc3083"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e04b3777fbb39b48d2c28874b87e6fd6f99684cd62d2319eb0e7cbbc5fc3083"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e04b3777fbb39b48d2c28874b87e6fd6f99684cd62d2319eb0e7cbbc5fc3083"
    sha256 cellar: :any_skip_relocation, sonoma:         "59a659152acf8c014c50fa8157a76fae90a25a31c45b585d3e71af76b9e72f65"
    sha256 cellar: :any_skip_relocation, ventura:        "59a659152acf8c014c50fa8157a76fae90a25a31c45b585d3e71af76b9e72f65"
    sha256 cellar: :any_skip_relocation, monterey:       "59a659152acf8c014c50fa8157a76fae90a25a31c45b585d3e71af76b9e72f65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5d617a3b7c909ebf1bd0fd80e9b104d57d1e578e2e838d032e9576c581b4d38"
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
