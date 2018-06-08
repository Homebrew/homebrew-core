require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "http://typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-2.9.1.tgz"
  sha256 "afb0e5fd204294a3005880018c3eef041b05718127ea8bf922582fdbc94abafe"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "740d212dd804a4f7a798a26aee18b2b61acc70d09c751ff02caf818ac8596810" => :high_sierra
    sha256 "88128dd7bce3387eacf00a83d162582deba78ac587d5c780b9ca3b282b8066b2" => :sierra
    sha256 "7e5af0f06f13d679a8183272fb35d60b6fefab452421fc2ed7d400c466c26843" => :el_capitan
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
