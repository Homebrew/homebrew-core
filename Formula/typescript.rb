require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "http://typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-2.3.2.tgz"
  sha256 "6a5f57fd294a80c071ce519b1a98fbef1630e189ff576c01e76fb53a0fdd9428"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a3831a21cbcf7664de26d2cf14310747f5317fd38a736eadc19c65c334a38b45" => :sierra
    sha256 "b3404d1fd1059963282d5bd62a91de6ce1a891d1d090bc7ab40ec88fa9e1a9b5" => :el_capitan
    sha256 "1d165a897d9c97829653f2fe863f381055cbf3e4e1566a253b7f8c7ae20e07df" => :yosemite
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
