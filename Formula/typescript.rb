require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-3.0.3.tgz"
  sha256 "164401d0ef8d6b062b1b767440a5ef8c6d9d9062c57fc1a8c1a5659cf638f2e8"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "91fbc7e3036b768d23817132537b2b14cc041ae14c3a1b25a362d2dcfdfa9e34" => :mojave
    sha256 "9a5adf428865ba9dd1686c4205f0ce93e3bdfe6e088be235aa65d67fd7a071ca" => :high_sierra
    sha256 "d0d0201e4f125bca7429ba4d0eac19a906b7c5293fae59ea3825d1683f63f7f0" => :sierra
    sha256 "60480fba6f839f11f6d76000a35055a19c9a6ebef43071b78595de434133a85d" => :el_capitan
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
