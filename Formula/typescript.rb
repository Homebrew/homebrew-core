require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-4.0.2.tgz"
  sha256 "756653c513e3635f4fafdae383f81eda44a0ff5466da028881a7ba1fdd19afeb"
  license "Apache-2.0"
  head "https://github.com/Microsoft/TypeScript.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "e639c97a3a5a01b4ae6f582f4f63179c47c597899754412664304482312e17ee" => :catalina
    sha256 "d0196c1c0c38ee4325d0acc84d0f4d722428ae0f9979872807a48ce2b7110165" => :mojave
    sha256 "df88e0930468b1ac2b37a3943da60a042a4741a84f38c42351d5995895c0aef0" => :high_sierra
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
