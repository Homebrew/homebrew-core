require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-3.0.1.tgz"
  sha256 "416f4681fe27593835c3d638a805534fdb9a0de9b534bc1eda413f6311016798"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bddd038efc91bcb9196a4e583df730b30f8fbb38450d103062d446c4623139d4" => :high_sierra
    sha256 "41023725ecda528cdc1971b0b0b2626b30ad1c241970e7a877349ac9bb224c08" => :sierra
    sha256 "7e0577be33dd5f6e6376086bfc555359150333513a5418d96d1805315e1cdd81" => :el_capitan
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
