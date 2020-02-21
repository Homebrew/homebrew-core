require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-3.8.2.tgz"
  sha256 "1cd64750f2ca8a3bac0ca8a34316564441e43319459ed646742ee2f6de730288"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "01035c2bdf5d1a8567f10931c61375fb70b66a097c6b1521c53b3673d343a8c1" => :catalina
    sha256 "ec575d84b053cf76d4693e7e80d1e0ab064ed0fd15baf12c301f3e5980968d4d" => :mojave
    sha256 "d5ceba2b818b0a3e26759282c8e38c6124be3941f89c3361c09eead304906407" => :high_sierra
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
