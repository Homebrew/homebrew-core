require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "http://typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-2.4.1.tgz"
  sha256 "a724c779d16def9beeeb616cccaeeed833cfddb11b8a1699986aae1df5a1817b"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1790f61a4acbd13aca9069fa8288d057a5a313727f447e83c5ce8203e6b8dff2" => :sierra
    sha256 "f72b7223451c5de4965227bbc19721ad7e159508a29c7d7410d97a2cb1d67f54" => :el_capitan
    sha256 "9754ad3be7c05fe005e87468576c14a7344edf7f92b1e2a97003f948ccd81245" => :yosemite
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
