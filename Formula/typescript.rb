require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-3.5.3.tgz"
  sha256 "7e066461729870f9bff8edffab8afb1a511854e040200451bbdf8aec65802b77"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a824604cfd76e5b4aa425838f6c80dd158fc0938025c4db096190e1ca09a7838" => :mojave
    sha256 "267f79159966491843be0fdc13044cd6c25f22e0ed8e8fe0e294ee6235f16e00" => :high_sierra
    sha256 "b07bb8d21efd7183c704d183528d70a974dc3ce273d089a72927e4257beac39c" => :sierra
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
