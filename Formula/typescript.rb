require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-3.9.2.tgz"
  sha256 "c98ed9e87f35f975a3d072a6e87217f35f15303fe9d6a390acd4532b9d029a50"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "425b1b1305f54d76348304836af289655302a0d9f43251fcd48105556baf41e8" => :catalina
    sha256 "677a1f40e167fdfd15c269e43b3f16702ceb14cf6c41e90103da35864a9c9886" => :mojave
    sha256 "84815312d82729a29ef1015bd1bc80bed1a77ac48ddaeccbe143b44185bb6941" => :high_sierra
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
