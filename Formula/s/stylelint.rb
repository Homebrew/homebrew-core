class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.13.2.tgz"
  sha256 "7ac750eff139d8a54f11ddefd3e6ed388858352b3ab96717f1b968f15399e6b3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2acf16d817f03b35dc9ed6a0cf10fcc24e4f329b4864daf394a9c10465cc1040"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2acf16d817f03b35dc9ed6a0cf10fcc24e4f329b4864daf394a9c10465cc1040"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2acf16d817f03b35dc9ed6a0cf10fcc24e4f329b4864daf394a9c10465cc1040"
    sha256 cellar: :any_skip_relocation, sonoma:        "c81386ffee247b18870275b283181f0981f9c05554b90038076d24219c9e077b"
    sha256 cellar: :any_skip_relocation, ventura:       "c81386ffee247b18870275b283181f0981f9c05554b90038076d24219c9e077b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2acf16d817f03b35dc9ed6a0cf10fcc24e4f329b4864daf394a9c10465cc1040"
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
