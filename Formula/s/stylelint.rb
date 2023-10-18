require "language/node"

class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-15.11.0.tgz"
  sha256 "8d688b4656f653fc350d485739d6d2d8fe834d2916aea25fc5deec0e45fbec9b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac9ea72bd20c7da8ef4bfe7e48e35ec5492a8f8f509da21ba4f6feb837b88705"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac9ea72bd20c7da8ef4bfe7e48e35ec5492a8f8f509da21ba4f6feb837b88705"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac9ea72bd20c7da8ef4bfe7e48e35ec5492a8f8f509da21ba4f6feb837b88705"
    sha256 cellar: :any_skip_relocation, sonoma:         "9571c40a045083c6584c1710ab3c7ea51903f847ca0ec84f7b5c447f17902ef3"
    sha256 cellar: :any_skip_relocation, ventura:        "9571c40a045083c6584c1710ab3c7ea51903f847ca0ec84f7b5c447f17902ef3"
    sha256 cellar: :any_skip_relocation, monterey:       "9571c40a045083c6584c1710ab3c7ea51903f847ca0ec84f7b5c447f17902ef3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac9ea72bd20c7da8ef4bfe7e48e35ec5492a8f8f509da21ba4f6feb837b88705"
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
