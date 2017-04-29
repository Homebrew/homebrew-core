require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "http://typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-2.3.2.tgz"
  sha256 "6a5f57fd294a80c071ce519b1a98fbef1630e189ff576c01e76fb53a0fdd9428"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fedc0819136ff7d531d052ae494c0ef1ebbebdee11ad411b78d7b516b8a24884" => :sierra
    sha256 "ad3b3881dce893a7730287b687ded25a5aeeec02ec5a6510d13a410a91f40c70" => :el_capitan
    sha256 "baf8121d992800d16fadac98c87595cedbff5da029d3b1ad964cd46184f4decd" => :yosemite
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.ts").write <<-EOS.undent
      class Test {
        greet() {
          return "Hello, world!";
        }
      };
      var test = new Test();
      document.body.innerHTML = test.greet();
    EOS

    system bin/"tsc", "test.ts"
    assert File.exist?("test.js"), "test.js was not generated"
  end
end
