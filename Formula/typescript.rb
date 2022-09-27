require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-4.8.4.tgz"
  sha256 "8e0118a302a4930ef0799e9fb64ef0038dce546b7889603c744676afd9c93c20"
  license "Apache-2.0"
  head "https://github.com/Microsoft/TypeScript.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "abbfa503fca409fba4fb907cc3de9ea3a1ab2b35293ef226cbe56bc87cb420bf"
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
