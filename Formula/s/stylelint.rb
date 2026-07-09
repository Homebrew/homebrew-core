class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-17.14.0.tgz"
  sha256 "4d73e694e4fc7f76aa08b18519308006a91c2aae7583c408e0912cf7e7f96b75"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "37970efafabd15f14e25608ceaf624e0e810ab460c70e3320a07b4b8881af49b"
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
