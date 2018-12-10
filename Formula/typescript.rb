require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-3.2.2.tgz"
  sha256 "98cfaa85ca3e1f46cd2c263d1ddcbfd689df46eb3183ca4aafe0d1af283ae298"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bbafb3b9d2e413ff29a2699049008a8152cace7f970e2fef21e325a06c7cbf11" => :mojave
    sha256 "ee4e24ba0e73f56e9e2523ca72b299ab1e005179edfc2455e3355404b66639f9" => :high_sierra
    sha256 "6aa16dea24be073b87c23a518e4573887b23f1d57ccb9610dd46823a8a676233" => :sierra
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
