class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-17.15.0.tgz"
  sha256 "32b4a80fd409ae20392432f5ca87fc95f32e50cb1ced7ff10c00afe2b32bc285"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "68e16004cd19dca020350548b12309851ec269bc31ac139624c027c298ff1198"
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
