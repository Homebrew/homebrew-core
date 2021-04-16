require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-4.2.4.tgz"
  sha256 "6eed9794296d93c83074e022652ac680314e0cf37b969945e9f0da4e47332901"
  license "Apache-2.0"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5e930650881dfb201ff65988c3d4c27eab7969bd7ed4d4a87da05061360c394c"
    sha256 cellar: :any_skip_relocation, big_sur:       "a088a887d6c6638d808045034dd75177803d86eb313e604d1ab74336ba19d969"
    sha256 cellar: :any_skip_relocation, catalina:      "2c4605739270e5b3681adfd5fe9e3a1deef93b4f1790ed0c6cdb801727ca0080"
    sha256 cellar: :any_skip_relocation, mojave:        "6c53039ac025c59db02018d4a36f9d95000f7b4df5f22d751f26dcad9cc663ef"
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
