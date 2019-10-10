require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-3.6.4.tgz"
  sha256 "92d2fb8676a6e74a542aba22bbf6600001a02ec6f38f39c0078a9458c91c9d8b"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "44378a0e6016c8498472186b4df79282555af9588981f8c4dcde389dec1cc88f" => :catalina
    sha256 "9a45c32139669ef3e8d886579d9b1fbe1b013a9fea26ccaf9cd6beb3013e3ba6" => :mojave
    sha256 "4c23a4e52c6ac61ad1050c9271e72c350de0aea962eff22490134d16cf5a58f3" => :high_sierra
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
