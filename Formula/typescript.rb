require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-3.6.3.tgz"
  sha256 "ef803d564f80a7c1aa731896556f0d05af6b7b371abcd687ffd493e7bd718457"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a636fdbcfbacd7546c0d5b5767f98e10ac06036c3fe5dc3934018ea86aa9168b" => :catalina
    sha256 "3bd0896b1c6a423c2f502932599931c7c2f9348bcb27856fa932ab56c0028be4" => :mojave
    sha256 "1049bf48f6cc02358a3a4ec2e1187f30ed7d8d5bc4a53b388661f7f205027df1" => :high_sierra
    sha256 "bffc050131abccb5dedd986667e4dcc263e736699c03f953afb52f1ec83174d5" => :sierra
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
