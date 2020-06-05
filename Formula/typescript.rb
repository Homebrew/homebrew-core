require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-3.9.5.tgz"
  sha256 "7d542965aac5ce66a20866b1e1d71f75960efe6c18cb6209a0d2959e34ebe371"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "779039544d1368e6ec44f113ba767c79b4e1076962e62a09bf7e5bb0fe1f3b27" => :catalina
    sha256 "ab53bdb6c982c386ba60d4d8181d72ad1f9d2a104327c4ad5e51c26945a1945a" => :mojave
    sha256 "fa630d551345769bbd4a87cf3b6b588b9dee142f5391e78fa01c52f0e464cc51" => :high_sierra
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
