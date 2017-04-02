require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "http://typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-2.2.2.tgz"
  sha256 "4ee941285b5993e50e822f7764f1137b759d6eb720bff2b42352e629f2edaff3"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f9cf75b9b1bc2a3f1f3a916a01552cc10e74927a9367c3e1226fe2bd9167322f" => :sierra
    sha256 "e31bd2132020fcd35ef7f79c84d755a5813a64a2ccb07c17c2ef837ccae40567" => :el_capitan
    sha256 "dd2c3be813ad1e8888d2fad2df9dbfc3583f9f355fa0e7eb642b137d098d3a82" => :yosemite
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
