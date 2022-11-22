require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.4.0.tgz"
  sha256 "a1bcb219e0698d4667eb44134fed30271fca99f3ad3c9e152f0c32e5161b0379"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "873b6c3c79c4a824a699c77e734bdbbf9a80d1706868602d014a361f7e497d04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "873b6c3c79c4a824a699c77e734bdbbf9a80d1706868602d014a361f7e497d04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "873b6c3c79c4a824a699c77e734bdbbf9a80d1706868602d014a361f7e497d04"
    sha256 cellar: :any_skip_relocation, monterey:       "74892ae789a3217b031650970393ca09fb074f507399072bc046c577db99eb6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "74892ae789a3217b031650970393ca09fb074f507399072bc046c577db99eb6d"
    sha256 cellar: :any_skip_relocation, catalina:       "74892ae789a3217b031650970393ca09fb074f507399072bc046c577db99eb6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6263a11429a4715a9f6ab6868b918e614a587ef3345ec102864186abb3e6c447"
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
