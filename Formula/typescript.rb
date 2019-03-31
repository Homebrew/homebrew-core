require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-3.4.1.tgz"
  sha256 "1d71fb28cb00131b802cd982f3398ced293955d1c90961abddde7153e2fd3d82"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f2c09a9a9c4bebc578c0dafedf91b3482cce735bf7fdb724cbc5768f863480af" => :mojave
    sha256 "0ce52e238c3c5bf995da96537d02dae42e357d937cf9e60ef172c640a50e5ca4" => :high_sierra
    sha256 "4327456d253f909703f656d6d444a887ab181983bfb18516b2c8351047c89eae" => :sierra
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
