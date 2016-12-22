require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "http://typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-2.1.4.tgz"
  sha256 "3da407976b10665045d142d1991cb56a36890b8360c6244e43f54f09f5f4493e"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b74105ecdfe20a9a16e20a16d61430a8a70b11fa16df12d80bd0b6eec79fb1b8" => :sierra
    sha256 "a8c86011096764120f6ca5f1e5946c48884becbb6a083afd0c5d7f16f31e4b1c" => :el_capitan
    sha256 "55c150a499f070b3ddaca920dfd29c8ac1bf6ad9a6767ed8097eb6f637a4aa87" => :yosemite
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.ts").write <<-EOS.undent
      class Test {
        greet() {
          return "Hello, world!";
        }
      };
      var test = new Test();
      document.body.innerHTML = test.greet();
    EOS

    system bin/"tsc", "test.ts"
    assert File.exist?("test.js"), "test.js was not generated"
  end
end
