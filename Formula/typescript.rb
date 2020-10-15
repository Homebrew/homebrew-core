require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-4.0.3.tgz"
  sha256 "84457b86a8bc4be5421e4d8212367aa1a6afa744af2324ba9c33f76b46bdeac4"
  license "Apache-2.0"
  head "https://github.com/Microsoft/TypeScript.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "33f62b2282d4059fe7836f970954a533224ba6cbbd74b6278295e2b84273be01" => :catalina
    sha256 "590500cd03d273ae11644c6487f91b496f904da41e99a5b6e23dc1eb045a9cb9" => :mojave
    sha256 "c365cce4f325c8c8860a924a93b20c8edf39d292079c7fa334315765cf963124" => :high_sierra
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
