require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.21.0.tgz"
  sha256 "9b03b888fce2541277cd4ba549d8d9e114711222d2f0a1e4f65b782e75ec7191"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6131bf1fc334b452544971366ea2f537b4de7d05fa499f157041ca0524edf37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6131bf1fc334b452544971366ea2f537b4de7d05fa499f157041ca0524edf37"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e6131bf1fc334b452544971366ea2f537b4de7d05fa499f157041ca0524edf37"
    sha256 cellar: :any_skip_relocation, ventura:        "47daf7a576ea959ff928669e9c13ab814b8bd208b8951e4b977b4c3743630b08"
    sha256 cellar: :any_skip_relocation, monterey:       "47daf7a576ea959ff928669e9c13ab814b8bd208b8951e4b977b4c3743630b08"
    sha256 cellar: :any_skip_relocation, big_sur:        "47daf7a576ea959ff928669e9c13ab814b8bd208b8951e4b977b4c3743630b08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "771a951eb445891484fb75f2f38dc3c24b8582a6bcd77a644cf73dea20fc67a0"
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
