require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-3.2.2.tgz"
  sha256 "98cfaa85ca3e1f46cd2c263d1ddcbfd689df46eb3183ca4aafe0d1af283ae298"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "70885ba86ba6c2e0443542fb340e3960cb04eaefb09541f87fa73c25d6eaa3c2" => :mojave
    sha256 "7cfe5421f2f71150ba6a6fdc96c53d10fdb52c68386adb722b71e4f3ec5b81f2" => :high_sierra
    sha256 "1aeba83d0e9ea54b17d2aa6f4b04482c0af6bb55c9e17421b435f71cb3dae442" => :sierra
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
