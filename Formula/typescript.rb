require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "http://typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-2.0.3.tgz"
  sha256 "3cfa9db91b68f95723a8f64db3dd3ee158b828d51d5a6eb6370dbca9e3045367"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba82f04d8ba8f19f55aa5aef6e9a78aa39f306127a2792c413e04ec8b96ac45a" => :sierra
    sha256 "b8e8a907b2c54a341e573a01811d37bebb39d5aa046de262c5ecbd4eb9fc3691" => :el_capitan
    sha256 "afeb59064ccc55657b9a3f09cb7afb31a0c12b842d3e2e96aa41bd681926cfe4" => :yosemite
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
