require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-3.4.5.tgz"
  sha256 "3c107fa7d3e48a750f12f503a4cd6b312ef0b03b905c5991831167d27a81a8e7"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a1a0de8cbf7008af0bb8fc1f81496e64d9bb8da35f819ac96005544812a7a06e" => :mojave
    sha256 "0758bb23fe71574002a9d2ff6503089da531ec6161f6bc21df41bdab7c2bf7b3" => :high_sierra
    sha256 "69338b6f5f9f32117b0051027a5e9e2b52909a7d04a68ec43201ea65832921a8" => :sierra
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
