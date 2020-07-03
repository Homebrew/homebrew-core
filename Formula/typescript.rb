require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-3.9.6.tgz"
  sha256 "8ff4c1a65f9dd4f5293f47089b199a9f8a51600e1986ba86cf6b89a1092ff798"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2cb809424228689b0d288cb7519377381b5ab169ee255401c1e3be4772bc4c16" => :catalina
    sha256 "c64b10b665a47a76183cbb5ad1ccafcc2abb21914bf01c28fe455583c431327d" => :mojave
    sha256 "94ff7cae4425e5f751a20b744803b3294751cd70a7f15890eacb103f38619a34" => :high_sierra
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
