class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.14.1.tgz"
  sha256 "4984085a54dc0ea761eb7024da8b2c01bfa964720ec7cc1115abfa140cb6f1d2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19d0c1319ca9536d49e9244f310bc3ba4cc26952c1eb5fe98c41f381b0f468a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19d0c1319ca9536d49e9244f310bc3ba4cc26952c1eb5fe98c41f381b0f468a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19d0c1319ca9536d49e9244f310bc3ba4cc26952c1eb5fe98c41f381b0f468a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f67a2080a147d82d76092da4a11f5df7c8eb7b178c8962b2242e83bdd4fa6ba"
    sha256 cellar: :any_skip_relocation, ventura:       "8f67a2080a147d82d76092da4a11f5df7c8eb7b178c8962b2242e83bdd4fa6ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19d0c1319ca9536d49e9244f310bc3ba4cc26952c1eb5fe98c41f381b0f468a5"
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
