require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-3.7.5.tgz"
  sha256 "95d5baa0b7719d1560dc0d8910df3919333b0fb03bdc2dc19c41a0aa9ecf2484"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "701cf9e99fcb32de535fbc7a7d0791019fc3279c1e3435bbf640ce21ca4a12ba" => :catalina
    sha256 "5bc7f5f372babe1bafdbdadb058f212c6f6b48cda19de770f9e1a28bb043e2c3" => :mojave
    sha256 "72fe4e3d8ae283136000abe93cf154b9aab9bc72031f6da67b49551c35305a4f" => :high_sierra
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
