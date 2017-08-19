require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "http://typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-2.5.1.tgz"
  sha256 "1f3c6773e2bc4d56918e6d11a1515c98dded742b52d8733be0a60d0c12ffc330"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0535ded6fa43680daaa5be479565658065a280a10b5da82394abcdbaf970383c" => :sierra
    sha256 "c85ddf8f14309a10a058f5c6c3d38ef432c403082c248099cda22046da760c01" => :el_capitan
    sha256 "2f747cfa71f5073216079a57a0b3fa60e72540950063ea1bfb33c258824c2c25" => :yosemite
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
    assert File.exist?("test.js"), "test.js was not generated"
  end
end
