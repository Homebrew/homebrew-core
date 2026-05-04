class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-17.10.0.tgz"
  sha256 "206748b2effc5851cb0d6a53618c5c3a7c903ec02bf265edba485d984b7ff2a1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "75ceef7f6cc66c1d87a9afcacc80456f2827319f1b85c09b59209786c1de4b52"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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
    assert_match "Empty block", output

    assert_match version.to_s, shell_output("#{bin}/stylelint --version")
  end
end
