require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-3.5.1.tgz"
  sha256 "ea87090c959a068a74a45337a9374d89c1b539b0044c3d998a7ec82afc8cdbe6"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "02329653aaa7b970e3fc5ee8d076e352c0b2f86cbd2d5dcaefa888e6dd6719f4" => :mojave
    sha256 "b9421a90aa30c5f04b086c33d37728542c2c6bb887b387887ba1eb133c40d886" => :high_sierra
    sha256 "e207323cb2dabe34a0291f3032af23ecf8c7088b0c2a1ed4ef460c2b66822d1f" => :sierra
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
