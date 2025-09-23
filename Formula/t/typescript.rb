class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-5.9.2.tgz"
  sha256 "67a3bc82e822b8f45f653a80fc3a9730d23214d36c83ba85dd7f5abebee82062"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2dbf6aac24a2603aed04b1fcfa4563a277d2cb60678128d65234df70f7acb8df"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
    assert_path_exists testpath/"test.js", "test.js was not generated"
  end
end
