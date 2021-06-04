require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-4.3.2.tgz"
  sha256 "5563c8ad635a9c96bc531aa215dad7d6770babe6797eff91ae9a174cff986575"
  license "Apache-2.0"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ecea75cf3dc990e8ca707802b2ae55eeb1c81bdf6c044c2bc84efe6306f11065"
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
