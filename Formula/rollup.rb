require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.8.0.tgz"
  sha256 "0f6b41a07dfb6f2509901bb3b48aec00be399d48d5b7524d35e4d55b7615494e"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60c073180568648a095b478b65697658742ad0a9e46cda4422e559d57c0cd043"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60c073180568648a095b478b65697658742ad0a9e46cda4422e559d57c0cd043"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "60c073180568648a095b478b65697658742ad0a9e46cda4422e559d57c0cd043"
    sha256 cellar: :any_skip_relocation, ventura:        "b11013b28424fe6417e0eef7e0855472a2bb70ce6359216a67fa4c969db557c1"
    sha256 cellar: :any_skip_relocation, monterey:       "b11013b28424fe6417e0eef7e0855472a2bb70ce6359216a67fa4c969db557c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "b11013b28424fe6417e0eef7e0855472a2bb70ce6359216a67fa4c969db557c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "463a77c1e39f74aa4269e7527c0a7ebde280b72e39449e6af85981e76f3c3be4"
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
