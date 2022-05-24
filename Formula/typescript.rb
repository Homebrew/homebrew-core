require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-4.6.4.tgz"
  sha256 "fe327fcd837f908d2124b27ec3efe043339b31eb3a2446403bc2c4951c2b0383"
  license "Apache-2.0"
  head "https://github.com/Microsoft/TypeScript.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b8adcc8678f5267e87ff7665d202e3aa89c38cbf8dbef1da069113442ea118f9"
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
