class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-18.0.0.tgz"
  sha256 "c4afe67deb7470113f8edd18138fc96f64c45007de2ffbae3a6c934e1b535682"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3bd8f152ba5c36e6a7320d05c34fc7c8e75defa23c246daa823e52c11e0bca09"
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
