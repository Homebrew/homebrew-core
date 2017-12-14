require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "http://typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-2.6.2.tgz"
  sha256 "03e533c09fa10ba7b278cf3374b32ae4240ba6201a5ee9300da53127e3efa86b"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dcb5e6ee554903b11d85f728736632b0544a35c9dfde12c1618386d5429aaa16" => :high_sierra
    sha256 "791afc22227ffb80205bb061649a9a29a2912176f135d98e4e9fc62b36a04ede" => :sierra
    sha256 "39f1f10df8e42405cc7a663eaa3558c9f5e433f778fb0693e8bf478969849dfa" => :el_capitan
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
