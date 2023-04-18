require "language/node"

class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-15.5.0.tgz"
  sha256 "938a879f38a1d11d57e33b0004efef40d60b42565923db51d17fc56e2664fd29"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c75042c7a4a8c0daee2e77475360c0b759b41d70ff62cf2d547e31486440a6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c75042c7a4a8c0daee2e77475360c0b759b41d70ff62cf2d547e31486440a6f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c75042c7a4a8c0daee2e77475360c0b759b41d70ff62cf2d547e31486440a6f"
    sha256 cellar: :any_skip_relocation, ventura:        "36ec4885e3281dfa2131bfabb9b15c121759895c101dadcfa2978759c9287ae2"
    sha256 cellar: :any_skip_relocation, monterey:       "36ec4885e3281dfa2131bfabb9b15c121759895c101dadcfa2978759c9287ae2"
    sha256 cellar: :any_skip_relocation, big_sur:        "36ec4885e3281dfa2131bfabb9b15c121759895c101dadcfa2978759c9287ae2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c75042c7a4a8c0daee2e77475360c0b759b41d70ff62cf2d547e31486440a6f"
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
