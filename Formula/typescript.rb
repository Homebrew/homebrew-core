require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "http://typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-2.3.3.tgz"
  sha256 "046e1776b0513f37b6bd5f496845c335038415b985491bbec5dd53c867d58188"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "65acc5f9fd3fe5b4144249f56477ae9907279e1d60af368c612ef5b79b6e001d" => :sierra
    sha256 "5ac5befe3688e11a5223a3e92c6171d9d2101741ac0b73e8e30734302eb06f15" => :el_capitan
    sha256 "9372e535a304b99f9e18fc36981e094ec1a0962b47d63b69ef2f56f2d095b8ee" => :yosemite
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
