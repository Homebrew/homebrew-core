class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.20.0.tgz"
  sha256 "743a70841c93ae3fdcac93d5ef3d30467d1783f4a1d238a301016a96358e0649"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "658a1258491759d9909a54bada33ab7c480f51f0c8148c93a549553d3b5cf9b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "658a1258491759d9909a54bada33ab7c480f51f0c8148c93a549553d3b5cf9b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "658a1258491759d9909a54bada33ab7c480f51f0c8148c93a549553d3b5cf9b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6d62415a7b218b13c8bf79d115c8277e15ef9ac3049e5b9a22cbea9044efbc0"
    sha256 cellar: :any_skip_relocation, ventura:       "b6d62415a7b218b13c8bf79d115c8277e15ef9ac3049e5b9a22cbea9044efbc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "658a1258491759d9909a54bada33ab7c480f51f0c8148c93a549553d3b5cf9b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "658a1258491759d9909a54bada33ab7c480f51f0c8148c93a549553d3b5cf9b8"
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
