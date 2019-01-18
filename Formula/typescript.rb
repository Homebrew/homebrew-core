require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-3.2.4.tgz"
  sha256 "4f19aecb8092697c727d063ead0446b09947092b802be2e77deb57c33e06fdad"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "55041f29c2f24b4135204cf6f26ca06d2de6055f2b0e9aad1f8d4ad59fbe5702" => :mojave
    sha256 "13f93d4d4f0a6be236039893b960df2b1ea4ad3548550e2b7a74a0e6a33b6751" => :high_sierra
    sha256 "2dab018be8ceb0ddd6bca76bc6700332a3a4d91bfdcf87f0dde49dc12b7da577" => :sierra
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
