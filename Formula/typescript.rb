require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "http://typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-2.9.2.tgz"
  sha256 "70434cccfe6b627277175264b51405d8947b54dc23ae2e2c8040178f58a78062"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0c1fcc18ab5fc2792ce675c5afc963ffd84dbd30e749be5b45a51b41c8e2d958" => :high_sierra
    sha256 "c97da20265eb6e337e5dc3dacc3221d32efa07f310a4b9afcec0bc576817d2db" => :sierra
    sha256 "6ed3cae341ff0e916a3d9e6d055100d88704f1d8d8dd85c3baec1fb31576da7c" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.ts").write <<~EOS
      class Test {
        greet() {
          return "Hello, world!";
        }
      };
      var test = new Test();
      document.body.innerHTML = test.greet();
    EOS

    system bin/"tsc", "test.ts"
    assert_predicate testpath/"test.js", :exist?, "test.js was not generated"
  end
end
