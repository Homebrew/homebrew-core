class Standard < Formula
  desc "JavaScript Style Guide, with linter & automatic code fixer"
  homepage "https://standardjs.com/"
  url "https://registry.npmjs.org/standard/-/standard-17.1.2.tgz"
  sha256 "fb2aaf22460bb3e77e090c727c694a56dd9a9486eec30a0152290a5c6d83757c"
  license "MIT"
  head "https://github.com/standard/standard.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "7a14e2bf791bc2e08a00dad45552c4fdac41dd10d576c034257475139e6e9e3f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"foo.js").write <<~JS
      console.log("hello there")
      if (name != 'John') { }
    JS
    output = shell_output("#{bin}/standard foo.js 2>&1", 1)
    assert_match "Strings must use singlequote. (quotes)", output
    assert_match "Expected '!==' and instead saw '!='. (eqeqeq)", output
    assert_match "Empty block statement. (no-empty)", output

    assert_match version.to_s, shell_output("#{bin}/standard --version")
  end
end
