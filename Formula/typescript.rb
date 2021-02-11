require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-4.1.5.tgz"
  sha256 "b39221f974d2d2f7c770ba66323ce4b12152813fa31b86e20602580d64e7dbb4"
  license "Apache-2.0"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2638f05658e99bd513dd52596133a8e7960dce36ec1a96848093020c947dd8fb"
    sha256 cellar: :any_skip_relocation, big_sur:       "d3a02966491de5551a5f0938d64d33256c7b090103d8fcd0e25c25a981360d7c"
    sha256 cellar: :any_skip_relocation, catalina:      "46321e9adfa09c6cb699d0035380f90b9cb458155438a36c64b62f9823146052"
    sha256 cellar: :any_skip_relocation, mojave:        "246142234ce0e2f68e9e061d141312968a5c7ee0a180b687ff510a403e878b3f"
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
