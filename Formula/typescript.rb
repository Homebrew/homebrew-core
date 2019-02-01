require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-3.3.1.tgz"
  sha256 "5693094bc766af02ec381114cb933c1f6ffc78c1395a4c42b55b3ccf48aa4f50"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b2e723de5d77811cc922e93101a56b32bb374ae03b575eb68732cd82220f86a3" => :mojave
    sha256 "8a313e3bda35fed1d6312c051b0fe173a216c464a6c76cfbe579630dcf4fb45a" => :high_sierra
    sha256 "03f3a59ac0039fef2a308f718238c62ff4e2076cab6cb6da26331c65e7a8d99f" => :sierra
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
