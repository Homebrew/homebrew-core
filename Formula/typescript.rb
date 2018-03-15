require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "http://typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-2.7.2.tgz"
  sha256 "7bfe92c97068cc0eabe1f33a4f2394ac0ac57d28b91e659a2d325b341d2ed270"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "76eb95420ebd295628bc99ca4ee2967f16312968736f743d6805a6d2fe686e31" => :high_sierra
    sha256 "f193f456021339608405596c4780d86fbf3bf34b57d8cbb0aa3841f580c1dcaf" => :sierra
    sha256 "b2d249562e39ea6533d46fd19c285cb4cf8f2b0c5bb656a613841567ed7e6d82" => :el_capitan
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
