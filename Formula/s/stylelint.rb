class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-17.9.0.tgz"
  sha256 "b8ca8d3fe605966b28914cf8c652276f34b10508c33896f494762ca7016fde90"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f1da16c84bf2a15d3d7795a110bd429143bc6bd4292096b574d34331cb4d6cab"
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
