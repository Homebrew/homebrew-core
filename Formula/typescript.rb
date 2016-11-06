require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "http://typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-2.0.7.tgz"
  sha256 "3159c893dcf8b422c6184f7c03e51e72ef2bbabe6ec657504c692c216ec1d747"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b07e5561d6f43fa64eca2b4f40e42c65a4a67fd1a57da3725c5f3a8dd7015b0" => :sierra
    sha256 "de370c044074837e09dc9d3383461f63886576cc0cda11ae7d81bc685ef86e7c" => :el_capitan
    sha256 "d63768a960ae42348ba640dfda58c38abf7661ae00c8efc51ecf9d06175cc190" => :yosemite
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
