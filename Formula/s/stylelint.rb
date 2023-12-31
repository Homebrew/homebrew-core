require "language/node"

class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.1.0.tgz"
  sha256 "bb570b62b1f62868ca0ffe5098138fc9ebb979da9285d25e9b2ff526ac288a81"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca8513e61032dbd5037f4170a57ba1add00a843c4de11f4b98fa71f4c7ad03b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca8513e61032dbd5037f4170a57ba1add00a843c4de11f4b98fa71f4c7ad03b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca8513e61032dbd5037f4170a57ba1add00a843c4de11f4b98fa71f4c7ad03b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "cfb209bba82420d2b6386a393554b4786f6f70ed4b86d68013fd1024653a5007"
    sha256 cellar: :any_skip_relocation, ventura:        "cfb209bba82420d2b6386a393554b4786f6f70ed4b86d68013fd1024653a5007"
    sha256 cellar: :any_skip_relocation, monterey:       "cfb209bba82420d2b6386a393554b4786f6f70ed4b86d68013fd1024653a5007"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca8513e61032dbd5037f4170a57ba1add00a843c4de11f4b98fa71f4c7ad03b5"
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
