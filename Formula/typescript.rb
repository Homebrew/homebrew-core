require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "http://typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-2.8.3.tgz"
  sha256 "e912b5aab8de165d9b922161f8aac8c48264ddf9b2d614f1484fa6d2be9e8a8b"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "51b3e25831bf1600abab95385de061602ecf35f1e56c3aa678fc6284e2e10b03" => :high_sierra
    sha256 "01b073eac38c49300c4cfebcd9575e04e60a6e94139fbee4fadf6179cde31b63" => :sierra
    sha256 "be1b1ab92e9a7a37382736b3b9bd7e1955af7ebd04080fbe82896eb43895cdf0" => :el_capitan
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
