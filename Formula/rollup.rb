require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.56.3.tgz"
  sha256 "ff1b1ea315ec186efb3f70a643ef17e552e076c518bb54d4e84a22b3e9f48cda"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "44f7a8674f0790f69612c1d1adb326f918d04e344eaa5731e7f66e4a95990633"
    sha256 cellar: :any_skip_relocation, big_sur:       "8b60929a02a89dcce53d362d00170292b88b221bdcbdf218f2803e35ff893863"
    sha256 cellar: :any_skip_relocation, catalina:      "8b60929a02a89dcce53d362d00170292b88b221bdcbdf218f2803e35ff893863"
    sha256 cellar: :any_skip_relocation, mojave:        "8b60929a02a89dcce53d362d00170292b88b221bdcbdf218f2803e35ff893863"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4221c8a15801f5672ab0d5c6d0a167855a6b430d4d20f638a91aba9af32cf083"
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
