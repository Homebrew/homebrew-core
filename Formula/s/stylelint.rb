class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-17.0.0.tgz"
  sha256 "8ef641ad3e8750f3428cdb33ac66efdd0745b616248391c7a16abc221fd7bfc7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "722984df88e2d30ecc09b84e78ad6f4281e869badcb3906163b6a0d86ac02212"
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
    assert_match "Unexpected empty block", output

    assert_match version.to_s, shell_output("#{bin}/stylelint --version")
  end
end
