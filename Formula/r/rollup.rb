require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.12.1.tgz"
  sha256 "4a6bd42376ecccd0c5b2ee8f2c4ed7e98768783426db95313ebae8f56580c430"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4fee2980c778d5a44acba110257bd5568004c79d1e9b3f8ddbdff3de43238a08"
    sha256 cellar: :any,                 arm64_ventura:  "4fee2980c778d5a44acba110257bd5568004c79d1e9b3f8ddbdff3de43238a08"
    sha256 cellar: :any,                 arm64_monterey: "4fee2980c778d5a44acba110257bd5568004c79d1e9b3f8ddbdff3de43238a08"
    sha256 cellar: :any,                 sonoma:         "46ff9960d097f482fe7998f1864f5ccf60c45346873e58aee62d1460164f0ed0"
    sha256 cellar: :any,                 ventura:        "46ff9960d097f482fe7998f1864f5ccf60c45346873e58aee62d1460164f0ed0"
    sha256 cellar: :any,                 monterey:       "46ff9960d097f482fe7998f1864f5ccf60c45346873e58aee62d1460164f0ed0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "102c4d79ae6e57ac8c9d752baf48751fe083fe19cf73c35d154e8c82d902531b"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec/"lib/node_modules/rollup/node_modules"
    (node_modules/"@rollup/rollup-linux-x64-musl/rollup.linux-x64-musl.node").unlink if OS.linux?

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
