class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.41.1.tgz"
  sha256 "9131471ee1dde8051bb7d793de31de67c56eb23f4196e1a6c05a9d49911ddde8"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "373fc2d1afe349b9155430063b029e8be3b3456583cb3fea4e83f275073ec2e0"
    sha256 cellar: :any,                 arm64_sonoma:  "373fc2d1afe349b9155430063b029e8be3b3456583cb3fea4e83f275073ec2e0"
    sha256 cellar: :any,                 arm64_ventura: "373fc2d1afe349b9155430063b029e8be3b3456583cb3fea4e83f275073ec2e0"
    sha256 cellar: :any,                 sonoma:        "91f0fa69fc2bfb129315477e2b172f956408fd6a698b3df93b8b2cccd1d0efbf"
    sha256 cellar: :any,                 ventura:       "91f0fa69fc2bfb129315477e2b172f956408fd6a698b3df93b8b2cccd1d0efbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac8ada64af4772cb0dccf59c6e51f5b4f3033c41c6b73bb176a7e9c97ff74868"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "039238c623fb7770980702090f90c68a51ef6df0c9c166f5fd10e1feeca7da78"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test/main.js").write <<~JS
      import foo from './foo.js';
      export default function () {
        console.log(foo);
      }
    JS

    (testpath/"test/foo.js").write <<~JS
      export default 'hello world!';
    JS

    expected = <<~JS
      'use strict';

      var foo = 'hello world!';

      function main () {
        console.log(foo);
      }

      module.exports = main;
    JS

    assert_equal expected, shell_output("#{bin}/rollup #{testpath}/test/main.js -f cjs")
  end
end
