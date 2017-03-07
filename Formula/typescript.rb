require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "http://typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-2.2.1.tgz"
  sha256 "8b1c1853616593d0e828c236c8e155a552d15a893036d307c4f424a241cf171c"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "84ad2d1e73d2d4c8ba9af3b4b9737d98ba4b13a1297c3abf3c262bb239c5907f" => :sierra
    sha256 "374a0e8adce7a370f294657b154b7df86e108787db1e6d07d3568d51dc5ac672" => :el_capitan
    sha256 "59e66ec04ff2490454f79a70127d9642c7e8dcece8b68eac4217c35ef29d88b3" => :yosemite
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
