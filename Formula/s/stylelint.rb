class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.18.0.tgz"
  sha256 "6cceab9c8ec1cba91baa2b35dc56fca86daaedc61a52f235c001440b98916bf1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b786b31634b1268a098cd57ee3fa4e723ed6b40afa900b2323a2ee6531860e27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b786b31634b1268a098cd57ee3fa4e723ed6b40afa900b2323a2ee6531860e27"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b786b31634b1268a098cd57ee3fa4e723ed6b40afa900b2323a2ee6531860e27"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc778e32f7f80b7a87e1a86d4325442bbf11f77312115d81642bbd62195b4d0e"
    sha256 cellar: :any_skip_relocation, ventura:       "fc778e32f7f80b7a87e1a86d4325442bbf11f77312115d81642bbd62195b4d0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b786b31634b1268a098cd57ee3fa4e723ed6b40afa900b2323a2ee6531860e27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b786b31634b1268a098cd57ee3fa4e723ed6b40afa900b2323a2ee6531860e27"
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
