require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-4.2.2.tgz"
  sha256 "2bddffdbc744f75f6b57e0f7225bc5a945b228b627b8194a993d0993e2e0767f"
  license "Apache-2.0"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "758aed260c03da16cf485b5496d36c5527d4d3bd95e735b5b0248fe295fd4487"
    sha256 cellar: :any_skip_relocation, big_sur:       "d6fb25fe91935ee15133f500bc602fe9420176140f3edf8bdffaa63bf1089f2c"
    sha256 cellar: :any_skip_relocation, catalina:      "b341d6722d6732e1ce8a87580f5c639d41dfa14c30e3451b46165bc47cf1da29"
    sha256 cellar: :any_skip_relocation, mojave:        "094438881b8e39be5f87a0a1f820614ae6526ceaa36a48b9cb46c6c539248f07"
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
