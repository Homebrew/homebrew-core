require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-3.1.1.tgz"
  sha256 "6d0ba3d7388435062b446517650f19db5b8575eb9a443e3ea19651f54c27c2e9"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5bb7ef727e703085fcce2b084c78a88c3c5621f008766ee9fbc35ce77f48e559" => :mojave
    sha256 "6717a58e5f120a424226af6a060c958bbe3e980a3097509df37b4a002fd27565" => :high_sierra
    sha256 "7deaf63768010ef6a88fff59398fb7fc87104cc69a430b9cea9f03c7693c24d3" => :sierra
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
