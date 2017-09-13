require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "http://typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-2.5.2.tgz"
  sha256 "194776312f554ed95952e427d363cacdf0c505d08a18a30a8534f0d3c61b7f14"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e7a219ce5d897547f8565e3961f2b76146e4ca6923e4641615413a2d384a822" => :sierra
    sha256 "fae8aea5885bbf5be512e8210ba2c34e50e49883c014b74791008bb7a330cc41" => :el_capitan
    sha256 "b0c6ac9223dff9560f590ecd13ba6d315e200fd92f7da61f4c7b9f70e25f4af4" => :yosemite
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
