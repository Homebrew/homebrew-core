class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.61.1.tgz"
  sha256 "0c1750cccca475f19758d78bacaf072c899e7572de00b2660b18dad496f22642"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "63f36e15384bea3e950134fa18380626d18f9568b12560283c43fbd64c8f70d3"
    sha256 cellar: :any,                 arm64_sequoia: "b60bf7efc41d3fc5c3dce7d7f891a8884d727d3ebe2d9edca7be8bbdc9f33dd6"
    sha256 cellar: :any,                 arm64_sonoma:  "b60bf7efc41d3fc5c3dce7d7f891a8884d727d3ebe2d9edca7be8bbdc9f33dd6"
    sha256 cellar: :any,                 sonoma:        "b4c13af3d094747132cd69ff51fdcb902302a706c9275361236773dae6cc8b46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "acf95fd8079ba2c158295e7b8fa120dbb8ed18ad5e38b4d00d60f46ded27c097"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "065cec05902afb599d42d56d745340b5a89a0aa53f66698fad6ad0529c3fa961"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Replace universal binaries with their native slices
    node_modules = libexec/"lib/node_modules/rollup/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node"
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
