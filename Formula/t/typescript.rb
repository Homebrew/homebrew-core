class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-6.0.3.tgz"
  sha256 "33cd0ee1beaa8c9e9d15a9da836c62ddea4c34a42d7c2d349dbc80d94165d22a"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9f8f00c55e68d31d727cd36d42e27022f21935edf23e47e57e04cd04c1470317"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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
