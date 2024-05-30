require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.169.tgz"
  sha256 "8fd970d57084cbf725b57f06fa8384087fa5474aaf480110780b2074ba9277a0"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3cb3b960e45ab1c4b98a82faadaf155bd1f7802418f713e286383cdb5ffe35d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3cb3b960e45ab1c4b98a82faadaf155bd1f7802418f713e286383cdb5ffe35d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3cb3b960e45ab1c4b98a82faadaf155bd1f7802418f713e286383cdb5ffe35d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d831db69698d2808b21a038a31615e9b28c35fba81ac0e0d23dfb9047844ad4"
    sha256 cellar: :any_skip_relocation, ventura:        "9d831db69698d2808b21a038a31615e9b28c35fba81ac0e0d23dfb9047844ad4"
    sha256 cellar: :any_skip_relocation, monterey:       "9d831db69698d2808b21a038a31615e9b28c35fba81ac0e0d23dfb9047844ad4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dcec06ce3fc51fb6dcc4442c3b8a4bf25bd02406fbbbf73db308740bccf0009"
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
