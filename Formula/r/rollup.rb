class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.52.4.tgz"
  sha256 "7efa444d2d1792db2c64d4ad7949e0d9bf8ce477f50fe561c650900f68bb0122"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fc870d6618d879da13e394aa9a94f63d2aaab6110dc564916a53b8eded7df14d"
    sha256 cellar: :any,                 arm64_sequoia: "7eed17d6971d11932d4cb6faf8ca13e424baf47e7d73337fa2cda339aafa2439"
    sha256 cellar: :any,                 arm64_sonoma:  "7eed17d6971d11932d4cb6faf8ca13e424baf47e7d73337fa2cda339aafa2439"
    sha256 cellar: :any,                 sonoma:        "b520588644edf1a150b7fe4bd2c8e324ae3b6806d60449096ac11acea53c4ed5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f038b10c717ace5509569e8e1e96cd2149f521d19ed208afd20a999432f8a63c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "972d2d0c32c05e86c2236b90870ec7c769dbe2e20865b504e3b4dfcc46b0945c"
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
