require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-3.1.6.tgz"
  sha256 "2cc76f3321bcdce70bdc7d8691e8d40b88a622902f8eeafbda3984ba7a9ed125"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9422b0a0d86abedc8e2ba22be1220435f126fe54c5dcb55493df4e0e64e36705" => :mojave
    sha256 "db15098b310d3fd657cc7cda51da86db1d281fc54db1fa9ce117baae6c5903bb" => :high_sierra
    sha256 "a46dfa9f7c1a69528a1c69105c3b01e129be797e17f9dafd4ab52745b455bc72" => :sierra
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
