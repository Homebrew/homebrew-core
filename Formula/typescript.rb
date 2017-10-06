require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "http://typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-2.5.3.tgz"
  sha256 "748565576a2fc834999763ea1c5f560885b4e902857ffc62bbbc9e6841ddf5f2"
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
    (testpath/"test.ts").write <<-EOS.undent
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
