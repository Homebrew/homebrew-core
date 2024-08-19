class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-5.5.4.tgz"
  sha256 "2680b6354d462a1d90a2cf10c790e071f1c45081c9d4561cb47ce23c934d8586"
  license "Apache-2.0"
  head "https://github.com/Microsoft/TypeScript.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25f20a66c0ccdb3f5a1dbcc8587ab3ea5e0fb54e68e550d372e560ffe830be09"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25f20a66c0ccdb3f5a1dbcc8587ab3ea5e0fb54e68e550d372e560ffe830be09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25f20a66c0ccdb3f5a1dbcc8587ab3ea5e0fb54e68e550d372e560ffe830be09"
    sha256 cellar: :any_skip_relocation, sonoma:         "25f20a66c0ccdb3f5a1dbcc8587ab3ea5e0fb54e68e550d372e560ffe830be09"
    sha256 cellar: :any_skip_relocation, ventura:        "25f20a66c0ccdb3f5a1dbcc8587ab3ea5e0fb54e68e550d372e560ffe830be09"
    sha256 cellar: :any_skip_relocation, monterey:       "25f20a66c0ccdb3f5a1dbcc8587ab3ea5e0fb54e68e550d372e560ffe830be09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab7c9619010eaef83e59fa9c5fc564a42c7bbfaa0eb47ebc6af6f99440789c0f"
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
    assert_predicate testpath/"test.js", :exist?, "test.js was not generated"
  end
end
