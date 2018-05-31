require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "http://typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-2.8.4.tgz"
  sha256 "8d68caa85da66160b0f189b042f40e4ea73955b344283c2e0c78585b794edd22"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1e4d1318b4d343cfe3f75e91489518ba9251c7dc085479f396ee02d2dbb86049" => :high_sierra
    sha256 "c9c879cdc035ed66f576c2406f1e545a22dc7a81739294af8b7780404aeb74e2" => :sierra
    sha256 "7892b538203dec889a303ed0758ef6d00bc177ff73597af9ab0d2049a1863144" => :el_capitan
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
