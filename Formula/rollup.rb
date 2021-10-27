require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.58.3.tgz"
  sha256 "668575b04e7ed81b488db1d3229200ed6116c9a7eb1fa7c76dfb2d3a0d2c1747"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24442728f0cb0f68a76196ac7ea19578a1139cfb4cfd32ba40648844dc4ef6b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24442728f0cb0f68a76196ac7ea19578a1139cfb4cfd32ba40648844dc4ef6b3"
    sha256 cellar: :any_skip_relocation, monterey:       "5f2186f992bb3e8a0e8d6d14198506f420772861f01bddf1ee0402abfb466456"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f2186f992bb3e8a0e8d6d14198506f420772861f01bddf1ee0402abfb466456"
    sha256 cellar: :any_skip_relocation, catalina:       "5f2186f992bb3e8a0e8d6d14198506f420772861f01bddf1ee0402abfb466456"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a66ec712bc5699255706ae682b72e637aa6983a86cb0b28b55f247f59157a7b5"
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
