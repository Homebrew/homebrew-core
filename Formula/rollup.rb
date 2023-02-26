require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.17.3.tgz"
  sha256 "dfd3e6aace3df301e58b94658053351b37e2774af901088a2d2c746a035a6ee2"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d03b8fa707d2aafe76c5aafe6f11f5f397db83df099039bc29c19e39ec1a1801"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d03b8fa707d2aafe76c5aafe6f11f5f397db83df099039bc29c19e39ec1a1801"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d03b8fa707d2aafe76c5aafe6f11f5f397db83df099039bc29c19e39ec1a1801"
    sha256 cellar: :any_skip_relocation, ventura:        "df4c9a590b43941da6711502d1a52739e84b88a90938ba6840d5e4cbdf94618c"
    sha256 cellar: :any_skip_relocation, monterey:       "df4c9a590b43941da6711502d1a52739e84b88a90938ba6840d5e4cbdf94618c"
    sha256 cellar: :any_skip_relocation, big_sur:        "df4c9a590b43941da6711502d1a52739e84b88a90938ba6840d5e4cbdf94618c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "500205ad84bd4014ce7c40cfe33843460508bb36550081b6ef50743c0f932d47"
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
