require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-4.4.2.tgz"
  sha256 "6de61b7a3a79680b0de4c77a22eecf0dad7dfab5e9301894bfea452c5b9b4b25"
  license "Apache-2.0"
  head "https://github.com/Microsoft/TypeScript.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fce42ea57d9ea2e049816fa1588462a9f5a3c3b12889da8a5d5fefa00dbac619"
    sha256 cellar: :any_skip_relocation, all:          "a7792db17c8c956035fba6a02e2f7a305010cab512e7bf5b1c677adec9900afd"
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
