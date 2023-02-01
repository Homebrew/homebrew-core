require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.12.1.tgz"
  sha256 "13e080b3b17de77293efa75aca7957c639fb7dc5430bff1d0597ea7e29aaf889"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3194ee6f01925a2c96e7e9d0e883baaedaf665cd09e0d2694ade67ad8703210"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3194ee6f01925a2c96e7e9d0e883baaedaf665cd09e0d2694ade67ad8703210"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3194ee6f01925a2c96e7e9d0e883baaedaf665cd09e0d2694ade67ad8703210"
    sha256 cellar: :any_skip_relocation, ventura:        "82a44cb1d041660929a48be0d8cc1c8824d3e1d69666a389b6b2ab6fa38b8ed7"
    sha256 cellar: :any_skip_relocation, monterey:       "82a44cb1d041660929a48be0d8cc1c8824d3e1d69666a389b6b2ab6fa38b8ed7"
    sha256 cellar: :any_skip_relocation, big_sur:        "82a44cb1d041660929a48be0d8cc1c8824d3e1d69666a389b6b2ab6fa38b8ed7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cfb8e32a9d1247c59bcf84244dc0a126a1493c47d81daddfe046dc84e2aa6cf"
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
