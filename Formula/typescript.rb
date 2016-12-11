require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "http://typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-2.1.4.tgz"
  sha256 "3da407976b10665045d142d1991cb56a36890b8360c6244e43f54f09f5f4493e"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6ecb04f51738ed4e3cda355cb4d40bb3098c040616213a4ee64a72b18eaefcb6" => :sierra
    sha256 "7522d761a537816d7fbaf387079746d24d74fc8b6e62fbd044faca827c718496" => :el_capitan
    sha256 "275446346eaab4364dc8e7f9086c69e094aa8ddf195b139dcdda631babe496b8" => :yosemite
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
