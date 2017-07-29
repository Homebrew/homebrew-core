require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "http://typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-2.4.2.tgz"
  sha256 "c39a4ab3fa03297ae4217d846a3f65512f49991526db58c488a39f8db1155937"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a178f464d211e81f19f8eeee5f402e707af28e78cd1995ea0fa90fe9bb563b63" => :sierra
    sha256 "ac087f230bd8a4367d34755bceccce93b7f0fc723f5813640248293fc4ab58d5" => :el_capitan
    sha256 "cfd92aafd0cf99ceb32c2c1f3c79ea208910e4bb6ca5159dd858d0b51b675a41" => :yosemite
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
