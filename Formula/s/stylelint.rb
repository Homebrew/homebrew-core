class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-17.14.1.tgz"
  sha256 "ffa5a507642d63768747d99ab2e4474fc684b1696ffa8d76d8c31f98e652a2b5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8a2610e08e6e0287c58629e8c42cb6fb86bc8942e83c85d8d717930dff55eada"
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
