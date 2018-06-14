require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "http://typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-2.9.2.tgz"
  sha256 "70434cccfe6b627277175264b51405d8947b54dc23ae2e2c8040178f58a78062"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b951e4118d6831d2702b978b8bb0e16373cc98ac4f53b7f648224bab4d73631c" => :high_sierra
    sha256 "9b3e627c6f3a917befc3745705eeeb2566cf41d127b90263b7dba851b255e04a" => :sierra
    sha256 "3901b36912211d1e17840bba55819deac0c5b8c85bea8c358ac1e9a84613fa09" => :el_capitan
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
