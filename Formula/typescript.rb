require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-3.4.1.tgz"
  sha256 "1d71fb28cb00131b802cd982f3398ced293955d1c90961abddde7153e2fd3d82"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d81129e0c99fdbd45669a4bbeaeb080f18337af3cf5f9be1eea7e3fed0601c1" => :mojave
    sha256 "6b2a9480b4c0d86596dc71f4ef335c94bb69e7625252cebd489b6398c99f5340" => :high_sierra
    sha256 "4ed930c44f6e5cb55cafdcfb199686cd0247d2fd827eb0cdddd0452a4171e8ad" => :sierra
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
