require "language/node"

class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.3.1.tgz"
  sha256 "987820a45842016afdb4a74410d2388ab675b152a44c3c6e5a26c509bee76140"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f576a41679c57bb036a25620385caa0c48e43be15431e7e0d2fd99fd6f441f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f576a41679c57bb036a25620385caa0c48e43be15431e7e0d2fd99fd6f441f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f576a41679c57bb036a25620385caa0c48e43be15431e7e0d2fd99fd6f441f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b6520e448586daf10e19b00faf9a655f582519c48674102d7b49da32ffff64f"
    sha256 cellar: :any_skip_relocation, ventura:        "4b6520e448586daf10e19b00faf9a655f582519c48674102d7b49da32ffff64f"
    sha256 cellar: :any_skip_relocation, monterey:       "4b6520e448586daf10e19b00faf9a655f582519c48674102d7b49da32ffff64f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f576a41679c57bb036a25620385caa0c48e43be15431e7e0d2fd99fd6f441f3"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".stylelintrc").write <<~EOS
      {
        "rules": {
          "block-no-empty": true
        }
      }
    EOS

    (testpath/"test.css").write <<~EOS
      a {
      }
    EOS

    output = shell_output("#{bin}/stylelint test.css 2>&1", 2)
    assert_match "Unexpected empty block", output

    assert_match version.to_s, shell_output("#{bin}/stylelint --version")
  end
end
