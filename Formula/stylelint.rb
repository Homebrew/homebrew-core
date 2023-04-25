require "language/node"

class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-15.6.0.tgz"
  sha256 "fa74af6099d614f73ff5c70038438dd27c663d745fe0adea1b2d8855bd283cb0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "482d2957d3f38d7bf7d1ab63b5800b1947ccc80768aac8beb8ac1ef7482252eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "482d2957d3f38d7bf7d1ab63b5800b1947ccc80768aac8beb8ac1ef7482252eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "482d2957d3f38d7bf7d1ab63b5800b1947ccc80768aac8beb8ac1ef7482252eb"
    sha256 cellar: :any_skip_relocation, ventura:        "b4633cff5b12c92539bd94ad5cba5e4146473deed8706c65e4d5278cb9fd9d2c"
    sha256 cellar: :any_skip_relocation, monterey:       "b4633cff5b12c92539bd94ad5cba5e4146473deed8706c65e4d5278cb9fd9d2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4633cff5b12c92539bd94ad5cba5e4146473deed8706c65e4d5278cb9fd9d2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "482d2957d3f38d7bf7d1ab63b5800b1947ccc80768aac8beb8ac1ef7482252eb"
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
