class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.19.1.tgz"
  sha256 "a429c9e8d5a3d5fc396066199aa7126769e1d4ffd3a9da2c0e49d4bafa3b38f3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "143c27ed3713827f92cab5f4650a71a4040fd30c5bb4c13fcfa71ee266ebd917"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "143c27ed3713827f92cab5f4650a71a4040fd30c5bb4c13fcfa71ee266ebd917"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "143c27ed3713827f92cab5f4650a71a4040fd30c5bb4c13fcfa71ee266ebd917"
    sha256 cellar: :any_skip_relocation, sonoma:        "9df24b3985bcb44da8180aa8e2e9cbea80be97246349032d76fa1247db85f5af"
    sha256 cellar: :any_skip_relocation, ventura:       "9df24b3985bcb44da8180aa8e2e9cbea80be97246349032d76fa1247db85f5af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "143c27ed3713827f92cab5f4650a71a4040fd30c5bb4c13fcfa71ee266ebd917"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "143c27ed3713827f92cab5f4650a71a4040fd30c5bb4c13fcfa71ee266ebd917"
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
