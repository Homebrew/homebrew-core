require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "http://typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-2.7.1.tgz"
  sha256 "f9118d2b1a3955a6220c72ef82e2e314e71c8e589777cd3679d269d92590e730"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c293e405c7008d09607a2fd275fa244fb9e4febedf3a0cf37069e7c0dfedd889" => :high_sierra
    sha256 "97f83301e679ee80050fa3f30f8004807cb2374a30c17bf56fd00bf33875714f" => :sierra
    sha256 "f412cd0f27873df0a1d75e3d72f01fa6cb216e4956aa761eca8e16346037d332" => :el_capitan
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
