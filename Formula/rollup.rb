require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.25.1.tgz"
  sha256 "c5bd6d9052d4706ad038f7e67d931140366f322c39bb389c420f84ab2c660f6d"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a074c42d5f7c0015f4b559ebcc04dda393a973582f97a2f8ecc960cd78e40f8a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a074c42d5f7c0015f4b559ebcc04dda393a973582f97a2f8ecc960cd78e40f8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a074c42d5f7c0015f4b559ebcc04dda393a973582f97a2f8ecc960cd78e40f8a"
    sha256 cellar: :any_skip_relocation, ventura:        "508eb51b3247bbe6ce76eb92bec73064eec9c6bdf572ebbdae7d9772e9bebcd6"
    sha256 cellar: :any_skip_relocation, monterey:       "508eb51b3247bbe6ce76eb92bec73064eec9c6bdf572ebbdae7d9772e9bebcd6"
    sha256 cellar: :any_skip_relocation, big_sur:        "508eb51b3247bbe6ce76eb92bec73064eec9c6bdf572ebbdae7d9772e9bebcd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "575c0a7102fd75b6899cdbf3838b8c3a679b6087d5f2bad79f0c2b8c43b6ecc3"
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
