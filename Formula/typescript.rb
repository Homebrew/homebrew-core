require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-3.9.3.tgz"
  sha256 "5283860b4f5fe40dd9d508fc1759db4b61a19ce96c7be6cc66044c5b74469677"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba1dd3ebd958761f4e4da8ed290d9f01140bdfc9911e5dc7a3205eeda2cf6a27" => :catalina
    sha256 "2ed8a5eac05f80fed6998886feab4c4c44286294ab00502847bff97179a00ced" => :mojave
    sha256 "6a1ded423764985b8fd9f14aab1920f76ef2290b1c3a8ad16a8c99cb84f64f91" => :high_sierra
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
