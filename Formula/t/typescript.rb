class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-7.0.2.tgz"
  sha256 "da2513f4b95176d6dde8b51aab7afe8a927656c9d277369793f77f7e59371c08"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "affa1704c2600fd1b0592c3078f502a5aae315219ad16d2d97cde7ed0f1b9116"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "affa1704c2600fd1b0592c3078f502a5aae315219ad16d2d97cde7ed0f1b9116"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "affa1704c2600fd1b0592c3078f502a5aae315219ad16d2d97cde7ed0f1b9116"
    sha256 cellar: :any_skip_relocation, sonoma:        "d43d82b4b4666e0efe50f007ad7789cc53caad6398dce78dfed29f339da3d112"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe288fe43e9e26d0c130431d5bf5f4b279f8e2eb12fdb3ad50c3f65b89ab63ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05916d95ccabec2eb6703a00e33fb2da3cca33e7cbdac8c665523879a01f117f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"test.ts").write <<~TYPESCRIPT
      class Test {
        greet() {
          return "Hello, world!";
        }
      };
      var test = new Test();
      document.body.innerHTML = test.greet();
    TYPESCRIPT

    system bin/"tsc", "test.ts"
    assert_path_exists testpath/"test.js", "test.js was not generated"
  end
end
