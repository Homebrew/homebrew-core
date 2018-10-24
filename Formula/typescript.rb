require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-3.1.3.tgz"
  sha256 "2095019035fb39ac34b7fe719e9ea4f197200c6b6429fd167aabdb318a07ab83"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b494ca3d10949803e3874f93aea08bf87cd04a0d8d45768797364ce1c8ae0543" => :mojave
    sha256 "249fc135abf41baa736eb5e787e8ba334ec228821615ad6fa0eec99e499c5068" => :high_sierra
    sha256 "65ce4629b4f9d9a9f84df13072389211d0ac7d8719e3d0e8d082aa345045db0c" => :sierra
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
