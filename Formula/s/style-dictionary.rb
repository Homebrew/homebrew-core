class StyleDictionary < Formula
  desc "Build system for creating cross-platform styles"
  homepage "https://github.com/style-dictionary/style-dictionary"
  url "https://registry.npmjs.org/style-dictionary/-/style-dictionary-5.0.0.tgz"
  sha256 "f8ee73b6b55f75db63eab440f2a72a91efd2fb175baf168294dd067ed63e3bf5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c57727da1d5247d0df445e3a713f4f4b05c079de39097f7305e7294a0ed889f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c57727da1d5247d0df445e3a713f4f4b05c079de39097f7305e7294a0ed889f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c57727da1d5247d0df445e3a713f4f4b05c079de39097f7305e7294a0ed889f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ea502e55352ddc783a2fe366c25fca345b98097f825c71434d0071c102cdfc0"
    sha256 cellar: :any_skip_relocation, ventura:       "0ea502e55352ddc783a2fe366c25fca345b98097f825c71434d0071c102cdfc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c57727da1d5247d0df445e3a713f4f4b05c079de39097f7305e7294a0ed889f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c57727da1d5247d0df445e3a713f4f4b05c079de39097f7305e7294a0ed889f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/style-dictionary --version")

    output = shell_output("#{bin}/style-dictionary init basic")
    assert_match "Source style dictionary starter files created!", output
    assert_path_exists testpath/"config.json"

    output = shell_output("#{bin}/style-dictionary build")
    assert_match "Token collisions detected", output
  end
end
