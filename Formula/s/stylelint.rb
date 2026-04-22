class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-17.8.0.tgz"
  sha256 "6b162f9082937bbfeb07c525c15cfd81e79d5fe994f3585a3ffef7b7fd93b2a7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d446d95cd007f5f6bc1314c1e46c5feb9943560cb4a47ac65da3f679679c4c16"
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
