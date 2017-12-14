require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "http://typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-2.6.2.tgz"
  sha256 "03e533c09fa10ba7b278cf3374b32ae4240ba6201a5ee9300da53127e3efa86b"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f0c02dedb124f30c85472ff7b1fe8f08d5de11abf14d37c8b0116218cf57a5ee" => :high_sierra
    sha256 "26fe6a2653e137ef6485517580e1cb67746980b0be9197c58bd780b09752cf3f" => :sierra
    sha256 "6f6c76b299df9b7eb1e488465eb04aa3d5ba36c748434e71d0f1005cd6170eb3" => :el_capitan
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
