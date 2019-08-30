require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-3.6.2.tgz"
  sha256 "9495625742582db7cb5cc04d34a0b56b8b4b7af1b56b87944fbf30be439a1641"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "27a07cd06eda691d289ff1060a3ed6b27dc345356bce6ca54c7de0a6a8dca777" => :mojave
    sha256 "8987c59e518465529117e948e46069262bfb2c78b0b25aa8e1f5c80a8e2ef57a" => :high_sierra
    sha256 "3c85ee0c66316904b79614cd7c1d1897381d2a8730ab3182def8142ac922c4f5" => :sierra
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
