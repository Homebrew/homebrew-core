require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-4.1.3.tgz"
  sha256 "213b2677e1f29700601c29e4a603eabe63f87f14fa02fd3633bf141aaa4e0e7e"
  license "Apache-2.0"
  head "https://github.com/Microsoft/TypeScript.git"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e07a4be146fef8a1edc015fd84635d2ee0a8d1ec7358258a6fc21444554a05c0"
    sha256 cellar: :any_skip_relocation, big_sur:       "221b4f01eff3ac25750ac019c95380cf9136ab71d9885c99d0a17f9f1521af95"
    sha256 cellar: :any_skip_relocation, catalina:      "21fbdafc6132436663714241829b4b58eba7c714ca741beb2b1bf918fa9b75dc"
    sha256 cellar: :any_skip_relocation, mojave:        "a5927aa302e6bcef5fd359d0bef1be2928c26f013e9730bfb9f82798b1f6290f"
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
