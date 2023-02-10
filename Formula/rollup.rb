require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.15.0.tgz"
  sha256 "bde361354121ed4491a8d0c2653e43261be8a0d9488cc6dd9011e4a05ed8d451"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "776d59f816143ee7a3c304196b72ebfa5d7fcb0a5b50259443f27a278236ee02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "776d59f816143ee7a3c304196b72ebfa5d7fcb0a5b50259443f27a278236ee02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "776d59f816143ee7a3c304196b72ebfa5d7fcb0a5b50259443f27a278236ee02"
    sha256 cellar: :any_skip_relocation, ventura:        "4c10089a9e3731d1a3e2227484d2167c2faf974a7b522197f70069805a8315a1"
    sha256 cellar: :any_skip_relocation, monterey:       "4c10089a9e3731d1a3e2227484d2167c2faf974a7b522197f70069805a8315a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c10089a9e3731d1a3e2227484d2167c2faf974a7b522197f70069805a8315a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "211b4a3a493b080a6cf2b0969808e379d4c3ff66c718121880d15158d783c6b8"
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
