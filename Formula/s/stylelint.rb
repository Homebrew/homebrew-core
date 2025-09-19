class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.24.0.tgz"
  sha256 "dfa13c219c0c2fba44521110c208466332c2ce4d01295832fe8a4bff2c1c6b0f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "22fad4d4cc792ac909b2f94f37a5594ee6fe501ef7222a475c05284f93dc93e8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".stylelintrc").write <<~JSON
      {
        "rules": {
          "block-no-empty": true
        }
      }
    JSON

    (testpath/"test.css").write <<~CSS
      a {
      }
    CSS

    output = shell_output("#{bin}/stylelint test.css 2>&1", 2)
    assert_match "Unexpected empty block", output

    assert_match version.to_s, shell_output("#{bin}/stylelint --version")
  end
end
