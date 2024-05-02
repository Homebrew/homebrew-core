require "language/node"

class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.5.0.tgz"
  sha256 "24ac745a57f8a316df64f11c607492c949cc501e2dc3828e21d010e6a5a9dea1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "939b27c532c83e31e4ecf60df2e9584a7d306980bc445aa8436901133bac028d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "939b27c532c83e31e4ecf60df2e9584a7d306980bc445aa8436901133bac028d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "939b27c532c83e31e4ecf60df2e9584a7d306980bc445aa8436901133bac028d"
    sha256 cellar: :any_skip_relocation, sonoma:         "e214f3513881c486559dab92419077f63f12f6805f1f9b090c49ccd6c8fda268"
    sha256 cellar: :any_skip_relocation, ventura:        "e214f3513881c486559dab92419077f63f12f6805f1f9b090c49ccd6c8fda268"
    sha256 cellar: :any_skip_relocation, monterey:       "e214f3513881c486559dab92419077f63f12f6805f1f9b090c49ccd6c8fda268"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "939b27c532c83e31e4ecf60df2e9584a7d306980bc445aa8436901133bac028d"
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
