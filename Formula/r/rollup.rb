class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.62.5.tgz"
  sha256 "4639a03c2f5dc13c66485cb2ef1e4b53ee6067c255159ee67b93b534e50410af"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2346ebb19cc53a509bdf286640271e20a5017b0e048e8731c659dbc8a0c2788f"
    sha256 cellar: :any,                 arm64_sequoia: "2346ebb19cc53a509bdf286640271e20a5017b0e048e8731c659dbc8a0c2788f"
    sha256 cellar: :any,                 arm64_sonoma:  "2346ebb19cc53a509bdf286640271e20a5017b0e048e8731c659dbc8a0c2788f"
    sha256 cellar: :any,                 sonoma:        "223d5a4f6061e9f7c4fe8bc467d90f914f7d006408756e9e438cac837cc274d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c12c60ebd5b4e8f72b66d9a38b9c6c46511fcb34fb28ee988bd74c918f531ba9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eae164b0a1e8982d1a1ae081f5d647e41d36413990a0b562bba3e8b2ab333962"
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
