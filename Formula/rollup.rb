require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.7.2.tgz"
  sha256 "061c050585629b384ba4a4fccdc9ad6808a4438321f87d5c3915784467b38f2a"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93491247b1987b5b6780e8377832f2c44dcbdf789afd7766838a5803147bb50b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93491247b1987b5b6780e8377832f2c44dcbdf789afd7766838a5803147bb50b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93491247b1987b5b6780e8377832f2c44dcbdf789afd7766838a5803147bb50b"
    sha256 cellar: :any_skip_relocation, ventura:        "cff9fb05986320ad46870f8330d7234155917d0b227cd6b0109fdf56f0502953"
    sha256 cellar: :any_skip_relocation, monterey:       "cff9fb05986320ad46870f8330d7234155917d0b227cd6b0109fdf56f0502953"
    sha256 cellar: :any_skip_relocation, big_sur:        "cff9fb05986320ad46870f8330d7234155917d0b227cd6b0109fdf56f0502953"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "910ae550f40be105736d9af5949abeb58d86c3c051767b8f62a67ead01d27b98"
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
