require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "http://typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-2.4.2.tgz"
  sha256 "c39a4ab3fa03297ae4217d846a3f65512f49991526db58c488a39f8db1155937"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d1243205111d57a5ebc820935b98e8586716c916cbb588588f49ed7f48dfb345" => :sierra
    sha256 "c7f62ce9b1eaa62ba258f6b651a817b29ccc72ed1abfc261ae6df333ee3ef3ca" => :el_capitan
    sha256 "cb0cc38c8f7836da536d7c232183c20a878e3685ffae22f506baf7102f6780de" => :yosemite
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
