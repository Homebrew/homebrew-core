require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-4.1.2.tgz"
  sha256 "383b18630fc00016cb7bde65f111e79d43fccb8c025faf33d7a3a07a5abdf026"
  license "Apache-2.0"
  head "https://github.com/Microsoft/TypeScript.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c93abdaa34e0c3ced956b288e62ece8e799c67ff9d0d88727cd4f6b0307a4c05" => :big_sur
    sha256 "056891ea503aebf06fdf9c54c1f6de5c58153b734155818e3718ecf9019e1cdf" => :catalina
    sha256 "753648f277368246cff33aff097f300fbe34c366f650aa3fa7f1359c19e5bb9d" => :mojave
    sha256 "438d7476dcf8bbf3a754f4d29c06bf7acdeb2abe1e5f89d768a54b0e6b9f3aca" => :high_sierra
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
