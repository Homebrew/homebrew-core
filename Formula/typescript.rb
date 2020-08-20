require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-4.0.2.tgz"
  sha256 "756653c513e3635f4fafdae383f81eda44a0ff5466da028881a7ba1fdd19afeb"
  license "Apache-2.0"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8be118cdb13e1765b31a4c6bd45c70d3228a7d0093718778d7865de35b6b489e" => :catalina
    sha256 "fea40bd33455e015891ed347e37be5fb46d6240216f7a7d6202864fd4cd7ea97" => :mojave
    sha256 "828a3273617e11d6e212cefb10716a27603c8fcc8552ff3eb09e2a2521b5399e" => :high_sierra
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
