require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.12.1.tgz"
  sha256 "13e080b3b17de77293efa75aca7957c639fb7dc5430bff1d0597ea7e29aaf889"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3938bf36095471ec33d6559bbf31bf11ac18fef6377b7abd5ab023b4f011f23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3938bf36095471ec33d6559bbf31bf11ac18fef6377b7abd5ab023b4f011f23"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3938bf36095471ec33d6559bbf31bf11ac18fef6377b7abd5ab023b4f011f23"
    sha256 cellar: :any_skip_relocation, ventura:        "a81792fd0f590b9b0a921374917f2f6fa9a19673844ccc5c756d1d2bf12f0311"
    sha256 cellar: :any_skip_relocation, monterey:       "a81792fd0f590b9b0a921374917f2f6fa9a19673844ccc5c756d1d2bf12f0311"
    sha256 cellar: :any_skip_relocation, big_sur:        "a81792fd0f590b9b0a921374917f2f6fa9a19673844ccc5c756d1d2bf12f0311"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e2daeca7b0a846421ffcbae119619abbd350e9594de616d67fdd8bad4db563a"
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
