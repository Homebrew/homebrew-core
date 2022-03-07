require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.70.0.tgz"
  sha256 "7d0ef6d3ee7e0c8f342a514cc9bd113993701916b8fe48665178c9b1ca4b83f5"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95438452d1f2a00b5297cf7e487aa7208657a5a0d5f4feb7494aa70c5108f838"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95438452d1f2a00b5297cf7e487aa7208657a5a0d5f4feb7494aa70c5108f838"
    sha256 cellar: :any_skip_relocation, monterey:       "e46105ca870dda8bdb4c89dbc0d42bd26ac2a4e64b0db816e4eb3d0099044578"
    sha256 cellar: :any_skip_relocation, big_sur:        "e46105ca870dda8bdb4c89dbc0d42bd26ac2a4e64b0db816e4eb3d0099044578"
    sha256 cellar: :any_skip_relocation, catalina:       "e46105ca870dda8bdb4c89dbc0d42bd26ac2a4e64b0db816e4eb3d0099044578"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af8185cbde7234403cc9b54d3704041350bf4f9d533c79e700238c6672e28a98"
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
