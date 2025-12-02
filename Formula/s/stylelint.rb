class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.26.1.tgz"
  sha256 "d7d3ced2d31007a08f6e873e5848211d4c1e54c64bd13439c594712702fcedd8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6ffd9a82804ed2c480fb3119fcb810893e98c16d396270d20752479df4b67ceb"
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
