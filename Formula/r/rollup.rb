class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.40.2.tgz"
  sha256 "23316e7c4057b4a823809a81dceee139d03cebf5995f766096e88e8f12619275"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "48de94f8820c454d8e3d8946107052b301c87f9f42a5c9ad9c2c7f83d7b1bacd"
    sha256 cellar: :any,                 arm64_sonoma:  "48de94f8820c454d8e3d8946107052b301c87f9f42a5c9ad9c2c7f83d7b1bacd"
    sha256 cellar: :any,                 arm64_ventura: "48de94f8820c454d8e3d8946107052b301c87f9f42a5c9ad9c2c7f83d7b1bacd"
    sha256 cellar: :any,                 sonoma:        "c168b0d87a7cd961026b71adf454a26b219b0a85353ea1fb017f73ea6aba97d6"
    sha256 cellar: :any,                 ventura:       "c168b0d87a7cd961026b71adf454a26b219b0a85353ea1fb017f73ea6aba97d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bffbb8c393fcdca6993e10dc737e49f3cce41fdcbaea133f76e24ad240e7c27f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "053933b13fb84e4ded3e67a7bc376a5b89d60eed5c39a79d7c95065a21584aae"
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
