require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "http://typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-2.0.7.tgz"
  sha256 "3159c893dcf8b422c6184f7c03e51e72ef2bbabe6ec657504c692c216ec1d747"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b6aef4dc23b06a03b8eb79e51fbc04d428cbf98b59308c03b5e3214486c50791" => :sierra
    sha256 "2e83aea958d16d1c81b326cbadb024817ad0f3629f264d3663dcf543d30eb4e5" => :el_capitan
    sha256 "c014212583629fc9f963876d5478d529e06c8228aa443a165867afe37298ee79" => :yosemite
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
