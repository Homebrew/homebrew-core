require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-3.1.6.tgz"
  sha256 "2cc76f3321bcdce70bdc7d8691e8d40b88a622902f8eeafbda3984ba7a9ed125"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "888f88897105a66131feb42227c4f4fff333e0e719828f1c55250a7267ade29c" => :mojave
    sha256 "4c203d8ae33eb1ad9687278bb5311e7d2cb275fbce173cbc315c4966bbc26906" => :high_sierra
    sha256 "2993d32f6629020e8395bd78fafffe9f8ae8f01a44e9afcb20877d15c027df1f" => :sierra
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
