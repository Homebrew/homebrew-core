class StyleDictionary < Formula
  desc "Build system for creating cross-platform styles"
  homepage "https://github.com/style-dictionary/style-dictionary"
  url "https://registry.npmjs.org/style-dictionary/-/style-dictionary-5.0.1.tgz"
  sha256 "55d3a95e69455eb58a7cc8d1bf3393bc8d020811c444cc2b6ca0114867b8958a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46fd27ccde57b8903f0c0dd1fc9cc84383e1033c8168a029bcf73e4643a6cc2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46fd27ccde57b8903f0c0dd1fc9cc84383e1033c8168a029bcf73e4643a6cc2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "46fd27ccde57b8903f0c0dd1fc9cc84383e1033c8168a029bcf73e4643a6cc2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c7f4c7e7e61c50cc76645599b626beae8db5cc3ac11557af42475d43eac11e4"
    sha256 cellar: :any_skip_relocation, ventura:       "5c7f4c7e7e61c50cc76645599b626beae8db5cc3ac11557af42475d43eac11e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46fd27ccde57b8903f0c0dd1fc9cc84383e1033c8168a029bcf73e4643a6cc2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46fd27ccde57b8903f0c0dd1fc9cc84383e1033c8168a029bcf73e4643a6cc2d"
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
