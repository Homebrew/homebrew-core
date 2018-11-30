require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-3.2.1.tgz"
  sha256 "694c5dc2569ef02ae4f905d613f3c3c3470ebca31a8d222802f8a0d6b2543b56"
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
