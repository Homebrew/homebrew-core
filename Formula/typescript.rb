require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-3.5.3.tgz"
  sha256 "7e066461729870f9bff8edffab8afb1a511854e040200451bbdf8aec65802b77"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8eaae74b2c4aa9fe5f1eac6847fea4fb9489ab4563b1f8c7b2198c80499dad2e" => :mojave
    sha256 "246ba9befee5dd73280246fa862d4feed6eb000cd49d91d3e7461efe7eac64de" => :high_sierra
    sha256 "96bff9f8883872f7590fa3b3f293ef391a26aaaed50bd1f1e692b055dae17f8c" => :sierra
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
