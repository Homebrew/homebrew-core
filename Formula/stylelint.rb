require "language/node"

class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-15.7.0.tgz"
  sha256 "80a77467360d374e1059ece8772103724164ba80dca0a0f41a4457951a3b776e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01251ac33f7901a0b64e1a33d1d0a698a17416e80da2ff8c051afc9143c9ae20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01251ac33f7901a0b64e1a33d1d0a698a17416e80da2ff8c051afc9143c9ae20"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01251ac33f7901a0b64e1a33d1d0a698a17416e80da2ff8c051afc9143c9ae20"
    sha256 cellar: :any_skip_relocation, ventura:        "c29277a51677415004f695059b1ba221e88fbbb9708eff25ab326b0397b496d9"
    sha256 cellar: :any_skip_relocation, monterey:       "c29277a51677415004f695059b1ba221e88fbbb9708eff25ab326b0397b496d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "c29277a51677415004f695059b1ba221e88fbbb9708eff25ab326b0397b496d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01251ac33f7901a0b64e1a33d1d0a698a17416e80da2ff8c051afc9143c9ae20"
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
