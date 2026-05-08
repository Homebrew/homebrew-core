class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-17.11.0.tgz"
  sha256 "33764fffb1ec509777cf0150ad4e1a035eeb5864f7fadbd794ec936b9e96abe8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b67b60d7ad1fbf9ebf46811f554f3b8eb3d9a39c03f105d7f112d117f4412463"
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
