require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.9.1.tgz"
  sha256 "9bb5d8dd7a6561a078fdd729086eb10febe67f2eb41ef8a8ffcdede85112b8af"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "219ab16bd160d4c85ed2dd2598c9cb5b466606365ca6976037a2341562d51a9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "219ab16bd160d4c85ed2dd2598c9cb5b466606365ca6976037a2341562d51a9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "219ab16bd160d4c85ed2dd2598c9cb5b466606365ca6976037a2341562d51a9c"
    sha256 cellar: :any_skip_relocation, ventura:        "fc3087d24e0b176002c3b26020adef519da33b2c83a4e8dc3ed6f8e0fe0f68a6"
    sha256 cellar: :any_skip_relocation, monterey:       "fc3087d24e0b176002c3b26020adef519da33b2c83a4e8dc3ed6f8e0fe0f68a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc3087d24e0b176002c3b26020adef519da33b2c83a4e8dc3ed6f8e0fe0f68a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9561b73e0487749680e55861d8aae3562239c0583cc59fcd8ec2fd8e5cb3814d"
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
