require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-3.4.3.tgz"
  sha256 "acc00a5456985273ce9c11c670e955990b51cf835f612ac81ad29b7db3b4fba8"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d91c03615e1db7d0d488b8ec132d5863e1bc5a774f95c04b694bd2880563d327" => :mojave
    sha256 "15cfa5eb19c020593755ee0c844df05bc40320849d9fb8c3679ad3c04f3981c8" => :high_sierra
    sha256 "3fa5dd8817477122309d2e31e5bbfcf13599a5edeec808d56f7be06ee11a0504" => :sierra
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
