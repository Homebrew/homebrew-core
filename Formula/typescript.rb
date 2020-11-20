require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-4.1.2.tgz"
  sha256 "383b18630fc00016cb7bde65f111e79d43fccb8c025faf33d7a3a07a5abdf026"
  license "Apache-2.0"
  head "https://github.com/Microsoft/TypeScript.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "20f1399128b4adae3e5669fcb6e2277bfc57ebfb7c3d473d3a959c7854c36340" => :big_sur
    sha256 "1bc80fae04f79b881f702adcff4060385a8b0bd371f9b1d8268495af3e18d6bd" => :catalina
    sha256 "7dd583bd444d85d622658af9e61b891fffe365b7ef72bf1fde3e12f30d22dbaa" => :mojave
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
