require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  # quicktype should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/quicktype/-/quicktype-20.0.10.tgz"
  sha256 "680176e50abe8110abe731ebf064dd37acf868050b59f9354325b1489db3ef89"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77145e60c772e96c961dbcf8542345a6f1f7eef234b2dcb3c7149657967d0b0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77145e60c772e96c961dbcf8542345a6f1f7eef234b2dcb3c7149657967d0b0f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77145e60c772e96c961dbcf8542345a6f1f7eef234b2dcb3c7149657967d0b0f"
    sha256 cellar: :any_skip_relocation, ventura:        "a707398fe16def471fe6e08f84e760abbdf77bfd5c82843625db8b0b25ba53ca"
    sha256 cellar: :any_skip_relocation, monterey:       "a707398fe16def471fe6e08f84e760abbdf77bfd5c82843625db8b0b25ba53ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "a707398fe16def471fe6e08f84e760abbdf77bfd5c82843625db8b0b25ba53ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77145e60c772e96c961dbcf8542345a6f1f7eef234b2dcb3c7149657967d0b0f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"sample.json").write <<~EOS
      {
        "i": [0, 1],
        "s": "quicktype"
      }
    EOS
    output = shell_output("#{bin}/quicktype --lang typescript --src sample.json")
    assert_match "i: number[];", output
    assert_match "s: string;", output
  end
end
