require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-3.7.4.tgz"
  sha256 "e4f1543efc8d69ed0856b57a909b1786d63dfc3daaaa8056d4f601d98f35daad"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7a17906ffc0cb58e46c070d6c7caf9dcae8af40ff593f3dfcdf7fa2ebb5438d" => :catalina
    sha256 "7d8702cfb661fa12f00d0886ac65712ee4672d46b192fb7f528988b4f665f1b6" => :mojave
    sha256 "3187a2112e800b0d0bacadc6e6e0e30e814f89e2bbcd0e29a9eb5328f1e24b11" => :high_sierra
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
