require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-3.7.2.tgz"
  sha256 "bd068e5c31005b7128123efb0e4d78002e0de958a4616f17026c3a45b508e714"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2202814c035712df2d614af01962c38048ae41064b08318c818baac5488629b0" => :catalina
    sha256 "bcdc6b03e33c004a3e3132daaa1d9973982ecd843c4d4138f440b1130828c20f" => :mojave
    sha256 "828407244bd6850c8c921a4abebd7727a71f246211800ac4002ff3d98fa4d00b" => :high_sierra
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
