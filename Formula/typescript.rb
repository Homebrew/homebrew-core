require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "http://typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-2.6.1.tgz"
  sha256 "62b4de36dbb0a41339ad111d3845f226e2d968cac47097f35291f38b88f6c2a6"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3395278a81e40b3cea419a699bd7a8333ef76108b60e6c3865306fcf11690f45" => :high_sierra
    sha256 "e4eb93d6dab6186c7fbc03d752317c48d332e3a1fa37faf7fcd4be593c711169" => :sierra
    sha256 "61764c2a351c5cd96238555a624bcdbce09893777da25b5a8edcdf3349fb34be" => :el_capitan
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
