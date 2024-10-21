class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.10.0.tgz"
  sha256 "4540dd305b5a356826a7ff61c8470201615dc977284c3884b83121d1f0583ce7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b84871a3361d6ada56b407f36a2148adbc3e977f1c510c153e9db5649951596"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b84871a3361d6ada56b407f36a2148adbc3e977f1c510c153e9db5649951596"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b84871a3361d6ada56b407f36a2148adbc3e977f1c510c153e9db5649951596"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b8f767d8faef8a6e56b8bdba3b25e2d598d300a626a1bed13cd9459c0f3dce7"
    sha256 cellar: :any_skip_relocation, ventura:       "5b8f767d8faef8a6e56b8bdba3b25e2d598d300a626a1bed13cd9459c0f3dce7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b84871a3361d6ada56b407f36a2148adbc3e977f1c510c153e9db5649951596"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".stylelintrc").write <<~EOS
      {
        "rules": {
          "block-no-empty": true
        }
      }
    EOS

    (testpath/"test.css").write <<~EOS
      a {
      }
    EOS

    output = shell_output("#{bin}/stylelint test.css 2>&1", 2)
    assert_match "Unexpected empty block", output

    assert_match version.to_s, shell_output("#{bin}/stylelint --version")
  end
end
