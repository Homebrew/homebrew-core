require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-3.1.4.tgz"
  sha256 "1f98a918be4434b9ea2e58648339e092f3adbb67352e5d9be0d9a1dbc7815c62"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0c5c9512989f1bed14b2c25058c11a91956671e87103587f5a94aff9109cd356" => :mojave
    sha256 "832a108bf3c5ad7f33fbf2eb51933aee765fd40b74720234cfceb0a813f403da" => :high_sierra
    sha256 "98247667cb18c9c4b6d94e794c839608e849972fe01858a4df38e3ec4787db80" => :sierra
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
